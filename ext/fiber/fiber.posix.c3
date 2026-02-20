// fiber.posix.c3

module ext::thread::fiber @if(!env::WIN32 && (env::X86_64 || env::AARCH64));

import unistd; // sysconf
import sys::mman; // mprotect
import std::io;

alias Fiber = void*;
alias SwapFn = fn void(Fiber, Fiber) @callconv("stdcall");

tlocal long[64] active_buffer;
tlocal Fiber active_handle = null;
tlocal Fiber primary = null;
SwapFn asm_swap = null;

char[4096] asmblock @align(4096);

macro void warn(String fmt, args...)
{
  io::printf("%s,%s: ", $$FILE, $$LINE); io::printfn(fmt, ...args);
}

bool initialized = false;
fn void init() 
{
    if (initialized) return;
    
    asmblock[0:ASM.len] = ASM[0:ASM.len];
    ulong addr = (ulong)(void*)&asmblock;
    ulong page_size = (ulong)unistd::sysconf(unistd::_SC_PAGESIZE);
    ulong base = addr - (addr % page_size);
    ulong size = (addr - base) + (ulong)asmblock.len;
    mman::mprotect((void*)base, (usz)size, mman::PROT_READ | mman::PROT_EXEC);

    asm_swap = (SwapFn)(void*)&asmblock;

    active_handle = (Fiber) &active_buffer;
    primary = active_handle;
}

// ========================================
// crash — safety net if a coroutine entrypoint ever returns
// ========================================

fn void crash() @noreturn {
    unreachable("crash");
}

// ========================================
// Public API
// ========================================

/// Return the currently active coroutine handle.
fn Fiber active() 
{
    if (! initialized) init();
    if (active_handle == null) {
        active_handle = (Fiber)&active_buffer;
    }
    return active_handle;
}

/*
### Stack Layout (x86-64)

memory (handle base)
┌──────────────────┐
│  handle[0]       │  ← initial rsp (points to p)
│  handle[1..N]    │  ← callee-saved registers saved here after first swap
│  ...             │
│  &crash          │  ← *p+1  (guard: called if entrypoint returns)
│  entrypoint addr │  ← *p    (popped → rax, then jmp rax)
└──────────────────┘  ← stack_top (16-byte aligned, 32 bytes below raw top)

*/

/// Create a coroutine in caller-supplied memory (zero-copy).
alias ThreadFn = fn void();
fn Fiber create(uint stack_size, ThreadFn threadfn) 
{
    if (initialized) init();
    if (active_handle == null) {
        active_handle = (Fiber)&active_buffer;
    }

    void* memory = mem::malloc(stack_size);
    Fiber handle = (Fiber)memory;

    if (handle != null) {
        // Build the initial stack layout:
        //
        //   handle[0]  = rsp  → points to p below
        //
        //   stack grows downward:
        //   ┌──────────────┐ ← stack_top (16-byte aligned, 32 bytes reserved)
        //   │  &crash      │ ← called if entrypoint returns
        //   │  entrypoint  │ ← popped into rax by the swap stub, then jmp rax
        //   └──────────────┘ ← p  (stored as initial rsp in handle[0])
        //
        ulong stack_top = (ulong)handle + stack_size;
        stack_top -= 32; // shadow space / ABI reserve
        stack_top &= ~((ulong)15); // 16-byte alignment

        long* p = (long*)stack_top;
        p--;
        *p = (long)(void*)&crash; // return address guard
        p--;
        *p = (long)(void*)threadfn; // initial instruction pointer

        *((long*)handle) = (long)p; // store rsp in handle[0]
    }

    return handle;
}


fn void delete(Fiber handle) 
{
    mem::free(handle);
}

fn void switch_to(Fiber handle) 
{
    Fiber prev = active_handle;
    active_handle = handle;
    asm_swap(handle, prev);
}

fn void yield()
{
    switch_to(primary);
}

