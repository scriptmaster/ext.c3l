# Code execution during compilation runs on a virtual CPU embodied by this
# class, which holds the relevant registers.
#
# Stack data accesses are mapped to accesses on an internal list with no
# explicit boundary checks. Since the internal list may be larger than the
# actual stack contents, out-of-range accesses may still "work" to some
# extent.


class CPU:

    # -----------------------------------------------------------------------
    # Inner class: system stack frame
    # -----------------------------------------------------------------------

    class Frame:
        """
        The system stack is a linked list of Frame instances.
        Each frame saves the caller's ip (instruction pointer) and holds
        the local variable array for the current function call.
        """

        def __init__(self, upper: "CPU.Frame | None", num_locals: int):
            self.upper        = upper                  # parent frame
            self.saved_ip_buf = None                   # caller's instruction buffer
            self.saved_ip_off = 0                      # caller's instruction offset
            self.locals       = [None] * num_locals    # local variable slots

    # -----------------------------------------------------------------------
    # Constructor
    # -----------------------------------------------------------------------

    def __init__(self):
        # Next instruction to execute: ip_buf[ip_off]
        self.ip_buf = None   # list of Opcode objects
        self.ip_off = 0

        # Data stack
        self._stack     = [None] * 16  # dynamically-expanded internal buffer
        self._stack_ptr = -1           # index of top element (-1 = empty)

        # System (return) stack: top of the Frame linked list
        self._rsp: CPU.Frame | None = None

    # -----------------------------------------------------------------------
    # Function entry / return
    # -----------------------------------------------------------------------

    def enter(self, code: list, num_locals: int):
        """
        Enter a function: reserve space for num_locals local variables,
        save the current ip into a new frame, and switch to the new code buffer.
        """
        f = CPU.Frame(self._rsp, num_locals)
        f.saved_ip_buf = self.ip_buf
        f.saved_ip_off = self.ip_off
        self._rsp  = f
        self.ip_buf = code
        self.ip_off = 0

    def exit(self):
        """Return from the current function, restoring the caller's ip."""
        self.ip_buf = self._rsp.saved_ip_buf
        self.ip_off = self._rsp.saved_ip_off
        self._rsp   = self._rsp.upper

    # -----------------------------------------------------------------------
    # Data stack operations
    # -----------------------------------------------------------------------

    @property
    def depth(self) -> int:
        """Return the number of values currently on the data stack."""
        return self._stack_ptr + 1

    def pop(self):
        """Pop and return the top value from the data stack."""
        v = self._stack[self._stack_ptr]
        self._stack_ptr -= 1
        return v

    def push(self, v):
        """Push a value onto the data stack, doubling the buffer if needed."""
        self._stack_ptr += 1
        if self._stack_ptr == len(self._stack):
            self._stack = self._stack + [None] * len(self._stack)
        self._stack[self._stack_ptr] = v

    def peek(self, depth: int):
        """
        Return the value at position 'depth' without modifying the stack.
        depth=0 is the top of stack (TOS).
        """
        return self._stack[self._stack_ptr - depth]

    def rot(self, depth: int):
        """
        Move the value at 'depth' to the top of stack (Forth's 'roll').
        """
        idx = self._stack_ptr - depth
        v   = self._stack[idx]
        # shift elements idx+1 .. stack_ptr one position down
        self._stack[idx:self._stack_ptr] = \
            self._stack[idx + 1:self._stack_ptr + 1]
        self._stack[self._stack_ptr] = v

    def nrot(self, depth: int):
        """
        Move the top-of-stack value down to position 'depth' (inverse of rot).
        """
        v   = self._stack[self._stack_ptr]
        idx = self._stack_ptr - depth
        # shift elements idx .. stack_ptr-1 one position up
        self._stack[idx + 1:self._stack_ptr + 1] = \
            self._stack[idx:self._stack_ptr]
        self._stack[idx] = v

    # -----------------------------------------------------------------------
    # Local variable access
    # -----------------------------------------------------------------------

    def get_local(self, num: int):
        """Read local variable 'num' from the current frame."""
        return self._rsp.locals[num]

    def put_local(self, num: int, v):
        """Write value 'v' to local variable 'num' in the current frame."""
        self._rsp.locals[num] = v
