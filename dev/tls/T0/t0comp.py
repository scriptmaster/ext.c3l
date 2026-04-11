// T0Comp.py

import sys
import io
from collections import deque

from typesys import *
from word import *
from cpu import *
from opcodes import *
from codes import *
from other import *


# This is the main compiler class.

class T0Comp:
    # ------------------------------------
    # Constructor
    # ------------------------------------

    def __init__(self):
        self._current_input = None
        # None = no delayed char
        # >= 0 = one delayed char of that value
        # < 0  = two delayed chars: '\n' then -(value+1)
        self._delayed_char = None
        self._token_builder = []
        self._delayed_token = None

        # Sorted dict for reproducibility
        self._words = {}          # str -> Word  (kept sorted on insert)
        self._last_word = None
        self._word_builder = None
        self._saved_word_builders = []
        self._all_c_code = {}     # str -> str (sorted)
        self._compiling = False
        self._quit_run_loop = False
        self._extra_code = []
        self._extra_code_defer = []
        self._data_block = None
        self._current_blob_id = 0
        self.enable_flow_analysis = True
        self.ds_limit = 32
        self.rs_limit = 32

        self._register_natives()

    # ------------------------------------
    # Native word registration
    # ------------------------------------

    def _register_natives(self):
        tc = self  # alias for lambdas

        # add-cc:
        def _add_cc(cpu):
            tt = tc._next()
            if tt is None:
                raise Exception("EOF reached (missing name)")
            if tt in tc._all_c_code:
                raise Exception("C code already set for: " + tt)
            tc._all_c_code[tt] = tc._parse_c_code()
        self._add_native("add-cc:", False, SType.BLANK, _add_cc)

        # cc:
        def _cc(cpu):
            tt = tc._next()
            if tt is None:
                raise Exception("EOF reached (missing name)")
            w = tc._add_native(tt, False, lambda cpu2: (_ for _ in ()).throw(
                Exception("C-only word: " + tt)))
            if tt in tc._all_c_code:
                raise Exception("C code already set for: " + tt)
            stack_effect, ccode = tc._parse_c_code_with_effect()
            tc._all_c_code[tt] = ccode
            w.stack_effect = stack_effect
        self._add_native("cc:", False, SType.BLANK, _cc)

        # preamble
        self._add_native("preamble", False, SType.BLANK,
            lambda cpu: tc._extra_code.append(tc._parse_c_code()))

        # postamble
        self._add_native("postamble", False, SType.BLANK,
            lambda cpu: tc._extra_code_defer.append(tc._parse_c_code()))

        # make-CX
        def _make_cx(cpu):
            c = cpu.pop()
            if not isinstance(c.ptr, TPointerBlob):
                raise Exception(f"'{c}' is not a string")
            max_val = int(cpu.pop())
            min_val = int(cpu.pop())
            tv = TValue(0, TPointerExpr(str(c), min_val, max_val))
            cpu.push(tv)
        self._add_native("make-CX", False, SType(3, 1), _make_cx)

        # CX  (immediate)
        def _cx(cpu):
            tt = tc._next()
            if tt is None:
                raise Exception("EOF reached (missing min value)")
            min_val = tc._parse_integer(tt)
            tt = tc._next()
            if tt is None:
                raise Exception("EOF reached (missing max value)")
            max_val = tc._parse_integer(tt)
            if max_val < min_val:
                raise Exception("min/max in wrong order")
            tv = TValue(0, TPointerExpr(tc._parse_c_code().strip(), min_val, max_val))
            if tc._compiling:
                tc._word_builder.literal(tv)
            else:
                cpu.push(tv)
        self._add_native("CX", True, _cx)

        # co
        self._add_native("co", False, SType.BLANK,
            lambda cpu: (_ for _ in ()).throw(
                Exception("No coroutine in compile mode")))

        # :
        def _colon(cpu):
            tt = tc._next()
            if tt is None:
                raise Exception("EOF reached (missing name)")
            if tc._compiling:
                tc._saved_word_builders.append(tc._word_builder)
            else:
                tc._compiling = True
            tc._word_builder = WordBuilder(tc, tt)
            tt = tc._next()
            if tt is None:
                raise Exception("EOF reached (while compiling)")
            if tt == "(":
                stack_effect = tc._parse_stack_effect_nf()
                if not stack_effect.is_known:
                    raise Exception("Invalid stack effect syntax")
                tc._word_builder.stack_effect = stack_effect
            else:
                tc._delayed_token = tt
        self._add_native(":", False, _colon)

        # define-word
        def _define_word(cpu):
            dout = int(cpu.pop())
            din = int(cpu.pop())
            s = cpu.pop()
            if not isinstance(s.ptr, TPointerBlob):
                raise Exception(f"Not a string: '{s}'")
            tt = str(s)
            if tc._compiling:
                tc._saved_word_builders.append(tc._word_builder)
            else:
                tc._compiling = True
            tc._word_builder = WordBuilder(tc, tt)
            tc._word_builder.stack_effect = SType(din, dout)
        self._add_native("define-word", False, _define_word)

        # ;  (immediate)
        def _semicolon(cpu):
            if not tc._compiling:
                raise Exception("Not compiling")
            w = tc._word_builder.build()
            name = w.name
            if name in tc._words:
                raise Exception("Word already defined: " + name)
            tc._words[name] = w
            tc._last_word = w
            if tc._saved_word_builders:
                tc._word_builder = tc._saved_word_builders.pop()
            else:
                tc._word_builder = None
                tc._compiling = False
        self._add_native(";", True, _semicolon)

        # immediate
        def _immediate(cpu):
            if tc._last_word is None:
                raise Exception("No word defined yet")
            tc._last_word.immediate = True
        self._add_native("immediate", False, _immediate)

        # literal  (immediate)
        def _literal(cpu):
            tc._check_compiling()
            tc._word_builder.literal(cpu.pop())
        w_literal = self._add_native("literal", True, _literal)

        # compile
        def _compile(cpu):
            tc._check_compiling()
            tc._word_builder.call_xt(cpu.pop().to_xt())
        w_compile = self._add_native("compile", False, _compile)

        # postpone  (immediate)
        def _postpone(cpu):
            tc._check_compiling()
            tt = tc._next()
            if tt is None:
                raise Exception("EOF reached (missing name)")
            v, is_val = tc._try_parse_literal(tt)
            w = tc.lookup_nf(tt)
            if is_val and w is not None:
                raise Exception(
                    f"Ambiguous: both defined word and literal: {tt}")
            if is_val:
                tc._word_builder.literal(v)
                tc._word_builder.call_ext(w_literal)
            elif w is not None:
                if w.immediate:
                    tc._word_builder.call_ext(w)
                else:
                    tc._word_builder.literal(TValue(0, TPointerXT(w)))
                    tc._word_builder.call_ext(w_compile)
            else:
                tc._word_builder.literal(TValue(0, TPointerXT(tt)))
                tc._word_builder.call_ext(w_compile)
        self._add_native("postpone", True, _postpone)

        # exitvm
        self._add_native("exitvm", False,
            lambda cpu: (_ for _ in ()).throw(Exception()))

        # new-data-block
        def _new_data_block(cpu):
            tc._data_block = ConstData(tc)
            cpu.push(TValue(0, TPointerBlob(tc._data_block)))
        self._add_native("new-data-block", False, _new_data_block)

        # define-data-word
        def _define_data_word(cpu):
            name = str(cpu.pop())
            va = cpu.pop()
            tb = va.ptr if isinstance(va.ptr, TPointerBlob) else None
            if tb is None:
                raise Exception("Address is not a data area")
            w = WordData(tc, name, tb.blob, va.x)
            if name in tc._words:
                raise Exception("Word already defined: " + name)
            tc._words[name] = w
            tc._last_word = w
        self._add_native("define-data-word", False, _define_data_word)

        # current-data
        def _current_data(cpu):
            if tc._data_block is None:
                raise Exception("No current data block")
            cpu.push(TValue(tc._data_block.length,
                            TPointerBlob(tc._data_block)))
        self._add_native("current-data", False, _current_data)

        # data-add8
        def _data_add8(cpu):
            if tc._data_block is None:
                raise Exception("No current data block")
            v = int(cpu.pop())
            if v < 0 or v > 0xFF:
                raise Exception("Byte value out of range: " + str(v))
            tc._data_block.add8(v)
        self._add_native("data-add8", False, _data_add8)

        # data-set8
        def _data_set8(cpu):
            va = cpu.pop()
            tb = va.ptr if isinstance(va.ptr, TPointerBlob) else None
            if tb is None:
                raise Exception("Address is not a data area")
            v = int(cpu.pop())
            if v < 0 or v > 0xFF:
                raise Exception("Byte value out of range: " + str(v))
            tb.blob.set8(va.x, v)
        self._add_native("data-set8", False, _data_set8)

        # data-get8
        def _data_get8(cpu):
            va = cpu.pop()
            tb = va.ptr if isinstance(va.ptr, TPointerBlob) else None
            if tb is None:
                raise Exception("Address is not a data area")
            cpu.push(tb.blob.read8(va.x))
        self._add_native("data-get8", False, SType(1, 1), _data_get8)

        # compile-local-read / compile-local-write
        self._add_native("compile-local-read", False,
            lambda cpu: (tc._check_compiling(),
                         tc._word_builder.get_local(str(cpu.pop()))))
        self._add_native("compile-local-write", False,
            lambda cpu: (tc._check_compiling(),
                         tc._word_builder.put_local(str(cpu.pop()))))

        # Control flow words
        self._add_native("ahead", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.ahead()))
        self._add_native("begin", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.begin()))
        self._add_native("again", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.again()))
        self._add_native("until", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.again_if_not()))
        self._add_native("untilnot", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.again_if()))
        self._add_native("if", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.ahead_if_not()))
        self._add_native("ifnot", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.ahead_if()))
        self._add_native("then", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.then()))
        self._add_native("cs-pick", False,
            lambda cpu: (tc._check_compiling(),
                         tc._word_builder.cs_pick(int(cpu.pop()))))
        self._add_native("cs-roll", False,
            lambda cpu: (tc._check_compiling(),
                         tc._word_builder.cs_roll(int(cpu.pop()))))

        # Token / char reading words
        def _next_word(cpu):
            s = tc._next()
            if s is None:
                raise Exception("No next word (EOF)")
            cpu.push(tc.string_to_blob(s))
        self._add_native("next-word", False, _next_word)

        self._add_native("parse", False,
            lambda cpu: cpu.push(tc.string_to_blob(
                tc._read_term(int(cpu.pop())))))
        self._add_native("char", False,
            lambda cpu: (lambda c: cpu.push(c) if c >= 0
                         else (_ for _ in ()).throw(
                             Exception("No next character (EOF)"))
                         )(tc._next_char()))
        self._add_native("'", False,
            lambda cpu: cpu.push(TValue(0, TPointerXT(tc._next()))))

        # execute
        self._add_native("execute", False,
            lambda cpu: cpu.pop().execute(tc, cpu))

        # [ and ]
        def _lbracket(cpu):
            tc._check_compiling()
            tc._compiling = False
        self._add_native("[", True, _lbracket)
        self._add_native("]", False, lambda cpu: setattr(tc, "_compiling", True))

        # (local)
        self._add_native("(local)", False,
            lambda cpu: (tc._check_compiling(),
                         tc._word_builder.def_local(str(cpu.pop()))))

        # ret (immediate)
        self._add_native("ret", True,
            lambda cpu: (tc._check_compiling(), tc._word_builder.ret()))

        # Stack manipulation
        self._add_native("drop", False, SType(1, 0), lambda cpu: cpu.pop())
        self._add_native("dup",  False, SType(1, 2), lambda cpu: cpu.push(cpu.peek(0)))
        self._add_native("swap", False, SType(2, 2), lambda cpu: cpu.rot(1))
        self._add_native("over", False, SType(2, 3), lambda cpu: cpu.push(cpu.peek(1)))
        self._add_native("rot",  False, SType(3, 3), lambda cpu: cpu.rot(2))
        self._add_native("-rot", False, SType(3, 3), lambda cpu: cpu.nrot(2))
        self._add_native("roll", False, SType(1, 0), lambda cpu: cpu.rot(int(cpu.pop())))
        self._add_native("pick", False, SType(1, 1),
            lambda cpu: cpu.push(cpu.peek(int(cpu.pop()))))

        # Arithmetic / comparison
        def _add(cpu):
            b = cpu.pop()
            a = cpu.pop()
            if b.ptr is None:
                a.x += int(b)
                cpu.push(a)
            elif isinstance(a.ptr, TPointerBlob) and isinstance(b.ptr, TPointerBlob):
                cpu.push(tc.string_to_blob(str(a) + str(b)))
            else:
                raise Exception(f"Cannot add '{b}' to '{a}'")
        self._add_native("+", False, SType(2, 1), _add)

        def _sub(cpu):
            b = cpu.pop()
            a = cpu.pop()
            ap = a.ptr if isinstance(a.ptr, TPointerBlob) else None
            bp = b.ptr if isinstance(b.ptr, TPointerBlob) else None
            if ap is not None and bp is not None and ap.blob is bp.blob:
                cpu.push(TValue(a.x - b.x))
                return
            a.x -= int(b)
            cpu.push(a)
        self._add_native("-", False, SType(2, 1), _sub)

        self._add_native("neg", False, SType(1, 1),
            lambda cpu: cpu.push(-int(cpu.pop())))
        self._add_native("*",   False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(a * b))(int(cpu.pop()), int(cpu.pop())))
        self._add_native("/",   False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(int(a / b)))(int(cpu.pop()), int(cpu.pop())))
        self._add_native("u/",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(a // b))(
                cpu.pop().uint_val, cpu.pop().uint_val))
        self._add_native("%",   False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(a % b))(int(cpu.pop()), int(cpu.pop())))
        self._add_native("u%",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(a % b))(
                cpu.pop().uint_val, cpu.pop().uint_val))

        self._add_native("<",   False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a < b)))(int(cpu.pop()), int(cpu.pop())))
        self._add_native("<=",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a <= b)))(int(cpu.pop()), int(cpu.pop())))
        self._add_native(">",   False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a > b)))(int(cpu.pop()), int(cpu.pop())))
        self._add_native(">=",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a >= b)))(int(cpu.pop()), int(cpu.pop())))
        self._add_native("=",   False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a.equals(b))))(cpu.pop(), cpu.pop()))
        self._add_native("<>",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(not a.equals(b))))(cpu.pop(), cpu.pop()))

        self._add_native("u<",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a < b)))(
                cpu.pop().uint_val, cpu.pop().uint_val))
        self._add_native("u<=", False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a <= b)))(
                cpu.pop().uint_val, cpu.pop().uint_val))
        self._add_native("u>",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a > b)))(
                cpu.pop().uint_val, cpu.pop().uint_val))
        self._add_native("u>=", False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(TValue(a >= b)))(
                cpu.pop().uint_val, cpu.pop().uint_val))

        self._add_native("and", False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(a & b))(
                cpu.pop().uint_val, cpu.pop().uint_val))
        self._add_native("or",  False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(a | b))(
                cpu.pop().uint_val, cpu.pop().uint_val))
        self._add_native("xor", False, SType(2, 1),
            lambda cpu: (lambda b, a: cpu.push(a ^ b))(
                cpu.pop().uint_val, cpu.pop().uint_val))
        self._add_native("not", False, SType(1, 1),
            lambda cpu: cpu.push(~cpu.pop().uint_val & 0xFFFFFFFF))

        def _shl(cpu):
            count = int(cpu.pop())
            if count < 0 or count > 31:
                raise Exception("Invalid shift count")
            cpu.push((cpu.pop().uint_val << count) & 0xFFFFFFFF)
        self._add_native("<<", False, SType(2, 1), _shl)

        def _sar(cpu):
            count = int(cpu.pop())
            if count < 0 or count > 31:
                raise Exception("Invalid shift count")
            cpu.push(int(cpu.pop()) >> count)
        self._add_native(">>", False, SType(2, 1), _sar)

        def _shr(cpu):
            count = int(cpu.pop())
            if count < 0 or count > 31:
                raise Exception("Invalid shift count")
            cpu.push(cpu.pop().uint_val >> count)
        self._add_native("u>>", False, SType(2, 1), _shr)

        # I/O words
        self._add_native(".", False, SType(1, 0),
            lambda cpu: print(f" {cpu.pop()}", end=""))
        self._add_native(".s", False, SType.BLANK, lambda cpu: (
            [print(f" {cpu.peek(i)}", end="")
             for i in range(cpu.depth - 1, -1, -1)]))
        self._add_native("putc", False, SType(1, 0),
            lambda cpu: print(chr(int(cpu.pop())), end=""))
        self._add_native("puts", False, SType(1, 0),
            lambda cpu: print(str(cpu.pop()), end=""))
        self._add_native("cr", False, SType.BLANK,
            lambda cpu: print())
        self._add_native("eqstr", False, SType(2, 1),
            lambda cpu: (lambda s2, s1: cpu.push(TValue(s1 == s2)))(
                str(cpu.pop()), str(cpu.pop())))

    # ------------------------------------
    # AddNative helpers
    # ------------------------------------

    def _add_native(self, name, immediate, *args):
        """
        Signatures:
          _add_native(name, immediate, code)
          _add_native(name, immediate, stack_effect, code)
        """
        if len(args) == 1:
            stack_effect = SType.UNKNOWN
            code = args[0]
        else:
            stack_effect, code = args[0], args[1]
        if name in self._words:
            raise Exception("Word already defined: " + name)
        w = WordNative(self, name, code, stack_effect)
        w.immediate = immediate
        self._words[name] = w
        return w

    # ------------------------------------
    # Public API
    # ------------------------------------

    def next_blob_id(self):
        bid = self._current_blob_id
        self._current_blob_id += 1
        return bid

    def lookup(self, name):
        w = self.lookup_nf(name)
        if w is not None:
            return w
        raise Exception(f"No such word: '{name}'")

    def lookup_nf(self, name):
        return self._words.get(name)

    def string_to_blob(self, s):
        return TValue(0, TPointerBlob(self, s))

    def _try_parse_literal(self, tt):
        """Returns (TValue, True) or (TValue(0), False)."""
        tv = TValue(0)
        if tt.startswith('"'):
            return self.string_to_blob(tt[1:]), True
        if tt.startswith("`"):
            return self._decode_char_const(tt[1:]), True
        neg = False
        if tt.startswith("-"):
            neg = True
            tt = tt[1:]
        elif tt.startswith("+"):
            tt = tt[1:]
        radix = 10
        if tt.startswith(("0x", "0X")):
            radix = 16
            tt = tt[2:]
        elif tt.startswith(("0b", "0B")):
            radix = 2
            tt = tt[2:]
        if not tt:
            return tv, False
        acc = 0
        overflow = False
        max_v = 0xFFFFFFFF // radix
        for c in tt:
            d = self._hex_val(ord(c))
            if d < 0 or d >= radix:
                return tv, False
            if acc > max_v:
                overflow = True
            acc *= radix
            if d > 0xFFFFFFFF - acc:
                overflow = True
            acc += d
        x = TValue._to_int32(acc)
        if neg:
            if acc > 0x80000000:
                overflow = True
            x = -x
        if overflow:
            raise Exception("invalid literal integer (overflow)")
        return TValue(x), True

    def _parse_integer(self, tt):
        tv, ok = self._try_parse_literal(tt)
        if not ok:
            raise Exception("not an integer: " + tt)
        return tv.int_val

    def _check_compiling(self):
        if not self._compiling:
            raise Exception("Not in compilation mode")

    @staticmethod
    def _escape_c_comment(s):
        sb = []
        for c in s:
            n = ord(c)
            if 33 <= n <= 126 and c != "%":
                sb.append(c)
            elif n < 0x100:
                sb.append(f"%{n:02X}")
            elif n < 0x800:
                sb.append(f"%{(n >> 6) | 0xC0:02X}%{(n & 0x3F) | 0x80:02X}")
            else:
                sb.append(
                    f"%{(n >> 12) | 0xE0:02X}"
                    f"%{((n >> 6) & 0x3F) | 0x80:02X}"
                    f"%{(n & 0x3F) | 0x80:02X}")
        return "".join(sb).replace("*/", "%2A/")

    # ------------------------------------
    # Character / token I/O
    # ------------------------------------

    def _next_char(self):
        c = self._delayed_char
        if c is None:
            c = self._read_raw()
        elif c >= 0:
            self._delayed_char = None
        else:
            # two delayed chars: '\n' then -(c+1)
            self._delayed_char = -(c + 1)
            c = ord("\n")

        if c == ord("\r"):
            if self._delayed_char is not None and self._delayed_char >= 0:
                c = self._delayed_char
                self._delayed_char = None
            else:
                c = self._read_raw()
            if c != ord("\n"):
                self._unread(c)
                c = ord("\n")
        return c

    def _read_raw(self):
        ch = self._current_input.read(1)
        return ord(ch) if ch else -1

    def _unread(self, c):
        if c < 0:
            return
        if self._delayed_char is None or self._delayed_char < 0:
            if self._delayed_char is not None:
                raise Exception("Already two delayed characters")
            self._delayed_char = c
        elif c != ord("\n"):
            raise Exception("Cannot delay two characters")
        else:
            self._delayed_char = -(self._delayed_char + 1)

    def _next(self):
        r = self._delayed_token
        if r is not None:
            self._delayed_token = None
            return r
        self._token_builder = []
        while True:
            c = self._next_char()
            if c < 0:
                return None
            if not self._is_ws(c):
                break
        if c == ord('"'):
            return self._parse_string()
        while True:
            self._token_builder.append(chr(c))
            c = self._next_char()
            if c < 0 or self._is_ws(c):
                self._unread(c)
                return "".join(self._token_builder)

    # ------------------------------------
    # Parsers
    # ------------------------------------

    def _parse_c_code(self):
        stack_effect, code = self._parse_c_code_with_effect()
        if stack_effect.is_known:
            raise Exception("Stack effect forbidden in this declaration")
        return code

    def _parse_c_code_with_effect(self):
        """Returns (SType, str). Raises if parse fails."""
        stack_effect, s = self._parse_c_code_nf()
        if s is None:
            raise Exception("Error while parsing C code")
        return stack_effect, s

    def _parse_c_code_nf(self):
        """Returns (SType, str|None)."""
        stack_effect = SType.UNKNOWN
        while True:
            c = self._next_char()
            if c < 0:
                return stack_effect, None
            if not self._is_ws(c):
                if c == ord("("):
                    if stack_effect.is_known:
                        self._unread(c)
                        return stack_effect, None
                    stack_effect = self._parse_stack_effect_nf()
                    if not stack_effect.is_known:
                        return stack_effect, None
                    continue
                elif c != ord("{"):
                    self._unread(c)
                    return stack_effect, None
                break
        sb = []
        count = 1
        while True:
            c = self._next_char()
            if c < 0:
                return stack_effect, None
            if c == ord("{"):
                count += 1
            elif c == ord("}"):
                count -= 1
                if count == 0:
                    return stack_effect, "".join(sb)
            sb.append(chr(c))

    def _parse_stack_effect_nf(self):
        seen_sep = False
        seen_bang = False
        din = 0
        dout = 0
        while True:
            t = self._next()
            if t is None:
                return SType.UNKNOWN
            if t == "--":
                if seen_sep:
                    return SType.UNKNOWN
                seen_sep = True
            elif t == ")":
                if seen_sep:
                    if seen_bang and dout == 1:
                        dout = -1
                    return SType(din, dout)
                else:
                    return SType.UNKNOWN
            else:
                if seen_sep:
                    if dout == 0 and t == "!":
                        seen_bang = True
                    dout += 1
                else:
                    din += 1

    def _parse_string(self):
        sb = ['"']
        lcwb = False
        hex_num = 0
        acc = 0
        while True:
            c = self._next_char()
            if c < 0:
                raise Exception("Unfinished literal string")
            if hex_num > 0:
                d = self._hex_val(c)
                if d < 0:
                    raise Exception(f"not an hex digit: U+{c:04X}")
                acc = (acc << 4) + d
                hex_num -= 1
                if hex_num == 0:
                    sb.append(chr(acc))
                    acc = 0
            elif lcwb:
                lcwb = False
                if c == ord("\n"):
                    self._skip_nl()
                elif c == ord("x"):
                    hex_num = 2
                elif c == ord("u"):
                    hex_num = 4
                else:
                    sb.append(self._single_char_escape(c))
            else:
                if c == ord('"'):
                    return "".join(sb)
                elif c == ord("\\"):
                    lcwb = True
                else:
                    sb.append(chr(c))

    @staticmethod
    def _single_char_escape(c):
        return {"n": "\n", "r": "\r", "t": "\t", "s": " "}.get(chr(c), chr(c))

    def _skip_nl(self):
        while True:
            c = self._next_char()
            if c < 0:
                raise Exception("EOF in literal string")
            if c == ord("\n"):
                raise Exception("Unescaped newline in literal string")
            if self._is_ws(c):
                continue
            if c == ord('"'):
                return
            raise Exception("Invalid newline escape in literal string")

    @staticmethod
    def _decode_char_const(t):
        if len(t) == 1 and t[0] != "\\":
            return TValue(ord(t[0]))
        if len(t) >= 2 and t[0] == "\\":
            if t[1] == "x" and len(t) == 4:
                x = T0Comp._dec_hex(t[2:])
                if x >= 0:
                    return TValue(x)
            elif t[1] == "u" and len(t) == 6:
                x = T0Comp._dec_hex(t[2:])
                if x >= 0:
                    return TValue(x)
            elif len(t) == 2:
                return TValue(ord(T0Comp._single_char_escape(ord(t[1]))))
        raise Exception("Invalid literal char: `" + t)

    @staticmethod
    def _dec_hex(s):
        acc = 0
        for c in s:
            d = T0Comp._hex_val(ord(c))
            if d < 0:
                return -1
            acc = (acc << 4) + d
        return acc

    @staticmethod
    def _hex_val(c):
        if ord("0") <= c <= ord("9"):
            return c - ord("0")
        elif ord("A") <= c <= ord("F"):
            return c - (ord("A") - 10)
        elif ord("a") <= c <= ord("f"):
            return c - (ord("a") - 10)
        return -1

    def _read_term(self, ct):
        sb = []
        while True:
            c = self._next_char()
            if c < 0:
                raise Exception(f"EOF reached before U+{ct:04X}")
            if c == ct:
                return "".join(sb)
            sb.append(chr(c))

    @staticmethod
    def _is_ws(c):
        return c <= 32

    # ------------------------------------
    # Processing loop
    # ------------------------------------

    def process_input(self, tr):
        self._current_input = tr
        self._delayed_char = -1   # signals: read from stream next
        w = WordNative(self, "toplevel",
                       lambda xcpu: self._compile_step(xcpu))
        cpu = CPU()
        code = [OpcodeCall(w), OpcodeJumpUncond(-2)]
        self._quit_run_loop = False
        cpu.enter(code, 0)
        while True:
            if self._quit_run_loop:
                break
            op = cpu.ip_buf[cpu.ip_off]
            cpu.ip_off += 1
            op.run(cpu)

    def _compile_step(self, cpu):
        tt = self._next()
        if tt is None:
            if self._compiling:
                raise Exception("EOF while compiling")
            self._quit_run_loop = True
            return
        v, is_val = self._try_parse_literal(tt)
        w = self.lookup_nf(tt)
        if is_val and w is not None:
            raise Exception(
                f"Ambiguous: both defined word and literal: {tt}")
        if self._compiling:
            if is_val:
                self._word_builder.literal(v)
            elif w is not None:
                if w.immediate:
                    w.run(cpu)
                else:
                    self._word_builder.call_ext(w)
            else:
                self._word_builder.call(tt)
        else:
            if is_val:
                cpu.push(v)
            elif w is not None:
                w.run(cpu)
            else:
                raise Exception(f"Unknown word: '{tt}'")

    def _get_c_code(self, name):
        return self._all_c_code.get(name)

    # ------------------------------------
    # Code generation
    # ------------------------------------

    def generate(self, out_base, core_run, entry_points):
        from code_element import CodeElement
        from code_element_uint import CodeElementUInt
        from blob_writer import BlobWriter

        # Gather all reachable words transitively
        word_set = {}
        tx = deque()
        for ep in entry_points:
            if ep in word_set:
                continue
            w = self.lookup(ep)
            word_set[w.name] = w
            tx.append(w)
        while tx:
            w = tx.popleft()
            for w2 in w.get_references():
                if w2.name in word_set:
                    continue
                word_set[w2.name] = w2
                tx.append(w2)

        # Flow analysis
        if self.enable_flow_analysis:
            for ep in entry_points:
                w = word_set[ep]
                w.analyse_flow()
                print(f"{ep}: ds={w.max_data_stack} rs={w.max_return_stack}")
                if w.max_data_stack > self.ds_limit:
                    raise Exception(f"'{ep}' exceeds data stack limit")
                if w.max_return_stack > self.rs_limit:
                    raise Exception(f"'{ep}' exceeds return stack limit")

        # Gather data blocks
        blocks = {}
        for w in word_set.values():
            for cd in w.get_data_blocks():
                blocks[cd.id] = cd
        blocks = dict(sorted(blocks.items()))
        data_len = 1
        for cd in blocks.values():
            cd.address = data_len
            data_len += cd.length

        # Assign slots
        slots = {}
        cur_slot = 7
        ccode_uni = {}   # ccode -> slot number
        ccode_names = {} # slot number -> name comment
        for w in sorted(word_set.values(), key=lambda x: x.name):
            ccode = self._get_c_code(w.name)
            if ccode is None:
                if isinstance(w, WordNative):
                    raise Exception(f"No C code for native '{w.name}'")
                continue
            if ccode in ccode_uni:
                sn = ccode_uni[ccode]
                ccode_names[sn] += " " + self._escape_c_comment(w.name)
            else:
                sn = cur_slot
                cur_slot += 1
                ccode_uni[ccode] = sn
                ccode_names[sn] = self._escape_c_comment(w.name)
            slots[w.name] = sn
            w.slot = sn

        slot_interpreted = cur_slot
        for w in sorted(word_set.values(), key=lambda x: x.name):
            if self._get_c_code(w.name) is not None:
                continue
            sn = cur_slot
            cur_slot += 1
            slots[w.name] = sn
            w.slot = sn
        num_interpreted = cur_slot - slot_interpreted

        # Verify entry points are interpreted
        for ep in entry_points:
            if self._get_c_code(ep) is not None:
                raise Exception("Non-interpreted entry point")

        # Build code block
        gcode_list = []
        interpreted_entry = [None] * num_interpreted
        for w in sorted(word_set.values(), key=lambda x: x.name):
            if self._get_c_code(w.name) is not None:
                continue
            n = len(gcode_list)
            w.generate_code_elements(gcode_list)
            interpreted_entry[w.slot - slot_interpreted] = gcode_list[n]
        gcode = gcode_list

        one_byte_code = True
        if slot_interpreted + num_interpreted >= 256:
            print("WARNING: more than 255 words")
            one_byte_code = False

        # Stabilize addresses
        total_len = -1
        while True:
            gcode_len = [ce.get_length(one_byte_code) for ce in gcode]
            off = 0
            for i, ce in enumerate(gcode):
                ce.address = off
                ce.last_length = gcode_len[i]
                off += gcode_len[i]
            if off == total_len:
                break
            total_len = off

        # Write output
        with open(out_base + ".c", "w", newline="\n") as tw:
            tw.write(
"""/* Automatically generated code; do not modify directly. */

#include <stddef.h>
#include <stdint.h>

typedef struct {
\tuint32_t *dp;
\tuint32_t *rp;
\tconst unsigned char *ip;
} t0_context;

static uint32_t
t0_parse7E_unsigned(const unsigned char **p)
{
\tuint32_t x;

\tx = 0;
\tfor (;;) {
\t\tunsigned y;

\t\ty = *(*p) ++;
\t\tx = (x << 7) | (uint32_t)(y & 0x7F);
\t\tif (y < 0x80) {
\t\t\treturn x;
\t\t}
\t}
}

static int32_t
t0_parse7E_signed(const unsigned char **p)
{
\tint neg;
\tuint32_t x;

\tneg = ((**p) >> 6) & 1;
\tx = (uint32_t)-neg;
\tfor (;;) {
\t\tunsigned y;

\t\ty = *(*p) ++;
\t\tx = (x << 7) | (uint32_t)(y & 0x7F);
\t\tif (y < 0x80) {
\t\t\tif (neg) {
\t\t\t\treturn -(int32_t)~x - 1;
\t\t\t} else {
\t\t\t\treturn (int32_t)x;
\t\t\t}
\t\t}
\t}
}

#define T0_VBYTE(x, n)   (unsigned char)((((uint32_t)(x) >> (n)) & 0x7F) | 0x80)
#define T0_FBYTE(x, n)   (unsigned char)(((uint32_t)(x) >> (n)) & 0x7F)
#define T0_SBYTE(x)      (unsigned char)((((uint32_t)(x) >> 28) + 0xF8) ^ 0xF8)
#define T0_INT1(x)       T0_FBYTE(x, 0)
#define T0_INT2(x)       T0_VBYTE(x, 7), T0_FBYTE(x, 0)
#define T0_INT3(x)       T0_VBYTE(x, 14), T0_VBYTE(x, 7), T0_FBYTE(x, 0)
#define T0_INT4(x)       T0_VBYTE(x, 21), T0_VBYTE(x, 14), T0_VBYTE(x, 7), T0_FBYTE(x, 0)
#define T0_INT5(x)       T0_SBYTE(x), T0_VBYTE(x, 21), T0_VBYTE(x, 14), T0_VBYTE(x, 7), T0_FBYTE(x, 0)

/* static const unsigned char t0_datablock[]; */
""")
            for ep in entry_points:
                tw.write(f"\nvoid {core_run}_init_{ep}(void *t0ctx);")
            tw.write(f"\n\nvoid {core_run}_run(void *t0ctx);\n")

            for pp in self._extra_code:
                tw.write(f"\n{pp}\n")

            bw = BlobWriter(tw, 78, 1)
            tw.write("\nstatic const unsigned char t0_datablock[] = {")
            bw.append(0)
            for cd in blocks.values():
                cd.encode(bw)
            tw.write("\n};\n")

            tw.write("\nstatic const unsigned char t0_codeblock[] = {")
            bw = BlobWriter(tw, 78, 1)
            for ce in gcode:
                ce.encode(bw, one_byte_code)
            tw.write("\n};\n")

            tw.write("\nstatic const uint16_t t0_caddr[] = {")
            for i, ce in enumerate(interpreted_entry):
                if i != 0:
                    tw.write(",")
                tw.write(f"\n\t{ce.address}")
            tw.write("\n};\n")

            tw.write(f"\n#define T0_INTERPRETED   {slot_interpreted}\n")
            tw.write(r"""
#define T0_ENTER(ip, rp, slot)   do { \
		const unsigned char *t0_newip; \
		uint32_t t0_lnum; \
		t0_newip = &t0_codeblock[t0_caddr[(slot) - T0_INTERPRETED]]; \
		t0_lnum = t0_parse7E_unsigned(&t0_newip); \
		(rp) += t0_lnum; \
		*((rp) ++) = (uint32_t)((ip) - &t0_codeblock[0]) + (t0_lnum << 16); \
		(ip) = t0_newip; \
	} while (0)
""")
            tw.write(r"""
#define T0_DEFENTRY(name, slot) \
void \
name(void *ctx) \
{ \
	t0_context *t0ctx = ctx; \
	t0ctx->ip = &t0_codeblock[0]; \
	T0_ENTER(t0ctx->ip, t0ctx->rp, slot); \
}
""")
            for ep in entry_points:
                tw.write(
                    f"\nT0_DEFENTRY({core_run}_init_{ep},"
                    f" {word_set[ep].slot})\n")

            if one_byte_code:
                tw.write("\n#define T0_NEXT(t0ipp)   (*(*(t0ipp)) ++)\n")
            else:
                tw.write(
                    "\n#define T0_NEXT(t0ipp)   t0_parse7E_unsigned(t0ipp)\n")

            tw.write(f"\nvoid\n{core_run}_run(void *t0ctx)\n")
            tw.write(r"""{
	uint32_t *dp, *rp;
	const unsigned char *ip;

#define T0_LOCAL(x)    (*(rp - 2 - (x)))
#define T0_POP()       (*-- dp)
#define T0_POPi()      (*(int32_t *)(-- dp))
#define T0_PEEK(x)     (*(dp - 1 - (x)))
#define T0_PEEKi(x)    (*(int32_t *)(dp - 1 - (x)))
#define T0_PUSH(v)     do { *dp = (v); dp ++; } while (0)
#define T0_PUSHi(v)    do { *(int32_t *)dp = (v); dp ++; } while (0)
#define T0_RPOP()      (*-- rp)
#define T0_RPOPi()     (*(int32_t *)(-- rp))
#define T0_RPUSH(v)    do { *rp = (v); rp ++; } while (0)
#define T0_RPUSHi(v)   do { *(int32_t *)rp = (v); rp ++; } while (0)
#define T0_ROLL(x)     do { \
	size_t t0len = (size_t)(x); \
	uint32_t t0tmp = *(dp - 1 - t0len); \
	memmove(dp - t0len - 1, dp - t0len, t0len * sizeof *dp); \
	*(dp - 1) = t0tmp; \
} while (0)
#define T0_SWAP()      do { \
	uint32_t t0tmp = *(dp - 2); \
	*(dp - 2) = *(dp - 1); \
	*(dp - 1) = t0tmp; \
} while (0)
#define T0_ROT()       do { \
	uint32_t t0tmp = *(dp - 3); \
	*(dp - 3) = *(dp - 2); \
	*(dp - 2) = *(dp - 1); \
	*(dp - 1) = t0tmp; \
} while (0)
#define T0_NROT()       do { \
	uint32_t t0tmp = *(dp - 1); \
	*(dp - 1) = *(dp - 2); \
	*(dp - 2) = *(dp - 3); \
	*(dp - 3) = t0tmp; \
} while (0)
#define T0_PICK(x)      do { \
	uint32_t t0depth = (x); \
	T0_PUSH(T0_PEEK(t0depth)); \
} while (0)
#define T0_CO()         do { \
	goto t0_exit; \
} while (0)
#define T0_RET()        goto t0_next

	dp = ((t0_context *)t0ctx)->dp;
	rp = ((t0_context *)t0ctx)->rp;
	ip = ((t0_context *)t0ctx)->ip;
	goto t0_next;
	for (;;) {
		uint32_t t0x;

	t0_next:
		t0x = T0_NEXT(&ip);
		if (t0x < T0_INTERPRETED) {
			switch (t0x) {
				int32_t t0off;

			case 0: /* ret */
				t0x = T0_RPOP();
				rp -= (t0x >> 16);
				t0x &= 0xFFFF;
				if (t0x == 0) {
					ip = NULL;
					goto t0_exit;
				}
				ip = &t0_codeblock[t0x];
				break;
			case 1: /* literal constant */
				T0_PUSHi(t0_parse7E_signed(&ip));
				break;
			case 2: /* read local */
				T0_PUSH(T0_LOCAL(t0_parse7E_unsigned(&ip)));
				break;
			case 3: /* write local */
				T0_LOCAL(t0_parse7E_unsigned(&ip)) = T0_POP();
				break;
			case 4: /* jump */
				t0off = t0_parse7E_signed(&ip);
				ip += t0off;
				break;
			case 5: /* jump if */
				t0off = t0_parse7E_signed(&ip);
				if (T0_POP()) {
					ip += t0off;
				}
				break;
			case 6: /* jump if not */
				t0off = t0_parse7E_signed(&ip);
				if (!T0_POP()) {
					ip += t0off;
				}
				break;
""")
            # Native C code cases
            nccode = dict(sorted(
                {ccode_uni[k]: k for k in ccode_uni}.items()))
            for sn, ccode in nccode.items():
                tw.write(
                    f"\t\t\tcase {sn}: {{\n"
                    f"\t\t\t\t/* {ccode_names[sn]} */\n"
                    f"{ccode}\n"
                    f"\t\t\t\t}}\n"
                    f"\t\t\t\tbreak;\n")

            tw.write(r"""		}

		} else {
			T0_ENTER(ip, rp, t0x);
		}
	}
t0_exit:
	((t0_context *)t0ctx)->dp = dp;
	((t0_context *)t0ctx)->rp = rp;
	((t0_context *)t0ctx)->ip = ip;
}""")

            for pp in self._extra_code_defer:
                tw.write(f"\n\n{pp}")

        code_len = sum(ce.get_length(one_byte_code) for ce in gcode)
        data_block_len = sum(cd.length for cd in blocks.values())
        print(f"code length: {code_len:6d} byte(s)")
        print(f"data length: {data_len:6d} byte(s)")
        print(f"total words: {slot_interpreted + num_interpreted}"
              f" (interpreted: {num_interpreted})")



def main(args):
    try:
        r = []
        out_base = None
        entry_points = []
        core_run = None
        flow = True
        ds_lim = 32
        rs_lim = 32

        i = 0
        while i < len(args):
            a = args[i]
            if not a.startswith("-"):
                r.append(a)
                i += 1
                continue
            if a == "--":
                i += 1
                while i < len(args):
                    r.append(args[i])
                    i += 1
                break
            while a.startswith("-"):
                a = a[1:]
            j = a.find("=")
            if j < 0:
                pname = a.lower()
                pval = None
                pval2 = args[i + 1] if (i + 1) < len(args) else None
            else:
                pname = a[:j].strip().lower()
                pval = a[j + 1:]
                pval2 = None

            if pname in ("o", "out"):
                if pval is None:
                    if pval2 is None:
                        usage()
                    i += 1
                    pval = pval2
                if out_base is not None:
                    usage()
                out_base = pval
            elif pname in ("r", "run"):
                if pval is None:
                    if pval2 is None:
                        usage()
                    i += 1
                    pval = pval2
                core_run = pval
            elif pname in ("m", "main"):
                if pval is None:
                    if pval2 is None:
                        usage()
                    i += 1
                    pval = pval2
                for ep in pval.split(","):
                    epz = ep.strip()
                    if epz:
                        entry_points.append(epz)
            elif pname in ("nf", "noflow"):
                flow = False
            else:
                usage()
            i += 1

        if not r:
            usage()
        if out_base is None:
            out_base = "t0out"
        if not entry_points:
            entry_points.append("main")
        if core_run is None:
            core_run = out_base

        tc = T0Comp()
        tc.enable_flow_analysis = flow
        tc.ds_limit = ds_lim
        tc.rs_limit = rs_lim

        import importlib.resources
        kernel = importlib.resources.read_text(".", "t0-kernel")
        tc.process_input(io.StringIO(kernel))

        for a in r:
            print(f"[{a}]")
            with open(a, "r") as f:
                tc.process_input(f)

        tc.generate(out_base, core_run, entry_points)

    except Exception as e:
        print(e)
        sys.exit(1)

def usage():
    print("usage: t0comp.py [ options... ] file...")
    print("options:")
    print("   -o file    use 'file' as base for output file name (default: 't0out')")
    print("   -r name    use 'name' as base for run function (default: same as output)")
    print("   -m name[,name...]")
    print("              define entry point(s)")
    print("   -nf        disable flow analysis")
    sys.exit(1)

if __name__ == "__main__":
    main(sys.argv[1:])
