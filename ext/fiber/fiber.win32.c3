
module ext::thread::fiber @if(env::WIN32);

import winbase;

alias FiberProc = fn void(void* param);
alias WinFiber = void*;

struct Fiber {
    WinFiber wfiber;
    bool done;
}

tlocal Fiber* running = null;
tlocal Fiber primary;

alias Coroutine = fn void();

fn void thunk(void* coentry) @callconv("stdcall") @private
{
    ((Coroutine)coentry)();
}

fn void init(Allocator allocx=mem, bool debug=true) @private
{
    if (running != null) return;
    primary.wfiber = winbase::convertThreadToFiber(null);
    // active_ = winbase::getCurrentFiber();
    running = &primary;
}

fn Fiber* active() 
{
    if (running == null) init();
    return running;
}

fn Fiber* create(uint stack_size, Coroutine coroutine) 
{
    if (running == null) init();
    Fiber* fiber = mem::alloc(Fiber);
    fiber.wfiber = winbase::createFiber(stack_size, &thunk, (void*)coroutine);
    fiber.done = false;
    return fiber;
}

fn void delete(Fiber* fiber) 
{
    if (fiber == null || fiber == &primary) return;
    winbase::deleteFiber(fiber.wfiber);
    mem::free(fiber);
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

