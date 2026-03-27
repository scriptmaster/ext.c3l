// mem.c3

module ext::mem;

import ext::debug;

Allocator allocx = null;

macro void set_allocator(Allocator alloc) @public
{
    if (allocx != null) { // not default allocator
        warn("Allocator is already set.");
        return;
    }
    allocx = alloc;
}

macro mem_alloc($Type) @builtin
{
    if (allocx == null) allocx = mem;
    
    void*? p = allocator::malloc_try(allocx, $Type.sizeof);
    if (catch err = p) {
        @assert(false, "memory allocation error");
        unreachable("mem_alloc failed");
    } else {
        return p;
    }
}

macro mem_malloc(n) @builtin
{
    if (allocx == null) allocx = mem;
  
    void*? p = allocator::malloc_try(allocx, n);
    if (catch err = p) {
        @assert(false, "memory allocation error");
        unreachable("mem_malloc failed");
    } else {
        return p;
    }
}

macro mem_alloc_array($Type, n) @builtin
{
    if (allocx == null) allocx = mem;
  
    $Type[]? p = allocator::alloc_array_try(allocx, $Type, n);
    if (catch err = p) {
        @assert(false, "memory allocation error");
        unreachable("mem_alloc_array failed");
    } else {
        return ($Type[])p;
    }
}

macro mem_free(x) @builtin
{
    if (allocx == null) allocx = mem;
    
    if ((void*)x == null) { warn("mem_free(null)"); return; }
    allocator::free(allocx, x);
}
