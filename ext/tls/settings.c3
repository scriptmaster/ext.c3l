// config.c3

// Builds a compile-time snapshot of all active configuration flags and
// exposes it via get_config().
//
// Each entry reflects whether the corresponding xxx constant was
// defined (and non-zero) at compile time. Flags that are absent or
// commented out in config.h.c3 evaluate to 0.
//
// In C3, `$defined(XXX)` tests whether the symbol exists, and
// `XXX` provides its value. The ternary expression
//   $defined(XXX) && XXX != 0 ? 1 : 0
// is a compile-time constant expression.

module ext::net::tls;

// ============================================================================
// Compile-time config table
// ============================================================================

ConfigOption[*] config @private = {

    // ---- 64-bit / arithmetic -----------------------------------------------
    { "I64",
        ($defined(I64)              && I64             != 0) ? 1 : 0 },
    { "LOMUL",
        ($defined(LOMUL)           && LOMUL          != 0) ? 1 : 0 },
    { "SLOW_MUL",
        ($defined(SLOW_MUL)        && SLOW_MUL       != 0) ? 1 : 0 },
    { "SLOW_MUL15",
        ($defined(SLOW_MUL15)      && SLOW_MUL15     != 0) ? 1 : 0 },
    { "CT_MUL31",
        ($defined(CT_MUL31)        && CT_MUL31       != 0) ? 1 : 0 },
    { "CT_MUL15",
        ($defined(CT_MUL15)        && CT_MUL15       != 0) ? 1 : 0 },
    { "NO_ARITH_SHIFT",
        ($defined(NO_ARITH_SHIFT)  && NO_ARITH_SHIFT != 0) ? 1 : 0 },
    { "INT128",
        ($defined(INT128)          && INT128         != 0) ? 1 : 0 },
    { "UMUL128",
        ($defined(UMUL128)         && UMUL128        != 0) ? 1 : 0 },

    // ---- Architecture ------------------------------------------------------
    { "I386",
        ($defined(I386)            && I386           != 0) ? 1 : 0 },
    { "AM64",
        ($defined(AMD64)           && AMD64          != 0) ? 1 : 0 },
    { "LE_UNALIGNED",
        ($defined(LE_UNALIGNED)    && LE_UNALIGNED   != 0) ? 1 : 0 },
    { "BE_UNALIGNED",
        ($defined(BE_UNALIGNED)    && BE_UNALIGNED   != 0) ? 1 : 0 },

    // ---- Compiler: GCC -----------------------------------------------------
    { "GCC",
        ($defined(GCC)             && GCC            != 0) ? 1 : 0 },
    { "GCC_4_4",
        ($defined(GCC_4_4)         && GCC_4_4        != 0) ? 1 : 0 },
    { "GCC_4_5",
        ($defined(GCC_4_5)         && GCC_4_5        != 0) ? 1 : 0 },
    { "GCC_4_6",
        ($defined(GCC_4_6)         && GCC_4_6        != 0) ? 1 : 0 },
    { "GCC_4_7",
        ($defined(GCC_4_7)         && GCC_4_7        != 0) ? 1 : 0 },
    { "GCC_4_8",
        ($defined(GCC_4_8)         && GCC_4_8        != 0) ? 1 : 0 },
    { "GCC_4_9",
        ($defined(GCC_4_9)         && GCC_4_9        != 0) ? 1 : 0 },
    { "GCC_5_0",
        ($defined(GCC_5_0)         && GCC_5_0        != 0) ? 1 : 0 },

    // ---- Compiler: Clang ---------------------------------------------------
    { "CLANG",
        ($defined(CLANG)           && CLANG          != 0) ? 1 : 0 },
    { "CLANG_3_7",
        ($defined(CLANG_3_7)       && CLANG_3_7      != 0) ? 1 : 0 },
    { "CLANG_3_8",
        ($defined(CLANG_3_8)       && CLANG_3_8      != 0) ? 1 : 0 },

    // ---- Compiler: MSVC ----------------------------------------------------
    { "MSC",
        ($defined(MSC)             && MSC            != 0) ? 1 : 0 },
    { "MSC_2005",
        ($defined(MSC_2005)        && MSC_2005       != 0) ? 1 : 0 },
    { "MSC_2008",
        ($defined(MSC_2008)        && MSC_2008       != 0) ? 1 : 0 },
    { "MSC_2010",
        ($defined(MSC_2010)        && MSC_2010       != 0) ? 1 : 0 },
    { "MSC_2012",
        ($defined(MSC_2012)        && MSC_2012       != 0) ? 1 : 0 },
    { "MSC_2013",
        ($defined(MSC_2013)        && MSC_2013       != 0) ? 1 : 0 },
    { "MSC_2015",
        ($defined(MSC_2015)        && MSC_2015       != 0) ? 1 : 0 },

    // ---- ISA / hardware features -------------------------------------------
    { "AES_X86NI",
        ($defined(AES_X86NI)       && AES_X86NI      != 0) ? 1 : 0 },
    { "SSE2",
        ($defined(SSE2)            && SSE2           != 0) ? 1 : 0 },
    { "RDRAND",
        ($defined(RDRAND)          && RDRAND         != 0) ? 1 : 0 },
    { "POWER8",
        ($defined(POWER8)          && POWER8         != 0) ? 1 : 0 },
    { "ARMEL_CORTEXM_GCC",
        ($defined(ARMEL_CORTEXM_GCC) && ARMEL_CORTEXM_GCC != 0) ? 1 : 0 },

    // ---- RNG source --------------------------------------------------------
    { "USE_GETENTROPY",
        ($defined(USE_GETENTROPY)  && USE_GETENTROPY != 0) ? 1 : 0 },
    { "USE_URANDOM",
        ($defined(USE_URANDOM)     && USE_URANDOM    != 0) ? 1 : 0 },
    { "USE_WIN32_RAND",
        ($defined(USE_WIN32_RAND)  && USE_WIN32_RAND != 0) ? 1 : 0 },

    // ---- Time source -------------------------------------------------------
    { "USE_UNIX_TIME",
        ($defined(USE_UNIX_TIME)   && USE_UNIX_TIME  != 0) ? 1 : 0 },
    { "USE_WIN32_TIME",
        ($defined(USE_WIN32_TIME)  && USE_WIN32_TIME != 0) ? 1 : 0 },

    // ---- Size constants (direct values, not boolean flags) -----------------
    { "MAX_EC_SIZE",     MAX_EC_SIZE     },
    { "MAX_RSA_SIZE",    MAX_RSA_SIZE    },
    { "MAX_RSA_FACTOR",  MAX_RSA_FACTOR  },

    // ---- Sentinel ----------------------------------------------------------
    { null, 0 }
};

// ============================================================================
// Public API
// ============================================================================

<*
  A single compile-time configuration option.

  Each option has a symbolic name (matching the internal macro name that
  can be set in config.h.c3) and a long integer value. For boolean
  options the value is 1 (enabled) or 0 (disabled). For capacity options
  (e.g. maximum key sizes) the value is expressed in bits.

  The array returned by get_config() is terminated by an entry whose
  name field is null.
*>
struct ConfigOption {
    <* Symbolic option name (e.g. "MAX_RSA_SIZE"), or null for the sentinel. *>
    char* name;
    <* Option value (1/0 for booleans; bits for sizes; other integers as appropriate). *>
    long value;
}


<*
  Return the compile-time configuration report.

  Returns a pointer to a null-terminated array of ConfigOption entries
  describing every option that was active when this module was compiled.
  The last entry has a null name field. The array is statically allocated;
  the caller MUST NOT free or modify it.

  return pointer to the (null-terminated) configuration option array.
*>
fn ConfigOption* get_config()
{
    return &config[0];
}
