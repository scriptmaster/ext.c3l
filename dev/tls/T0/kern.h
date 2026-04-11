/*
 * kern.h
 *
 * C translation of kern.t0
 *
 * kern.t0 serves as the T0 VM standard library. It defines:
 *   - Native C implementations of stack primitives (add-cc: blocks)
 *   - Utility words: hexval, decval, data-get16
 *   - Compile-time control flow words (else, while, case, choice ...)
 *
 * In straight C, the stack primitives are replaced by C operators and
 * variables directly, so they need no runtime representation. Only the
 * utility functions and the data-block accessor are carried over.
 *
 * Compile-time-only words that have no runtime equivalent:
 *   else, while, repeat, ['], [compile], 2drop, dup2,
 *   1+, 2+, 1-, 2-, 0=, 0<>, 0<, 0>,
 *   case, of, endof, endcase, choice, uf, ufnot, enduf, endchoice
 *   data:, hexb|
 */

#ifndef KERN_H
#define KERN_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* ======================================================================
 * Data block
 *
 * In T0, 't0_datablock' is a flat byte array that holds all string
 * literals and binary blobs defined with 'data:' / 'hexb|'.
 * The translated C code inherits this array unchanged.
 * ====================================================================== */

extern const unsigned char t0_datablock[];

/* ======================================================================
 * add-cc: primitives
 *
 * In T0 these manipulate an explicit value stack via T0_POP/T0_PUSH.
 * In C they become ordinary inline functions or are replaced by
 * built-in operators at each call site.
 *
 * Stack-shuffling operations (drop, dup, swap, over, rot, -rot,
 * roll, pick, execute, co) are pure VM plumbing; they disappear
 * entirely in a C translation where the compiler handles registers.
 *
 * Arithmetic, comparison, bitwise and shift operations are likewise
 * replaced by C operators (+, -, *, /, %, <, ==, &, |, ^, ~, <<, >>).
 *
 * Only the operations that perform a non-trivial action beyond a
 * single C operator are kept as inline helpers.
 * ====================================================================== */

/*
 * add-cc: neg  { T0_PUSH(-T0_POP()); }
 *
 * Arithmetic negation. Equivalent to the unary minus operator.
 * Provided as a named function to mirror the T0 word.
 */
static inline uint32_t
t0_neg(uint32_t a)
{
    return (uint32_t)(-(int32_t)a);
}

/*
 * add-cc: u/  { T0_PUSH(T0_POP_u() / T0_POP_u()); }
 * add-cc: u%  { T0_PUSH(T0_POP_u() % T0_POP_u()); }
 *
 * Unsigned division and modulo. Distinguished from the signed variants
 * '/' and '%' that T0 also defines.
 */
static inline uint32_t
t0_udiv(uint32_t a, uint32_t b)
{
    return a / b;
}

static inline uint32_t
t0_umod(uint32_t a, uint32_t b)
{
    return a % b;
}

/*
 * add-cc: u>>  { int c = T0_POPi(); uint32_t x = T0_POP(); T0_PUSH(x >> c); }
 *
 * Logical (unsigned) right shift. C's >> on uint32_t is already
 * logical, but the explicit cast makes intent clear.
 */
static inline uint32_t
t0_ushr(uint32_t x, int c)
{
    return x >> c;
}

/*
 * add-cc: >>  { int c = T0_POPi(); int32_t x = T0_POPi(); T0_PUSHi(x >> c); }
 *
 * Arithmetic (signed) right shift.
 */
static inline int32_t
t0_ashr(int32_t x, int c)
{
    return x >> c;
}

/*
 * add-cc: data-get8  { T0_PUSH(t0_datablock[T0_POP()]); }
 *
 * Read one byte from the constant data block at the given offset.
 */
static inline unsigned char
data_get8(size_t addr)
{
    return t0_datablock[addr];
}

/*
 * data-get16 ( addr -- x )
 *   dup data-get8 8 << swap 1+ data-get8 + ;
 *
 * Read a big-endian 16-bit value from the constant data block.
 * Defined as a T0 word in kern.t0 using data-get8; translated here
 * directly as a two-byte big-endian load.
 */
static inline uint16_t
data_get16(size_t addr)
{
    return (uint16_t)(
        ((uint16_t)t0_datablock[addr]     << 8) |
         (uint16_t)t0_datablock[addr + 1]
    );
}

/* ======================================================================
 * Debug / I/O primitives  (add-cc: . putc puts cr)
 *
 * These are thin wrappers around printf used during T0 development.
 * They are preserved so that any debug call sites compile correctly.
 * ====================================================================== */

/*
 * add-cc: .  { printf(" %ld", (long)T0_POPi()); }
 */
static inline void
t0_print_int(int32_t v)
{
    printf(" %ld", (long)v);
}

/*
 * add-cc: putc  { printf("%c", (char)T0_POPi()); }
 */
static inline void
t0_putc(int32_t c)
{
    printf("%c", (char)c);
}

/*
 * add-cc: puts  { printf("%s", &t0_datablock[T0_POPi()]); }
 *
 * Prints a NUL-terminated string whose address is an offset into
 * the data block.
 */
static inline void
t0_puts(size_t addr)
{
    printf("%s", (const char *)&t0_datablock[addr]);
}

/*
 * add-cc: cr  { printf("\n"); }
 */
static inline void
t0_cr(void)
{
    printf("\n");
}

/* ======================================================================
 * String comparison  (add-cc: eqstr)
 * ====================================================================== */

/*
 * add-cc: eqstr
 *   { T0_PUSH(-(int32_t)(strcmp(a, b) == 0)); }
 *
 * Compare two NUL-terminated strings stored in the data block.
 * Returns non-zero (true) if equal, zero (false) otherwise —
 * matching T0's boolean convention of -1 for true, 0 for false.
 */
static inline int
t0_eqstr(size_t addr_a, size_t addr_b)
{
    const char *a = (const char *)&t0_datablock[addr_a];
    const char *b = (const char *)&t0_datablock[addr_b];
    return strcmp(a, b) == 0 ? -1 : 0;
}

/* ======================================================================
 * Hex / decimal character conversion
 *
 * : hexval-nf ( char -- x )
 *     dup dup `0 >= swap `9 <= and if `0 - ret then
 *     dup dup `A >= swap `F <= and if `A - 10 + ret then
 *     dup dup `a >= swap `f <= and if `a - 10 + ret then
 *     drop -1 ;
 *
 * : hexval ( char -- x )
 *     hexval-nf dup 0 < if "Not an hex digit: " puts . cr exitvm then ;
 *
 * : decval-nf ( char -- x )
 *     dup dup `0 >= swap `9 <= and if `0 - ret then
 *     drop -1 ;
 *
 * : decval ( char -- x )
 *     decval-nf dup 0 < if "Not a decimal digit: " puts . cr exitvm then ;
 * ====================================================================== */

/*
 * Convert a hexadecimal character to its numeric value.
 * Returns -1 if the character is not a valid hex digit.
 *
 * Mirrors T0's hexval-nf ("no-fail" variant).
 */
static inline int
hexval_nf(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    return -1;
}

/*
 * Convert a hexadecimal character to its numeric value.
 * Aborts (via fprintf + exit) if the character is not a valid hex digit.
 *
 * Mirrors T0's hexval (fail-on-error variant).
 * In the original, failure calls 'exitvm'; here we use fprintf+abort
 * which has the same effect in a non-VM context.
 */
static inline int
hexval(int c)
{
    int v = hexval_nf(c);
    if (v < 0) {
        fprintf(stderr, "Not a hex digit: %c\n", c);
        abort();
    }
    return v;
}

/*
 * Convert a decimal character to its numeric value.
 * Returns -1 if the character is not a valid decimal digit.
 *
 * Mirrors T0's decval-nf.
 */
static inline int
decval_nf(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    return -1;
}

/*
 * Convert a decimal character to its numeric value.
 * Aborts if the character is not a valid decimal digit.
 *
 * Mirrors T0's decval.
 */
static inline int
decval(int c)
{
    int v = decval_nf(c);
    if (v < 0) {
        fprintf(stderr, "Not a decimal digit: %c\n", c);
        abort();
    }
    return v;
}

#endif /* KERN_H */
