import io


# Writes bytes as hex constants or raw expressions for the initializer of a
# C array of 'unsigned char'.  Each line starts with a fixed number of tab
# characters and is kept below a configurable length limit (each tab counts
# as 8 characters).  A newline is inserted before the first element; commas
# are used as separators.
class BlobWriter:

    def __init__(self, w: io.TextIOBase, max_line_len: int, indent: int):
        """
        w            - text writer to output into
        max_line_len - target line length in characters
        indent       - number of leading tab characters per line
        """
        self._w            = w
        self._max_line_len = max_line_len
        self._indent       = indent
        self._line_len     = -1   # -1 means no line has been started yet

    def _do_nl(self):
        """Start a new indented line."""
        self._w.write('\n')
        self._w.write('\t' * self._indent)
        self._line_len = self._indent * 8

    def append_byte(self, b: int):
        """
        Append a single byte value; it is emitted as a hex constant (0xNN).
        """
        if self._line_len < 0:
            self._do_nl()
        else:
            self._w.write(',')
            self._line_len += 1
            if (self._line_len + 5) > self._max_line_len:
                self._do_nl()
            else:
                self._w.write(' ')
                self._line_len += 1
        self._w.write(f'0x{b:02X}')
        self._line_len += 4

    def append_expr(self, expr: str):
        """
        Append a C expression as-is.  The expression may expand to multiple
        bytes if it contains internal commas.  A newline will not be inserted
        inside the expression itself.
        """
        if self._line_len < 0:
            self._do_nl()
        else:
            self._w.write(',')
            self._line_len += 1
            if (self._line_len + 1 + len(expr)) > self._max_line_len:
                self._do_nl()
            else:
                self._w.write(' ')
                self._line_len += 1
        self._w.write(expr)
        self._line_len += len(expr)


class ConstData:
    """
    A growable buffer of constant byte data accumulated during compilation.
    Supports multi-byte reads/writes and UTF-8 string storage.
    """

    def __init__(self, ctx):
        """ctx must expose a next_blob_id() method (i.e. a T0Comp instance)."""
        self.id      = ctx.next_blob_id()
        self.address = 0          # assigned during code generation
        self._buf    = bytearray(4)
        self._len    = 0

    # ------------------------------------------------------------------
    # Properties
    # ------------------------------------------------------------------

    @property
    def length(self) -> int:
        return self._len

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _expand(self, extra: int):
        """Ensure the buffer can hold at least extra more bytes."""
        needed = self._len + extra
        if needed > len(self._buf):
            new_size = max(len(self._buf) * 2, needed)
            self._buf.extend(bytearray(new_size - len(self._buf)))

    def _check_index(self, off: int, dlen: int):
        if off < 0 or off > (self._len - dlen):
            raise IndexError(f"offset {off} out of range (len={self._len})")

    # ------------------------------------------------------------------
    # Write helpers
    # ------------------------------------------------------------------

    def add8(self, b: int):
        """Append one byte."""
        self._expand(1)
        self._buf[self._len] = b & 0xFF
        self._len += 1

    def add16(self, x: int):
        """Append a big-endian 16-bit value."""
        self._expand(2)
        self._buf[self._len]     = (x >> 8) & 0xFF
        self._buf[self._len + 1] = x & 0xFF
        self._len += 2

    def add24(self, x: int):
        """Append a big-endian 24-bit value."""
        self._expand(3)
        self._buf[self._len]     = (x >> 16) & 0xFF
        self._buf[self._len + 1] = (x >> 8)  & 0xFF
        self._buf[self._len + 2] = x & 0xFF
        self._len += 3

    def add32(self, x: int):
        """Append a big-endian 32-bit value."""
        self._expand(4)
        self._buf[self._len]     = (x >> 24) & 0xFF
        self._buf[self._len + 1] = (x >> 16) & 0xFF
        self._buf[self._len + 2] = (x >> 8)  & 0xFF
        self._buf[self._len + 3] = x & 0xFF
        self._len += 4

    def add_string(self, s: str):
        """Append a NUL-terminated UTF-8 string."""
        encoded = s.encode('utf-8')
        self._expand(len(encoded) + 1)
        for i, b in enumerate(encoded):
            self._buf[self._len + i] = b
        self._buf[self._len + len(encoded)] = 0
        self._len += len(encoded) + 1

    # ------------------------------------------------------------------
    # In-place modification
    # ------------------------------------------------------------------

    def set8(self, off: int, v: int):
        """Overwrite one byte at position off."""
        self._check_index(off, 1)
        self._buf[off] = v & 0xFF

    # ------------------------------------------------------------------
    # Read helpers
    # ------------------------------------------------------------------

    def read8(self, off: int) -> int:
        self._check_index(off, 1)
        return self._buf[off]

    def read16(self, off: int) -> int:
        self._check_index(off, 2)
        return (self._buf[off] << 8) | self._buf[off + 1]

    def read24(self, off: int) -> int:
        self._check_index(off, 3)
        return (self._buf[off] << 16) | (self._buf[off + 1] << 8) | self._buf[off + 2]

    def read32(self, off: int) -> int:
        self._check_index(off, 4)
        return ((self._buf[off]     << 24) | (self._buf[off + 1] << 16)
              | (self._buf[off + 2] <<  8) |  self._buf[off + 3])

    def to_string(self, off: int = 0) -> str:
        """
        Decode a NUL-terminated UTF-8 string starting at offset off and
        return it as a Python str.
        """
        result = []
        while True:
            cp, off = self._decode_utf8(off)
            if cp == 0:
                return ''.join(result)
            result.append(chr(cp))

    def _decode_utf8(self, off: int):
        """
        Decode one UTF-8 code point starting at off.
        Returns (codepoint, new_off).  Falls back to the raw byte value on
        any encoding error (mirrors the original C# behaviour).
        """
        if off >= self._len:
            raise IndexError("decode past end of buffer")
        x = self._buf[off]
        off += 1

        if x < 0xC0 or x > 0xF7:
            return x, off

        if x >= 0xF0:
            elen, acc = 3, x & 0x07
        elif x >= 0xE0:
            elen, acc = 2, x & 0x0F
        else:
            elen, acc = 1, x & 0x1F

        if off + elen > self._len:
            return x, off   # truncated sequence — return raw byte

        for i in range(elen):
            y = self._buf[off + i]
            if y < 0x80 or y >= 0xC0:
                return x, off   # invalid continuation byte
            acc = (acc << 6) | (y & 0x3F)

        if acc > 0x10FFFF:
            return x, off   # out-of-range code point

        return acc, off + elen

    # ------------------------------------------------------------------
    # Output
    # ------------------------------------------------------------------

    def encode(self, bw: BlobWriter):
        """Write all bytes to a BlobWriter."""
        for i in range(self._len):
            bw.append_byte(self._buf[i])
