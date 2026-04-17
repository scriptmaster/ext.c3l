// debug.c3

module ext::debug;

import std::io;
import c::stdlib;

// Set to true (or pass --define ENABLE_ASSERT) to compile in @assert and @check_leak checks.
const bool ENABLE_ASSERT = false;

macro void warn(String fmt, args...) @builtin
{
    io::printf("%s,%d: ", $$FILE, $$LINE);
    io::printfn(fmt, ...args);
}

// Compile-time gated assertion: zero overhead when ENABLE_ASSERT is false.
// Uses a lazy (#expr) parameter so the condition is never evaluated in release builds.
macro @assert(#expr, String msg) @builtin
{
    $if ENABLE_ASSERT:
        if (debug) return;
        if (!(#expr)) { warn("%s", msg); stdlib::exit(1); }
    $endif
}

// Compile-time gated leak reporter: only wraps body in @assert_leak when ENABLE_ASSERT is true.
macro @check_leak(; @body) @builtin
{
    $if ENABLE_ASSERT:
        @assert_leak() { @body(); };
    $else
        @body();
    $endif
}

bool debug = true;

macro void set_debug(bool dbg) @public
{
    debug = dbg;
}

