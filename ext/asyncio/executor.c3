// executor.c3

module ext::asyncio;

import std::thread;
import ext::debug;
import ext::mem;

alias ExecutorFn = fn void*(void*);

struct ExecutorWork {
    ExecutorFn func;
    void* arg;
    void* result;
    Future* future;
    EventLoop* loop;
}

fn void _executor_wakeup(void* work)
{
    ExecutorWork* w = (ExecutorWork*)work;
    if (! w.future.done()) {
        w.future.set_result(null); // notify finish
    }
    mem_free(w);
}

fn int _executor_thread(void* work)
{
    ExecutorWork* w = (ExecutorWork*)work;

    w.result = w.func(w.arg); // blocking operation runs on OS thread

    w.loop.call_soon_threadsafe(&_executor_wakeup, w); // safe cross-thread wakeup
    
    return 0;
}

// Public API

// Run blocking func(arg) in a new OS thread.
// The calling fiber suspends until the thread completes.

fn void*? EventLoop.run_in_executor(&self, ExecutorFn func, void* arg = null)
{
    Future* fut = self.create_future();

    ExecutorWork* w = mem_alloc(ExecutorWork);
    *w = {
        .func = func, 
        .arg = arg, 
        .result = null, 
        .future = fut,
        .loop = self,
    };

    thread::Thread t;
    t.create(&_executor_thread, w)!!;
    t.detach()!!;

    void* r = fut.await()!; // fiber yields here; resumes in _executor_wakeup

    self._defer_free_future(fut);

    return w.result;
}

// Module-level shorthand — uses the currently running loop.
fn void*? run_in_executor(ExecutorFn func, void* arg = null)
{
    return get_running_loop().run_in_executor(func, arg)!;
}

