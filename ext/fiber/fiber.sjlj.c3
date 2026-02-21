
// fiber.sjlj.c3

module ext::thread::fiber @if(env::POSIX &&  !env::X86_64 && !env::AARCH64);

import signal;
import setjmp;


/**
 * Coroutine implementation based on POSIX sigsetjmp/siglongjmp
 * Original: Based on ideas from a paper by Ralf Engelschall
 */

alias Coroutine = fn void();

struct Fiber {
    SigJmpBuf context;
    Coroutine entry;
    void* stack;
    bool done;
}

tlocal Fiber primary;
tlocal Fiber* running = null;
tlocal Fiber* creating = null; 

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
fn void init_common(Fiber* fiber, Coroutine entry, Stack* stack) 
{
    SigAction handler;
    SigAction old_handler;
    Stack old_stack;

    // fiber.entry = null;
    // fiber.stack = null;

    stack.ss_flags = 0;
    // stack.ss_sp and stack.ss_size are set by the caller

    if (stack.ss_sp != null && signal::sigaltstack(stack, &old_stack) == 0) {
        handler.sa_handler = &springboard;
        handler.sa_flags   = signal::SA_ONSTACK;
        signal::sigemptyset(&handler.sa_mask);
        creating = fiber;

        if (signal::sigaction(signal::SIGUSR1, &handler, &old_handler) == 0) {
            if (signal::raise(signal::SIGUSR1) == 0) {
                fiber.entry = entry;
            }
            signal::sigaltstack(&old_stack, null);
            signal::sigaction(signal::SIGUSR1, &old_handler, null);
        }
    }
}

fn Fiber* active() 
{
    if (running == null) running = &primary;
    return running;
}

fn Fiber* create(uint stack_size, Coroutine entry) 
{
    if (running == null) running = &primary;

    Fiber* fiber = mem::alloc(Fiber);
    fiber.done = false;

    Stack stack;
    stack.ss_size = stack_size;
    fiber.stack = mem::malloc(stack_size);
    stack.ss_sp = fiber.stack;

    init_common(fiber, entry, &stack);

    return fiber;
}

fn void delete(Fiber* fiber) 
{
    if (fiber == null || fiber == &primary) return;

    mem::free(fiber.stack);
    mem::free(fiber);
}

fn void switch_to(Fiber* fiber) 
{
    if (fiber == null || fiber.done) return;
    if (setjmp::sigsetjmp(&running.context, 0) == 0) {
        running = fiber;
        setjmp::siglongjmp(&running.context, 1);
    }
}

fn void yield()
{
    if (running == &primary) return;
    
    if (setjmp::sigsetjmp(&running.context, 0) == 0) {
        running = &primary;
        setjmp::siglongjmp(&running.context, 1);
    }
}

fn void done() 
{
    running.done = true;
    yield();
}