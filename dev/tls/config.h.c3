// config.h.c3

// Compile-time feature flags

// In C3 the equivalent mechanism is:
//
//   const FLAG = 1;   // force-enable
//   const FLAG = 0;   // force-disable
//   // (absent)       // autodetection in inner.h.c3 via @if(env::...)
//
// All flags below are commented out, matching the default
// (autodetection). Uncomment and set to 1 or 0 to override.
//
// These constants are consumed by inner.h.c3 and other implementation
// files that gate optional code paths behind @if blocks.

module ext::net::tls;

// ============================================================================
// Integer arithmetic flags
// ============================================================================

<*
  I64 — Efficient 64-bit integers.

  When enabled (1), 64-bit integer operations are assumed to be as fast as
  32-bit operations (i.e. the target has 64-bit registers). Enables
  64-bit-optimised algorithm variants.
*>
// const I64 = 1;

<*
  LOMUL — Low-multiplication strategy.

  When enabled (1), 32-bit multiplications truncated to 32 bits are
  assumed to be substantially faster than full 32×32→64 multiplications.
  Typical on low-end ARM Cortex-M devices (M0, M0+, M1, M3, M4).
*>
// const LOMUL = 1;

<*
  SLOW_MUL — Slow general multiplications.

  When enabled (1), multiplications are assumed to be much slower than
  other integer operations. The implementation will trade extra operations
  for fewer multiplications where beneficial.
*>
// const SLOW_MUL = 1;

<*
  SLOW_MUL15 — Slow 15-bit multiplications.

  When enabled (1), short (15-bit word) multiplications are assumed to be
  substantially slow. The implementation will favour more integer operations
  to reduce multiplication count.
*>
// const SLOW_MUL15 = 1;

<*
  CT_MUL31 — Constant-time 31-bit multiplications.

  When enabled (1), the 'i31' big integer implementation uses an alternate
  multiplication path that is slower and larger but guarantees constant-time
  execution on architectures with variable-latency multiply opcodes.
*>
// const CT_MUL31 = 1;

<*
  CT_MUL15 — Constant-time 15-bit multiplications.

  When enabled (1), 15-bit multiplications (held in 32-bit words) use an
  alternate path that avoids timing variation on architectures where the
  basic multiply is not constant-time.
*>
// const CT_MUL15 = 1;

<*
  NO_ARITH_SHIFT — Avoid implementation-defined arithmetic right shifts.

  When enabled (1), arithmetic right shifts (sign-extending) are emulated
  with portable operations instead of relying on the compiler's sign-
  extension behaviour for signed right shifts. Slower and larger, but
  strictly standards-conforming. Disabled by default because virtually all
  C compilers (and C3 targets) do sign-extend right shifts on signed values.
*>
// const NO_ARITH_SHIFT = 1;

// ============================================================================
// Entropy / RNG source flags
// ============================================================================

<*
  RDRAND — Use the x86 RDRAND instruction.

  When enabled (1), the SSL engine uses the RDRAND opcode to seed its
  internal PRNG. Support is tested at runtime; if the CPU lacks RDRAND,
  the engine falls back to /dev/urandom or CryptGenRandom().
*>
// const RDRAND = 1;

<*
  USE_GETENTROPY — Use getentropy() for seeding.

  When enabled (1), the SSL engine calls getentropy() (Linux glibc 2.25+,
  FreeBSD 12+, OpenBSD) to seed its PRNG. Preferred over /dev/urandom on
  Linux because /dev/urandom may not block early in boot, whereas
  getentropy() guarantees sufficient entropy. If getentropy() fails and
  USE_URANDOM is not explicitly disabled, /dev/urandom is used as
  a fallback.
*>
// const USE_GETENTROPY = 1;

<*
  USE_URANDOM — Use /dev/urandom for seeding.

  When enabled (1), the SSL engine reads /dev/urandom to seed its PRNG.
  Available on all Unix-like platforms.
*>
// const USE_URANDOM = 1;

<*
  USE_WIN32_RAND — Use Win32 CryptoAPI for seeding.

  When enabled (1), the SSL engine uses CryptAcquireContext() and
  CryptGenRandom() to seed its PRNG. Applicable on Windows targets.
  If both USE_URANDOM and USE_WIN32_RAND are enabled,
  USE_URANDOM takes precedence.
*>
// const USE_WIN32_RAND = 1;

// ============================================================================
// Time source flags
// ============================================================================

<*
  USE_UNIX_TIME — Use POSIX time() for X.509 validation.

  When enabled (1), the X.509 validation engine obtains the current time
  via time(), treating the returned time_t as seconds since the Unix Epoch
  (1970-01-01 00:00 UTC).
*>
// const USE_UNIX_TIME = 1;

<*
  USE_WIN32_TIME — Use Win32 GetSystemTimeAsFileTime() for X.509 validation.

  When enabled (1), the X.509 validation engine obtains the current time
  via the Win32 function GetSystemTimeAsFileTime(). If both
  USE_UNIX_TIME and USE_WIN32_TIME are enabled, USE_UNIX_TIME
  takes precedence.
*>
// const USE_WIN32_TIME = 1;

// ============================================================================
// Platform / compiler optimisation flags
// ============================================================================

<*
  ARMEL_CORTEXM_GCC — ARM Thumb / Cortex-M inline assembly.

  When enabled (1), certain operations are replaced with GCC inline
  assembly that is shorter and/or faster. Requires all of:
    - Target architecture: ARM in Thumb mode
    - Target endianness: little-endian
    - Compiler: GCC or a GCC-compatible compiler (for inline assembly syntax)
  Intended for low-end cores: Cortex-M0, M0+, M1, M3.
  Enabling this flag also enables LOMUL unless that flag is explicitly
  set.
*>
// const ARMEL_CORTEXM_GCC = 1;

<*
  AES_X86NI — x86 AES-NI instruction support.

  When enabled (1), the AES implementation that uses dedicated x86 AES
  opcodes is compiled. When absent, support is autodetected by checking
  the compiler. Set explicitly to 0 to prevent compilation of this
  implementation entirely.
*>
// const AES_X86NI = 1;

<*
  SSE2 — SSE2 intrinsics support.

  When enabled (1), SSE2 intrinsics are used for implementations that
  benefit from them (e.g. chacha20_sse2). When absent, support is
  autodetected. Set explicitly to 0 to suppress all SSE2 code.
*>
// const SSE2 = 1;

<*
  POWER8 — POWER ISA 2.07 AES opcodes.

  When enabled (1), the AES implementation that uses POWER8 vector-crypto
  instructions is compiled. When absent, support is autodetected by
  checking both the compiler and the target architecture. Requires a
  POWER8 or later processor.
*>
// const POWER8 = 1;

// ============================================================================
// 128-bit multiplication flags
// ============================================================================

<*
  INT128 — GCC/Clang unsigned __int128 support.

  When enabled (1), code using 'unsigned __int128' is compiled to leverage
  64×64→128-bit unsigned multiplications. Works with GCC and compatible
  compilers on 64-bit architectures.
*>
// const INT128 = 1;

<*
  UMUL128 — MSVC _umul128 / _addcarry_u64 intrinsics.

  When enabled (1), code using the _umul128() and _addcarry_u64()
  intrinsics is compiled to implement 64×64→128-bit unsigned multiplications.
  Works on Visual C targeting x64.
*>
// const UMUL128 = 1;

// ============================================================================
// Unaligned memory access flags
// ============================================================================

<*
  LE_UNALIGNED — Little-endian with unaligned access support.

  When enabled (1), the target architecture is assumed to use little-endian
  integer encoding and to support unaligned memory accesses with no or
  negligible performance penalty. Enables direct memory read/write shortcuts
  in the encode/decode functions.
*>
// const LE_UNALIGNED = 1;

<*
  BE_UNALIGNED — Big-endian with unaligned access support.

  When enabled (1), the target architecture is assumed to use big-endian
  integer encoding and to support unaligned memory accesses with no or
  negligible performance penalty.
*>
// const BE_UNALIGNED = 1;
