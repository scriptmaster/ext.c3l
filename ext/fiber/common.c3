// common.c3

module ext::thread::fiber;

import std::io;
import string;
import stdlib;

macro void warn(String fmt, args...)
{
    io::printf("%s,%d: ", $$FILE, $$LINE);
    io::printfn(fmt, ...args);
}

macro _assert(expr, String msg) @private
{
    if (!(expr)) { warn("%s", msg); stdlib::exit(1); }
}

Allocator allocx;
bool debug = true;

fn void set_allocator(Allocator alloc) @public
{
    if (allocx != null && allocx != mem) { // not default allocator
        warn("Allocator is already set.");
        return;
    }
    allocx = alloc;
}

fn void set_debug(bool dbg) @public
{
    debug = dbg;
}

macro mem_alloc($Type) @private
{
    void*? p = allocator::malloc_try(allocx, $Type.sizeof);
    if (catch err = p) {
        _assert(false, "memory allocation error");
        unreachable("mem_alloc failed");
    } else {
        return p;
    }
}

macro mem_malloc(n) @private
{
    void*? p = allocator::malloc_try(allocx, n);
    if (catch err = p) {
        _assert(false, "memory allocation error");
        unreachable("mem_malloc failed");
    } else {
        return p;
    }
}

macro mem_alloc_array($Type, n) @private
{
    $Type[]? p = allocator::alloc_array_try(allocx, $Type, n);
    if (catch err = p) {
        _assert(false, "memory allocation error");
        unreachable("mem_alloc_array failed");
    } else {
        return ($Type[])p;
    }
}

macro mem_free(x) @private
{
    if ((void*)x == null) { warn("mem_free(null)"); return; }
    allocator::free(allocx, x);
}
