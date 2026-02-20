
module ext::thread::fiber @if(env::WIN32);

import winbase;

alias FiberProc = fn void(void* param);
alias Fiber = void*;

tlocal Fiber active_ = null;
tlocal Fiber primary = null;

alias ThreadFn = fn void();

fn void thunk(void* coentry) @callconv("stdcall") 
{
    ((ThreadFn)coentry)();
}

bool initialized = false;
fn void init()
{
    if (initialized) return;
    active_ = winbase::convertThreadToFiber(null);
    // active_ = winbase::getCurrentFiber();
    primary = active_;
}

fn Fiber active() 
{
    if (!initialized) init();
    return active_;
}

fn Fiber create(uint stack_size, ThreadFn threadfn) 
{
    if (!initialized) init();
    return winbase::createFiber(stack_size, &thunk, (void*)threadfn);
}

fn void delete(Fiber fiber) 
{
    winbase::deleteFiber(fiber);
}

fn void switch_to(Fiber fiber) 
{
    active_ = fiber;
    winbase::switchToFiber(fiber);
}

fn void yield()
{
    switch_to(primary);
}
