from abc import ABC, abstractmethod


class CodeElement(ABC):

    def __init__(self):
        self.address = -1
        self.last_length = 0

    def set_jump_target(self, target):
        raise Exception("Code element accepts no target")

    @abstractmethod
    def get_length(self, one_byte_code):
        pass

    @abstractmethod
    def encode(self, bw, one_byte_code):
        pass

    # ------------------------------------------------------------------
    # Static encoding helpers
    # ------------------------------------------------------------------

    @staticmethod
    def encode_one_byte(val, bw):
        if val > 255:
            raise Exception(f"Cannot encode '{val}' over one byte")
        bw.append(val & 0xFF)
        return 1

    @staticmethod
    def encode_7e_unsigned(val, bw):
        """Encode an unsigned integer in 7-bit little-endian base-128 format."""
        length = 1
        w = val
        while w >= 0x80:
            length += 1
            w >>= 7
        if bw is not None:
            for k in range((length - 1) * 7, -1, -7):
                x = (val >> k) & 0x7F
                if k > 0:
                    x |= 0x80
                bw.append(x)
        return length

    @staticmethod
    def encode_7e_signed(val, bw):
        """Encode a signed integer in 7-bit little-endian base-128 format."""
        length = 1
        if val < 0:
            w = val
            while w < -0x40:
                length += 1
                w >>= 7
        else:
            w = val
            while w >= 0x40:
                length += 1
                w >>= 7
        if bw is not None:
            for k in range((length - 1) * 7, -1, -7):
                x = (val >> k) & 0x7F
                if k > 0:
                    x |= 0x80
                bw.append(x)
        return length




class CodeElementJump(CodeElement):

    def __init__(self, jump_type):
        super().__init__()
        self._jump_type = jump_type
        self._target = None

    def set_jump_target(self, target):
        self._target = target

    @property
    def _jump_off(self):
        if self._target is None or self.address < 0 or self._target.address < 0:
            return None
        return self._target.address - (self.address + self.last_length)

    def get_length(self, one_byte_code):
        length = 1 if one_byte_code else \
            CodeElement.encode_7e_unsigned(self._jump_type, None)
        joff = self._jump_off
        if joff is None:
            length += 1
        else:
            length += CodeElement.encode_7e_signed(joff, None)
        return length

    def encode(self, bw, one_byte_code):
        if bw is None:
            return self.get_length(one_byte_code)
        if one_byte_code:
            length = CodeElement.encode_one_byte(self._jump_type, bw)
        else:
            length = CodeElement.encode_7e_unsigned(self._jump_type, bw)
        joff = self._jump_off
        if joff is None:
            raise Exception("Unresolved addresses")
        return length + CodeElement.encode_7e_signed(joff, bw)





class CodeElementUInt(CodeElement):

    def __init__(self, val):
        super().__init__()
        self._val = val

    def get_length(self, one_byte_code):
        return 1 if one_byte_code else \
            CodeElement.encode_7e_unsigned(self._val, None)

    def encode(self, bw, one_byte_code):
        return CodeElement.encode_one_byte(self._val, bw) if one_byte_code \
            else CodeElement.encode_7e_unsigned(self._val, bw)





class CodeElementUIntExpr(CodeElement):

    def __init__(self, val, cx, off):
        super().__init__()
        self._val = val
        self._cx = cx    # TPointerExpr
        self._off = off

    def get_length(self, one_byte_code):
        length = 1 if one_byte_code else \
            CodeElement.encode_7e_unsigned(self._val, None)
        return length + (self._cx.get_max_bit_length(self._off) + 6) // 7

    def encode(self, bw, one_byte_code):
        if one_byte_code:
            len1 = CodeElement.encode_one_byte(self._val, bw)
        else:
            len1 = CodeElement.encode_7e_unsigned(self._val, bw)
        len2 = (self._cx.get_max_bit_length(self._off) + 6) // 7
        bw.append(f"T0_INT{len2}({self._cx.to_c_expr(self._off)})")
        return len1 + len2




class CodeElementUIntInt(CodeElement):

    def __init__(self, val1, val2):
        super().__init__()
        self._val1 = val1
        self._val2 = val2

    def get_length(self, one_byte_code):
        return (1 if one_byte_code else
                CodeElement.encode_7e_unsigned(self._val1, None)) \
             + CodeElement.encode_7e_signed(self._val2, None)

    def encode(self, bw, one_byte_code):
        if one_byte_code:
            length = CodeElement.encode_one_byte(self._val1, bw)
        else:
            length = CodeElement.encode_7e_unsigned(self._val1, bw)
        length += CodeElement.encode_7e_signed(self._val2, bw)
        return length





class CodeElementUIntUInt(CodeElement):

    def __init__(self, val1, val2):
        super().__init__()
        self._val1 = val1
        self._val2 = val2

    def get_length(self, one_byte_code):
        return (1 if one_byte_code else
                CodeElement.encode_7e_unsigned(self._val1, None)) \
             + CodeElement.encode_7e_unsigned(self._val2, None)

    def encode(self, bw, one_byte_code):
        if one_byte_code:
            length = CodeElement.encode_one_byte(self._val1, bw)
        else:
            length = CodeElement.encode_7e_unsigned(self._val1, bw)
        length += CodeElement.encode_7e_unsigned(self._val2, bw)
        return length
