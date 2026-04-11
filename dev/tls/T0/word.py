
from typesys import *


# A "word" is a function with a name. Words can be either native or
# interpreted; native words are implemented as some in-compiler special
# code.
#
# Some native words (not all of them) have a C implementation and can
# thus be part of the generated C code. Native words with no C
# implementation can be used only during compilation; this is typically
# the case for words that support the syntax (e.g. 'if').

class Word:

    def __init__(self, owner, name):
        # The compiler context for this word.
        self._tc = owner

        # Each word has a unique name. Names are case-sensitive.
        self._name = name

        # Immediate words are executed immediately when encountered in
        # the source code, even while compiling another word.
        self.immediate = False

        # Words are allocated slot numbers when output code is generated.
        self.slot = 0

        # Each word may have a known stack effect.
        self.stack_effect = SType.UNKNOWN

        # All words may have an explicit C implementation.
        self.c_code = None

    @property
    def tc(self):
        return self._tc

    @property
    def name(self):
        return self._name

    def resolve(self):
        """
        Resolving a word means looking up all references to external
        words.
        """
        pass

    def run(self, cpu):
        """
        Execute this word. If the word is native, then its code is
        run right away; if the word is interpreted, then the entry
        sequence is executed.
        """
        raise Exception(f"cannot run '{self._name}' at compile-time")

    def get_references(self):
        """
        Get all words referenced from this one. This implies
        resolving the word.
        """
        return []

    def get_data_blocks(self):
        """
        Get all data blocks directly referenced from this one. This
        implies resolving the word.
        """
        return []

    def generate_code_elements(self, dst):
        """Produce the code elements for this word."""
        raise Exception("Word does not yield code elements")

    def analyse_flow(self):
        """Compute/verify stack effect for this word."""
        pass

    @property
    def max_data_stack(self):
        """
        Get maximum data stack usage for this word. This is the number
        of extra slots that this word may need on the data stack. If
        the stack effect is not known, this returns -1.
        """
        se = self.stack_effect
        if not se.is_known:
            return -1
        if se.no_exit:
            return 0
        return min(0, se.data_out - se.data_in)

    @property
    def max_return_stack(self):
        """Get maximum return stack usage for this word."""
        return 0




# A WordBuilder instance organizes construction of a new interpreted word.
#
# Opcodes are accumulated with specific methods. A control-flow stack
# is maintained to resolve jumps.
#
# Each instance shall be used for only one word.

class WordBuilder:

    def __init__(self, tc, name):
        self._tc = tc
        self._name = name
        self._cf_stack = [0] * 16
        self._cf_ptr = -1
        self._code = []
        self._to_resolve = []
        self._locals = {}
        self._jump_to_last = True
        self.stack_effect = SType.UNKNOWN

    # ------------------------------------------------------------------
    # Build
    # ------------------------------------------------------------------

    def build(self):
        """
        Build the word. The control-flow stack must be empty. A 'ret'
        opcode is automatically appended if required.
        """
        if self._cf_ptr != -1:
            raise Exception("control-flow stack is not empty")
        if self._jump_to_last or self._code[-1].may_fall_through:
            self.ret()
        from word_interpreted import WordInterpreted
        w = WordInterpreted(self._tc, self._name, len(self._locals),
                            list(self._code), list(self._to_resolve))
        w.stack_effect = self.stack_effect
        return w

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _add(self, op, ref_name=None):
        self._code.append(op)
        self._to_resolve.append(ref_name)
        self._jump_to_last = False

    # ------------------------------------------------------------------
    # Control-flow stack
    # ------------------------------------------------------------------

    def cs_roll(self, depth):
        """Rotate the control-flow stack at depth 'depth'."""
        x = self._cf_stack[self._cf_ptr - depth]
        for i in range(depth):
            self._cf_stack[self._cf_ptr - depth + i] = \
                self._cf_stack[self._cf_ptr - depth + i + 1]
        self._cf_stack[self._cf_ptr] = x

    def cs_pick(self, depth):
        """
        Make a copy of the control-flow element at depth 'depth', and
        push it on top of the control-flow stack.
        """
        x = self._cf_stack[self._cf_ptr - depth]
        self._cs_push(x)

    def _cs_push(self, x):
        self._cf_ptr += 1
        if self._cf_ptr == len(self._cf_stack):
            self._cf_stack.extend([0] * len(self._cf_stack))
        self._cf_stack[self._cf_ptr] = x

    def _cs_pop(self):
        x = self._cf_stack[self._cf_ptr]
        self._cf_ptr -= 1
        return x

    def cs_push_orig(self):
        """
        Push an origin on the control-flow stack, corresponding to the
        next opcode to add.
        """
        self._cs_push(len(self._code))

    def cs_push_dest(self):
        """
        Push a destination on the control-flow stack, corresponding to
        the next opcode to add.
        """
        self._cs_push(-len(self._code) - 1)

    def cs_pop_orig(self):
        """
        Pop an origin from the control-flow stack. An exception is
        thrown if the value is not an origin.
        """
        x = self._cs_pop()
        if x < 0:
            raise Exception("not an origin")
        return x

    def cs_pop_dest(self):
        """
        Pop a destination from the control-flow stack. An exception is
        thrown if the value is not a destination.
        """
        x = self._cs_pop()
        if x >= 0:
            raise Exception("not a destination")
        return -x - 1

    # ------------------------------------------------------------------
    # Opcode emitters
    # ------------------------------------------------------------------

    def literal(self, v):
        """Add a 'push literal' opcode."""
        from opcodes import OpcodeConst
        self._add(OpcodeConst(v))

    def call(self, target):
        """
        Compile a 'call' by name, with local variable support:
          - '>name'  → put local
          - 'name'   → get local (if defined), else call word
        """
        from opcodes import OpcodeCall, OpcodeGetLocal, OpcodePutLocal
        if target.startswith(">"):
            lname = target[1:]
            write = True
        else:
            lname = target
            write = False

        if lname in self._locals:
            lnum = self._locals[lname]
            if write:
                self._add(OpcodePutLocal(lnum))
            else:
                self._add(OpcodeGetLocal(lnum))
        else:
            self._add(OpcodeCall(), target)

    def call_ext(self, target):
        """
        Add a 'call' opcode to a word or unresolved name.
        Ignores local variables.
        """
        from opcodes import OpcodeCall
        if isinstance(target, str):
            self._add(OpcodeCall(), target)
        else:
            # target is a Word instance
            self._add(OpcodeCall(target), None)

    def get_local(self, name):
        """
        Add a 'get local' opcode; the provided local name must already
        be defined.
        """
        from opcodes import OpcodeGetLocal
        if name in self._locals:
            self._add(OpcodeGetLocal(self._locals[name]))
        else:
            raise Exception(f"no such local: {name}")

    def put_local(self, name):
        """
        Add a 'put local' opcode; the provided local name must already
        be defined.
        """
        from opcodes import OpcodePutLocal
        if name in self._locals:
            self._add(OpcodePutLocal(self._locals[name]))
        else:
            raise Exception(f"no such local: {name}")

    def def_local(self, lname):
        """Define a new local name."""
        if lname in self._locals:
            raise Exception(f"local already defined: {lname}")
        self._locals[lname] = len(self._locals)

    def call_xt(self, xt):
        """
        Add a 'call' opcode whose target is an XT value (which may be
        resolved or as yet unresolved).
        """
        from opcodes import OpcodeCall
        if xt.target is None:
            self._add(OpcodeCall(), xt.name)
        else:
            self._add(OpcodeCall(xt.target))

    def ret(self):
        """Add a 'ret' opcode."""
        from opcodes import OpcodeRet
        self._add(OpcodeRet())

    # ------------------------------------------------------------------
    # Forward jumps
    # ------------------------------------------------------------------

    def ahead(self):
        """
        Add a forward unconditional jump. The new opcode address is
        pushed on the control-flow stack as an origin.
        """
        from opcodes import OpcodeJumpUncond
        self.cs_push_orig()
        self._add(OpcodeJumpUncond())

    def ahead_if(self):
        """
        Add a forward conditional jump, taken if top-of-stack is true.
        The new opcode address is pushed on the control-flow stack as an origin.
        """
        from opcodes import OpcodeJumpIf
        self.cs_push_orig()
        self._add(OpcodeJumpIf())

    def ahead_if_not(self):
        """
        Add a forward conditional jump, taken if top-of-stack is false.
        The new opcode address is pushed on the control-flow stack as an origin.
        """
        from opcodes import OpcodeJumpIfNot
        self.cs_push_orig()
        self._add(OpcodeJumpIfNot())

    def then(self):
        """
        Resolve a previous forward jump to the current code address.
        The top of control-flow stack is popped and must be an origin.
        """
        x = self.cs_pop_orig()
        self._code[x].resolve_jump(len(self._code) - x - 1)
        self._jump_to_last = True

    # ------------------------------------------------------------------
    # Backward jumps
    # ------------------------------------------------------------------

    def begin(self):
        """
        Push the current code address on the control-flow stack as a
        destination, to be used by an ulterior backward jump.
        """
        self.cs_push_dest()

    def again(self):
        """
        Add a backward unconditional jump. The jump target is popped
        from the control-flow stack as a destination.
        """
        from opcodes import OpcodeJumpUncond
        x = self.cs_pop_dest()
        self._add(OpcodeJumpUncond(x - len(self._code) - 1))

    def again_if(self):
        """
        Add a backward conditional jump, taken if top-of-stack is true.
        The jump target is popped from the control-flow stack as a destination.
        """
        from opcodes import OpcodeJumpIf
        x = self.cs_pop_dest()
        self._add(OpcodeJumpIf(x - len(self._code) - 1))

    def again_if_not(self):
        """
        Add a backward conditional jump, taken if top-of-stack is false.
        The jump target is popped from the control-flow stack as a destination.
        """
        from opcodes import OpcodeJumpIfNot
        x = self.cs_pop_dest()
        self._add(OpcodeJumpIfNot(x - len(self._code) - 1))


class WordData(Word):

    def __init__(self, owner, name, blob_or_name, offset):
        """
        Two constructor signatures:
          WordData(owner, name, blob: ConstData, offset)
          WordData(owner, name, base_blob_name: str, offset)
        """
        super().__init__(owner, name)
        if isinstance(blob_or_name, str):
            self._blob = None
            self._base_blob_name = blob_or_name
        else:
            self._blob = blob_or_name
            self._base_blob_name = None
        self._offset = offset
        self._ongoing_resolution = False
        self.stack_effect = SType(0, 1)

    def resolve(self):
        if self._blob is not None:
            return
        if self._ongoing_resolution:
            raise Exception(
                f"circular reference in blobs ({self.name})")
        self._ongoing_resolution = True
        wd = self._tc.lookup(self._base_blob_name)
        if not isinstance(wd, WordData):
            raise Exception(
                f"data word '{self.name}' based on"
                f" non-data word '{self._base_blob_name}'")
        wd.resolve()
        self._blob = wd._blob
        self._offset += wd._offset
        self._ongoing_resolution = False

    def run(self, cpu):
        self.resolve()
        cpu.push(TValue(self._offset, TPointerBlob(self._blob)))

    def get_data_blocks(self):
        self.resolve()
        return [self._blob]

    def generate_code_elements(self, dst):
        from code_element import CodeElementUInt, CodeElementUIntInt
        self.resolve()
        dst.append(CodeElementUInt(0))
        dst.append(CodeElementUIntInt(1, self._blob.address + self._offset))
        dst.append(CodeElementUInt(0))



# The implementation for interpreted words.

class WordInterpreted(Word):

    def __init__(self, owner, name, num_locals, code, to_resolve):
        super().__init__(owner, name)
        self._num_locals = num_locals
        self._code = code          # list of Opcode
        self._to_resolve = to_resolve  # list of str|None
        self._flow_analysis = 0
        self._max_data_stack = 0
        self._max_return_stack = 0

    @property
    def num_locals(self):
        """Get the number of local variables for this word."""
        return self._num_locals

    @property
    def code(self):
        """Get the sequence of opcodes for this word."""
        return self._code

    # ------------------------------------------------------------------

    def resolve(self):
        if self._to_resolve is None:
            return
        for i, tt in enumerate(self._to_resolve):
            if tt is None:
                continue
            self._code[i].resolve_target(self._tc.lookup(tt))
        self._to_resolve = None

    def run(self, cpu):
        self.resolve()
        cpu.enter(self._code, self._num_locals)

    def get_references(self):
        self.resolve()
        return [w for op in self._code
                if (w := op.get_reference(self._tc)) is not None]

    def get_data_blocks(self):
        self.resolve()
        return [cd for op in self._code
                if (cd := op.get_data_block(self._tc)) is not None]

    def generate_code_elements(self, dst):
        from code_element import CodeElementUInt
        self.resolve()
        n = len(self._code)
        gcode = [self._code[i].to_code_element() for i in range(n)]
        for i in range(n):
            self._code[i].fix_up(gcode, i)
        dst.append(CodeElementUInt(self._num_locals))
        dst.extend(gcode)

    # ------------------------------------------------------------------
    # Flow analysis
    # ------------------------------------------------------------------

    def _merge_sa(self, sa, j, c):
        if sa[j] is None:
            sa[j] = c
            return True
        elif sa[j] != c:
            raise Exception(
                f"In word '{self.name}', offset {j}:"
                f" stack action mismatch ({sa[j]} / {c})")
        else:
            return False

    def analyse_flow(self):
        from opcodes import OpcodeCall, OpcodeRet

        if self._flow_analysis == 1:
            return
        if self._flow_analysis == 2:
            raise Exception(
                f"recursive call detected in '{self.name}'")

        self._flow_analysis = 2
        n = len(self._code)
        sa = [None] * n
        sa[0] = 0
        to_explore = []
        off = 0

        exit_sa = None
        mds = 0
        mrs = 0
        max_depth = 0

        while True:
            op = self._code[off]
            mft = op.may_fall_through
            c = sa[off]

            if isinstance(op, OpcodeCall):
                w = op.get_reference(self._tc)
                w.analyse_flow()
                se = w.stack_effect
                if not se.is_known:
                    raise Exception(
                        f"call from '{self.name}' to '{w.name}'"
                        f" with unknown stack effect")
                if se.no_exit:
                    mft = False
                    a = 0
                else:
                    a = se.data_out - se.data_in
                mds = max(mds, c + w.max_data_stack)
                mrs = max(mrs, w.max_return_stack)
                max_depth = min(max_depth, c - se.data_in)
            elif isinstance(op, OpcodeRet):
                if exit_sa is None:
                    exit_sa = c
                elif exit_sa != c:
                    raise Exception(
                        f"'{self.name}': exit stack action"
                        f" mismatch: {exit_sa} / {c}"
                        f" (offset {off})")
                a = 0
            else:
                a = op.stack_action
                mds = max(mds, c + a)

            c += a
            max_depth = min(max_depth, c)

            j = op.jump_disp
            if j != 0:
                j += off + 1
                to_explore.append(j)
                self._merge_sa(sa, j, c)

            off += 1
            if not mft or not self._merge_sa(sa, off, c):
                if to_explore:
                    off = to_explore.pop(0)
                else:
                    break

        self._max_data_stack = mds
        self._max_return_stack = 1 + self._num_locals + mrs

        # TODO: see about this warning. Usage of a 'fail' word (that
        # does not exit) within a 'case..endcase' structure will make
        # an unreachable opcode. In a future version we might want to
        # automatically remove dead opcodes.

        if exit_sa is None:
            computed = SType(-max_depth, -1)
        else:
            computed = SType(-max_depth, -max_depth + exit_sa)

        if self.stack_effect.is_known:
            if not computed.is_sub_of(self.stack_effect):
                raise Exception(
                    f"word '{self.name}':"
                    f" computed stack effect {computed}"
                    f" does not match declared {self.stack_effect}")
        else:
            self.stack_effect = computed

        self._flow_analysis = 1

    @property
    def max_data_stack(self):
        self.analyse_flow()
        return self._max_data_stack

    @property
    def max_return_stack(self):
        self.analyse_flow()
        return self._max_return_stack


# Class for native words.

class WordNative(Word):

    def __init__(self, owner, name, code, stack_effect=None):
        """
        Two constructor signatures:
          WordNative(owner, name, code)
          WordNative(owner, name, code, stack_effect)

        'code' is a callable: fn(cpu) -> None
        """
        super().__init__(owner, name)
        self._code = code
        if stack_effect is not None:
            self.stack_effect = stack_effect

    def run(self, cpu):
        self._code(cpu)
