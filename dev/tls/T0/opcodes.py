from abc import ABC, abstractmethod


class Opcode(ABC):

    def __init__(self):
        pass

    @abstractmethod
    def run(self, cpu):
        """Execute this opcode."""
        pass

    def resolve_target(self, target):
        """Resolve the target (word reference) for this opcode."""
        raise Exception("Not a call opcode")

    def resolve_jump(self, disp):
        """
        Resolve the jump offset for this opcode. Displacement is
        relative to the address of the opcode that immediately follows
        the jump code; thus, 0 implies no jump at all.
        """
        raise Exception("Not a jump opcode")

    def get_reference(self, ctx):
        """
        Get the Word that this opcode references; this can happen
        only with 'call' and 'const' opcodes. For all other opcodes,
        this method returns None.
        """
        return None

    def get_data_block(self, ctx):
        """
        Get the data block that this opcode references; this can happen
        only with 'const' opcodes. For all other opcodes, this method
        returns None.
        """
        return None

    @property
    def may_fall_through(self):
        """
        Test whether this opcode may fall through, i.e. execution
        may at least potentially proceed to the next opcode.
        """
        return True

    @property
    def jump_disp(self):
        """Get jump displacement. For non-jump opcodes, this returns 0."""
        return 0

    @property
    def stack_action(self):
        """
        Get stack effect for this opcode (number of elements added to
        the stack, could be negative). For OpcodeCall, this returns 0.
        """
        return 0

    @abstractmethod
    def to_code_element(self):
        pass

    def fix_up(self, gcode, off):
        """
        Called for the CodeElement corresponding to this opcode at
        gcode[off]; used to compute actual byte jump offsets when
        converting code to C.
        """
        pass





class OpcodeCall(Opcode):

    def __init__(self, target=None):
        super().__init__()
        self._target = target

    def resolve_target(self, target):
        if self._target is not None:
            raise Exception("Opcode already resolved")
        self._target = target

    def run(self, cpu):
        self._target.run(cpu)

    def get_reference(self, ctx):
        if self._target is None:
            raise Exception("Unresolved call target")
        return self._target

    def to_code_element(self):
        from code_element_uint import CodeElementUInt
        return CodeElementUInt(self._target.slot)

    def __repr__(self):
        name = "UNRESOLVED" if self._target is None else self._target.name
        return f"call {name}"




class OpcodeConst(Opcode):

    def __init__(self, val):
        super().__init__()
        self._val = val  # TValue

    def run(self, cpu):
        cpu.push(self._val)

    def get_reference(self, ctx):
        from typesys import TPointerXT
        xt = self._val.ptr
        if not isinstance(xt, TPointerXT):
            return None
        xt.resolve(ctx)
        return xt.target

    def get_data_block(self, ctx):
        from typesys import TPointerBlob
        bp = self._val.ptr
        return bp.blob if isinstance(bp, TPointerBlob) else None

    def to_code_element(self):
        from typesys import TPointerXT, TPointerBlob, TPointerExpr
        from code_element_uint_int import CodeElementUIntInt
        from code_element_uint_expr import CodeElementUIntExpr

        ptr = self._val.ptr

        if ptr is None:
            return CodeElementUIntInt(1, self._val.int_val)

        if isinstance(ptr, TPointerXT):
            if self._val.x != 0:
                raise Exception("Cannot compile XT: non-zero offset")
            return CodeElementUIntInt(1, ptr.target.slot)

        if isinstance(ptr, TPointerBlob):
            return CodeElementUIntInt(1, self._val.x + ptr.blob.address)

        if isinstance(ptr, TPointerExpr):
            return CodeElementUIntExpr(1, ptr, self._val.x)

        raise Exception(
            f"Cannot embed constant (type = {type(ptr).__qualname__})")

    @property
    def stack_action(self):
        return 1

    def __repr__(self):
        return f"const {self._val}"




class OpcodeGetLocal(Opcode):

    def __init__(self, num):
        super().__init__()
        self._num = num

    def run(self, cpu):
        cpu.push(cpu.get_local(self._num))

    def to_code_element(self):
        from code_element_uint_uint import CodeElementUIntUInt
        return CodeElementUIntUInt(2, self._num)

    @property
    def stack_action(self):
        return 1

    def __repr__(self):
        return f"getlocal {self._num}"



class OpcodeJump(Opcode):

    def __init__(self, disp=None):
        super().__init__()
        self._disp = disp  # None = unresolved (replaces Int32.MinValue)

    @property
    def jump_disp(self):
        return self._disp

    def run(self, cpu):
        cpu.ip_off += self._disp

    def resolve_jump(self, disp):
        if self._disp is not None:
            raise Exception("Jump already resolved")
        self._disp = disp

    def fix_up(self, gcode, off):
        gcode[off].set_jump_target(gcode[off + 1 + self._disp])



class OpcodeJumpIf(OpcodeJump):

    def __init__(self, disp=None):
        super().__init__(disp)

    def run(self, cpu):
        v = cpu.pop()
        if v.bool_val:
            super().run(cpu)

    @property
    def stack_action(self):
        return -1

    def to_code_element(self):
        from code_element_jump import CodeElementJump
        return CodeElementJump(5)

    def __repr__(self):
        if self._disp is None:
            return "jumpif UNRESOLVED"
        return f"jumpif disp={self._disp}"





class OpcodeJumpIfNot(OpcodeJump):

    def __init__(self, disp=None):
        super().__init__(disp)

    def run(self, cpu):
        v = cpu.pop()
        if not v.bool_val:
            super().run(cpu)

    @property
    def stack_action(self):
        return -1

    def to_code_element(self):
        from code_element_jump import CodeElementJump
        return CodeElementJump(6)

    def __repr__(self):
        if self._disp is None:
            return "jumpifnot UNRESOLVED"
        return f"jumpifnot disp={self._disp}"




class OpcodeJumpUncond(OpcodeJump):

    def __init__(self, disp=None):
        super().__init__(disp)

    @property
    def may_fall_through(self):
        # Unconditional jumps do not "fall through" unless they
        # happen to be a jump to the next instruction...
        return self._disp == 0

    def to_code_element(self):
        from code_element_jump import CodeElementJump
        return CodeElementJump(4)

    def __repr__(self):
        if self._disp is None:
            return "jump UNRESOLVED"
        return f"jump disp={self._disp}"





class OpcodePutLocal(Opcode):

    def __init__(self, num):
        super().__init__()
        self._num = num

    def run(self, cpu):
        cpu.put_local(self._num, cpu.pop())

    def to_code_element(self):
        from code_element_uint_uint import CodeElementUIntUInt
        return CodeElementUIntUInt(3, self._num)

    @property
    def stack_action(self):
        return -1

    def __repr__(self):
        return f"putlocal {self._num}"




class OpcodeRet(Opcode):

    def run(self, cpu):
        cpu.exit()

    @property
    def may_fall_through(self):
        return False

    def to_code_element(self):
        from code_element_uint import CodeElementUInt
        return CodeElementUInt(0)

    def __repr__(self):
        return "ret"
