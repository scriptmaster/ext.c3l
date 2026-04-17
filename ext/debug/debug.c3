// debug.c3

module ext::debug;

import std::io;
import c::stdlib;

macro void warn(String fmt, args...) @builtin
{
    io::printf("%s,%d: ", $$FILE, $$LINE);
    io::printfn(fmt, ...args);
}

// Compile-time gated assertion: eliminated entirely in release builds.
// Uses a lazy (#expr) parameter so the condition is never evaluated in release builds.
macro @assert(#expr, String msg) @builtin
{
    $if $build::is_debug:
        if (debug) return;
        if (!(#expr)) { warn("%s", msg); stdlib::exit(1); }
    $endif
}

// Compile-time gated leak reporter: wraps body in @assert_leak only in debug builds.
macro @debug_leak(; @body) @builtin
{
    $if $build::is_debug:
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

