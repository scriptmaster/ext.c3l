from typing import Optional, Union

class SType:
    """
    This structure contains the stack effect of a word: number of stack
    elements consumed on input, and number of stack elements produced on
    output.
    """

    # Special value for the unknown stack effect.
    UNKNOWN: "SType"

    # Constant for the "blank stack effect".
    BLANK: "SType"

    def __init__(self, din, dout):
        self._din = din if din >= 0 else -1
        self._dout = dout if dout >= 0 else -1

    @property
    def data_in(self):
        """
        Get number of stack elements consumed on input;
        this is -1 if the stack effect is not known.
        """
        return self._din

    @property
    def data_out(self):
        """
        Get number of stack elements produced on output;
        this is -1 if either the stack effect is not known,
        or if the word never exits.
        """
        return self._dout

    @property
    def is_known(self):
        """Tell whether the stack effect is known."""
        return self._din >= 0

    @property
    def no_exit(self):
        """Tell whether the stack effect is known and the word never exits."""
        return self._din >= 0 and self._dout < 0

    def __eq__(self, other):
        if not isinstance(other, SType):
            return NotImplemented
        return self._din == other._din and self._dout == other._dout

    def __ne__(self, other):
        if not isinstance(other, SType):
            return NotImplemented
        return self._din != other._din or self._dout != other._dout

    def __hash__(self):
        return self._din * 31 + self._dout * 17

    def __repr__(self):
        if not self.is_known:
            return "UNKNOWN"
        elif self.no_exit:
            return f"in:{self._din},noexit"
        else:
            return f"in:{self._din},out:{self._dout}"

    def is_sub_of(self, s):
        """
        Test whether this stack effect is a sub-effect of the provided
        stack effect s. Stack effect s1 is a sub-effect of stack-effect
        s2 if any of the following holds:
          - s1 and s2 are known, s1.din <= s2.din and s1 does not exit.
          - s1 and s2 are known, s1.din <= s2.din, s1 and s2 exit,
            and s1.din - s1.dout == s2.din - s2.dout.
        """
        if not self.is_known or not s.is_known:
            return False
        if self._din > s._din:
            return False
        if self.no_exit:
            return True
        if s.no_exit:
            return False
        return (self._din - self._dout) == (s._din - s._dout)


SType.UNKNOWN = SType(-1, -1)
SType.BLANK = SType(0, 0)





class TPointerBase:

    def to_bool(self, vp):
        return True

    def execute(self, ctx, cpu):
        raise Exception(f"value is not an xt")

    def to_string(self, vp):
        return f"{type(self).__name__}+{vp.x}"

    def equals(self, tp):
        return self is tp

    def __repr__(self):
        return f"{type(self).__name__}()"




class TPointerBlob(TPointerBase):

    def __init__(self, blob_or_owner, s: str = None):
        """
        Two constructor signatures:
          TPointerBlob(cd)
          TPointerBlob(owner, s)
        """
        from const_data import ConstData

        if s is None:
            # TPointerBlob(cd)
            self.blob: ConstData = blob_or_owner
        else:
            # TPointerBlob(owner, s)
            self.blob = ConstData(blob_or_owner)
            self.blob.add_string(s)

    def to_string(self, vp):
        return self.blob.to_string(vp.x)

    def equals(self, tp):
        if not isinstance(tp, TPointerBlob):
            return False
        return self.blob == tp.blob



class TPointerExpr(TPointerBase):

    def __init__(self, expr, min_val, max_val):
        self._expr = expr
        self._min = min_val
        self._max = max_val

    def to_bool(self, vp):
        raise Exception("Cannot evaluate C-expr at compile time")

    def to_string(self, vp):
        return self.to_c_expr(vp.x)

    def to_c_expr(self, off):
        if off == 0:
            return self._expr
        elif off > 0:
            return f"(uint32_t)({self._expr}) + {off}"
        else:
            return f"(uint32_t)({self._expr}) - {-off}"

    def get_max_bit_length(self, off):
        rmin = self._min + off
        rmax = self._max + off
        num_bits = 1
        if rmin < 0:
            num_bits = max(num_bits, TPointerExpr._bit_length(rmin))
        if rmax > 0:
            num_bits = max(num_bits, TPointerExpr._bit_length(rmax))
        return min(num_bits, 32)

    @staticmethod
    def _bit_length(v):
        """
        Get the minimal bit length of a value. This is for a signed
        representation: the length includes a sign bit. Thus, the
        returned value will be at least 1.
        """
        num = 1
        if v < 0:
            while v != -1:
                num += 1
                v >>= 1
        else:
            while v != 0:
                num += 1
                v >>= 1
        return num



class TPointerNull(TPointerBase):

    def to_bool(self, vp):
        return False

    def to_string(self, vp):
        return "null"

    def equals(self, tp):
        return isinstance(tp, TPointerNull)



class TPointerXT(TPointerBase):

    def __init__(self, name_or_target):
        """
        Two constructor signatures:
          TPointerXT(name)
          TPointerXT(target)
        """
        from word import Word

        if isinstance(name_or_target, Word):
            self.name: str = name_or_target.name
            self.target: Optional["Word"] = name_or_target
        else:
            self.name = name_or_target
            self.target = None

    def resolve(self, ctx):
        if self.target is None:
            self.target = ctx.lookup(self.name)

    def execute(self, ctx, cpu):
        self.resolve(ctx)
        self.target.run(cpu)

    def to_string(self, vp):
        return f"<'{self.name}>"

    def equals(self, tp):
        if not isinstance(tp, TPointerXT):
            return False
        return self.name == tp.name



# Each value is represented with a TValue. Integers use the 'x' field
# with 'ptr' set to None; for pointers, 'ptr' is used and 'x' is an
# offset into the object represented by 'ptr'.

class TValue:

    def __init__(self,
                 x: Union[int, bool] = 0,
                 ptr: Optional[TPointerBase] = None):
        """
        Constructor signatures:
          TValue(x)          — integer value
          TValue(x)         — stored as signed int32
          TValue(b)         — True → -1, False → 0
          TValue(x, ptr)     — pointer with offset
        """
        if isinstance(x, bool):
            self.x: int = -1 if x else 0
        else:
            # Truncate to signed 32-bit range (handles uint cast)
            self.x = TValue._to_int32(x)
        self.ptr: Optional[TPointerBase] = ptr

    @staticmethod
    def _to_int32(v):
        """Reinterpret as signed 32-bit integer (mirrors C# int/uint cast)."""
        v = v & 0xFFFFFFFF
        if v >= 0x80000000:
            v -= 0x100000000
        return v

    # ------------------------------------------------------------------
    # Properties
    # ------------------------------------------------------------------

    @property
    def bool_val(self):
        """
        Convert this value to a boolean; integer 0 and null pointer are
        False, other values are True.
        """
        if self.ptr is None:
            return self.x != 0
        return self.ptr.to_bool(self)

    @property
    def int_val(self):
        """
        Get this value as an integer. Pointers cannot be converted to
        integers.
        """
        if self.ptr is None:
            return self.x
        raise Exception(f"not an integer")

    @property
    def uint_val(self):
        """
        Get this value as an unsigned integer. This is the integer
        value reduced modulo 2^32 in the 0..2^32-1 range.
        """
        return self.int_val & 0xFFFFFFFF

    # ------------------------------------------------------------------
    # Methods
    # ------------------------------------------------------------------

    def __repr__(self):
        """
        String format of integers uses decimal representation.
        For pointers, this depends on the pointed-to value.
        """
        if self.ptr is None:
            return str(self.x)
        return self.ptr.to_string(self)

    def execute(self, ctx, cpu):
        """If this value is an XT, execute it. Otherwise raise."""
        self.to_xt().execute(ctx, cpu)

    def to_xt(self):
        """Convert this value to an XT. Raises on failure."""
        if not isinstance(self.ptr, TPointerXT):
            raise Exception(f"value is not an xt")
        return self.ptr

    def equals(self, v):
        """Compare this value to another."""
        if self.x != v.x:
            return False
        if self.ptr is v.ptr:
            return True
        if self.ptr is None or v.ptr is None:
            return False
        return self.ptr.equals(v.ptr)

    # ------------------------------------------------------------------
    # Convenience factory methods (replaces implicit cast operators)
    # ------------------------------------------------------------------

    @staticmethod
    def from_bool(val):
        return TValue(val)

    @staticmethod
    def from_int(val):
        return TValue(TValue._to_int32(val))

    @staticmethod
    def from_uint(val):
        return TValue(TValue._to_int32(val))
