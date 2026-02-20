
// fiber.sjlj.c3

module ext::thread::fiber @if(env::POSIX && !env::X86_64 && !env::AARCH64);

import signal;
import setjmp;


/**
 * Coroutine implementation based on POSIX sigsetjmp/siglongjmp
 * Original: Based on ideas from a paper by Ralf Engelschall
 */

alias Fiber  = void*;
alias Coroutine = fn void();

struct FiberStruct {
    SigJmpBuf context;
    Coroutine entry;
    void*     stack;
}

tlocal FiberStruct  primary;
tlocal FiberStruct* creating = null;
tlocal FiberStruct* running = null;


// Signal handler that runs on the new coroutine's stack.
// If sigsetjmp() returns 0, the stack context has just been saved — return immediately.
// If re-entered via siglongjmp() (returns != 0), execute the coroutine entry point.

fn void springboard(CInt ignored) 
{
    if (setjmp::sigsetjmp(&creating.context, 0) != 0) {
        running.entry();
    }
}

// Shared signal-stack setup logic used by both create() and derive().
fn void init_common(FiberStruct* thread, Coroutine entry, Stack* stack) 
{
    SigAction handler;
    SigAction old_handler;
    Stack old_stack;

    thread.entry = null;
    thread.stack   = null;

    stack.ss_flags = 0;
    // stack.ss_sp and stack.ss_size are set by the caller

    if (stack.ss_sp != null && signal::sigaltstack(stack, &old_stack) == 0) {
        handler.sa_handler = &springboard;
        handler.sa_flags   = signal::SA_ONSTACK;
        signal::sigemptyset(&handler.sa_mask);
        creating = thread;

        if (signal::sigaction(signal::SIGUSR1, &handler, &old_handler) == 0) {
            if (signal::raise(signal::SIGUSR1) == 0) {
                thread.entry = entry;
            }
            signal::sigaltstack(&old_stack, null);
            signal::sigaction(signal::SIGUSR1, &old_handler, null);
        }
    }
}

fn Fiber active() 
{
    if (running == null) running = &primary;
    return (Fiber)running;
}

/**
 * Create a coroutine from a pre-allocated memory block.
 * The FiberStruct occupies the front of the block; the remainder is used as the stack.
 */
fn Fiber derive(void* memory, uint size, Coroutine entry) 
{
    if (running == null) running = &primary;

    FiberStruct* thread = (FiberStruct*)memory;
    memory = (char*)memory + FiberStruct.sizeof;
    size  -= (uint)FiberStruct.sizeof;

    if (thread != null) {
        Stack stack;
        stack.ss_size = size;
        thread.stack = memory;
        stack.ss_sp = memory;

        init_common(thread, entry, &stack);

        if (thread.entry != entry) {
            // derive uses external memory, so just null out the stack pointer on failure
            thread.stack = null;
            thread = null;
        }
    }

    return (Fiber)thread;
}

/**
 * Create a coroutine with heap-allocated memory.
 */
fn Fiber create(uint stack_size, Coroutine entry) 
{
    if (running == null) running = &primary;

    FiberStruct* thread = (FiberStruct*)mem::malloc(FiberStruct.sizeof);
    if (thread != null) {
        Stack stack;
        stack.ss_size = stack_size;
        thread.stack = mem::malloc(stack_size);
        stack.ss_sp = thread.stack;

        init_common(thread, entry, &stack);

        if (thread.entry != entry) {
            delete((Fiber)thread);
            thread = null;
        }
    }

    return (Fiber)thread;
}

fn void delete(Fiber thread) {
    if (thread != null) {
        FiberStruct* t = (FiberStruct*)thread;
        if (t.stack != null) {
            mem::free(t.stack);
        }
        mem::free(thread);
    }
}

fn void switch_to(Fiber thread) {
    if (setjmp::sigsetjmp(&running.context, 0) == 0) {
        running = (FiberStruct*)thread;
        setjmp::siglongjmp(&running.context, 1);
    }
}

fn void yield()
{
    if (setjmp::sigsetjmp(&running.context, 0) == 0) {
        running = &primary;
        setjmp::siglongjmp(&running.context, 1);
    }
}
