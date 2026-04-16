// fiber.win32.c3

module ext::thread::fiber @if(env::WIN32);

import c::winbase;
import ext::mem;

alias FiberProc = fn void(void* param);
alias WinFiber = void*;

struct Fiber {
    WinFiber wfiber;
    bool done;
}

tlocal Fiber* running = null;
tlocal Fiber primary;
tlocal bool converted_thread = false;

alias Coroutine = fn void();

fn void thunk(void* coentry) @callconv("stdcall") @private
{
    ((Coroutine)coentry)();
    // If user coroutine returns without calling done(), finish safely instead of returning from the fiber entrypoint.
    // Skip primary fiber because done() is only valid for secondary coroutine fibers.
    if (running != null && running != &primary && !running.done) {
        done();
    }
}

fn void init(Allocator allocx=mem, bool debug=true) @private
{
    if (running != null) return;
    primary.wfiber = winbase::convertThreadToFiber(null);
    @assert(primary.wfiber != null, "fiber::init(): ConvertThreadToFiber failed");
    converted_thread = true;
    // active_ = winbase::getCurrentFiber();
    running = &primary;
}

fn void deinit()
{
    if (running == null) {
        converted_thread = false;
        return;
    }
    if (converted_thread) {
        converted_thread = false;
        @assert(winbase::convertFiberToThread() != 0, "fiber::deinit(): ConvertFiberToThread failed");
    }
    primary = {};
    running = null;
}

fn Fiber* active() 
{
    if (running == null) init();
    return running;
}

fn Fiber* create(uint stack_size, Coroutine coroutine) 
{
    if (running == null) init();
    Fiber* fiber = mem_alloc(Fiber);
    fiber.wfiber = winbase::createFiber(stack_size, &thunk, (void*)coroutine);
    @assert(fiber.wfiber != null, "fiber::create(): CreateFiber failed");
    fiber.done = false;
    return fiber;
}

fn void delete(Fiber* fiber) 
{
    if (fiber == null || fiber == &primary) return;
    winbase::deleteFiber(fiber.wfiber);
    mem_free(fiber);
}

fn void switch_to(Fiber* fiber) 
{
    if (fiber == null || fiber.done) return;
    running = fiber;
    winbase::switchToFiber(fiber.wfiber);
}

fn void yield()
{
    if (running == &primary) return;
    switch_to(&primary);
}

fn void done() 
{
    running.done = true;
    yield();
}
