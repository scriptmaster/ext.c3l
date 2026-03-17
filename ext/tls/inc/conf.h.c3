// bearssl.h.c3
//
// C3 bindings for BearSSL bearssl.h
// Main umbrella module — imports all sub-modules and defines the
// compile-time configuration query API.
//
// Naming conventions:
//   br_config_option  → ConfigOption
//   br_get_config     → get_config   (extern fn)
//
// API Layout (corresponding .c3 binding files):
//   hash.h.c3    — Hash functions
//   hmac.h.c3    — HMAC
//   kdf.h.c3     — Key Derivation Functions (HKDF, SHAKE)
//   rand.h.c3    — Pseudo-random byte generators (HMAC_DRBG, AESCTR_DRBG)
//   prf.h.c3     — PRF implementations (for SSL/TLS)
//   block.h.c3   — Symmetric encryption (AES, DES, ChaCha20, Poly1305)
//   aead.h.c3    — AEAD algorithms (GCM, EAX, CCM)
//   rsa.h.c3     — RSA encryption and signatures
//   ec.h.c3      — Elliptic curves (EC + ECDSA)
//   ssl.h.c3     — SSL/TLS engine interface
//   x509.h.c3    — X.509 certificate decoding and validation
//   pem.h.c3     — PEM encoder/decoder
//
// conventions (apply throughout all sub-modules):
//
//   MUST / SHALL
//     Failure to meet requirements expressed with MUST or SHALL implies
//     undefined behaviour (segfaults, buffer overflows, etc.).
//     does not perform internal validation of caller-side preconditions.
//
//   NULL pointers
//     Pointer parameters MUST NOT be null unless the documentation
//     explicitly permits it. Exception: a pointer to a byte sequence
//     accompanied by a length parameter of zero may be null even if not
//     explicitly stated.
//
//   Memory allocation
//     performs NO dynamic memory allocation. The caller is
//     responsible for allocating all context structures (stack, heap, or
//     static storage). There are no release / close functions; when done,
//     the caller simply discards the context (stack variables are released
//     implicitly).
//
//   Structure opacity
//     Structure contents are opaque unless explicitly documented otherwise.
//     Structures are exposed in headers only so that the compiler can
//     determine size and alignment. Individual fields MUST NOT be accessed
//     directly; use the accessor functions provided by the API.

