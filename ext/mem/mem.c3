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
    
    void*? p = allocator::alloc_try(allocx, $Type);
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

macro temp_alloc($Type) @builtin
{
    return allocator::alloc(tmem, $Type);
}

macro temp_malloc(n) @builtin
{
    return allocator::malloc(tmem, n);
}

macro temp_alloc_array($Type, n) @builtin
{
    return allocator::alloc_array(tmem, $Type, n);
}

macro temp_free(x) @builtin
{
    // do nothing:
    // at the end of `@pool() {...};` macro scope,
    // `tmem` allocated memory gets free'd 
    // all at once automatically.
}

alias LocalAllocator = Allocator;

fn void* LocalAllocator.malloc(&self, usz size) @inline
{
    void*? a = self.acquire(size, ZERO, 0);
    if (catch a) return null;
    return a;
}

macro LocalAllocator.alloc(&self, $Type)
{
    return ($Type*) self.malloc($Type.sizeof);
}

macro LocalAllocator.alloc_array(&self, $Type, $n)
{
    return ($Type[]) self.malloc($Type.sizeof*$n);
}

fn void LocalAllocator.free(&self, void* a)
{
    self.release(a, false);
}
