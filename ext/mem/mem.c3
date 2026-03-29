// mem.c3

module ext::mem;

import c::string;
import ext::debug;

Allocator allocx = null;

macro void set_allocator(Allocator alloc) @public
{
    if (allocx != null) { // not default allocator
        if (allocx != alloc) {
            warn("Allocator is already set. Perhaps memory allocation has been made prior to this.");
        }
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

macro mem_copy(char[] str) @builtin
{
    if (allocx == null) allocx = mem;
  
    char*? p = allocator::malloc_try(allocx, str.len);
    if (catch err = p) {
        @assert(false, "memory allocation error");
        unreachable("mem_copy failed");
    } else {
        string::memcpy(p, str.ptr, str.len);
        return p[0:str.len];
    }
}

macro String mem_copy_str(String str) @builtin
{
    return (String) mem_copy((char[])str);
}

macro mem_free(x) @builtin
{
    if (allocx == null) allocx = mem;
    
    if ((void*)x == null) { warn("mem_free(null)"); return; }
    allocator::free(allocx, x);
}
