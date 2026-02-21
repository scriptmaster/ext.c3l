# Fiber - a lightweight coroutine in C3

This is a co-operative non-preemptive coroutine in C3. Extremely lightweight and supports multiplatform. Based on [libco](https://github.com/higan-emu/libco)

It provides a lightweight cooperative multitasking system, allowing you to create and switch between multiple execution contexts (fibers) within a single thread.

### Based on
* X86_64, AARCH64: Assembly code, fast switching
* Windows: Native Fiber interface
* Other Posix: based on sigsetjmp() /siglongjmp()

### Available module

| Module | Description |
|--------|-------------|
| `ext::thread::fiber` | Fiber operations: create(), delete(), active(), switch_to(), yield(), done() |


This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

### API functions

```c3 
import ext::thread::fiber;

alias Coroutine = fn void(); // Coroutine

Fiber* fiber = fiber::active(); // get currently active fiber
Fiber* fiber = fiber::create(uint stack_size, Coroutine coroutine); // 64K < stack_size
void fiber::switch_to(fiber);
void fiber::yield(); // yield to primary fiber
void fiber::done(); // at the end of Coroutine, you must call this
void fiber::delete(fiber);
```

Files:
* [fiber.win32.c3](fiber.win32.c3)
* [fiber.posix.c3](fiber.posix.c3)
* [fiber.asm.c3](fiber.asm.c3)
* [fiber.sjlj.c3](fiber.sjlj.c3)
* [../../examples/fiber/fiber_test.c3](../../examples/fiber/fiber_test.c3)


## How It Works

1. `fiber::active()` returns currently active fiber.
2. `fiber::create()` allocates a new fiber with its own stack. The coroutine function has plain `fn void()` signature. Minimum stack size is 64k.
3. `fiber::switch_to(fiber)` hands execution over to the target fiber. Control returns to the caller only when that fiber calls `fibed::yield()` or `fiber::switch_to()` back.
4. `fiber::yield()` is a convenience wrapper that always returns control to the primary fiber, making it behave like a standard coroutine suspend point.
5. At the end of a coroutine, you need to call `fiber::done()`
6. Cleanup is done by calling `fiber::delete()`


## Important Notes

- **Cooperative only.** Fibers never preempt each other. You must call `fiber::yield()` or `fiber::switch_to()` explicitly to transfer control. 
- At the end of a `Coroutine` function, **you must call `fiber::done()`**
- Fibers must not be shared across threads.
- **Stack size.** The `stack_size` parameter in `fiber::create()` sets the fiber's initial stack size in bytes. A value of `64 * 1024` (64 KB) is a reasonable minimum for lightweight coroutines.
- **Cleanup.** Always call `fiber::delete()` on fibers that you no longer need, to avoid memory leaks. Do not delete the currently running fiber.

## Usage Example

```c3
module example;

import ext::thread::fiber;

int counter = 0;

fn void my_coroutine()
{
    for (int i = 0; i < 3; i++)
    {
        counter++;
        io::printfn("Coroutine step %d", i);
        fiber::yield(); // Suspend and return to scheduler
    }
    io::printfn("Coroutine done");
    
    fiber::done(); // you must call this at end
}

fn void main()
{
    // Initialize and create a fiber
    Fiber co = fiber::create(1024 * 64, &my_coroutine);

    // Drive the coroutine by repeatedly switching to it
    for (int step = 0; step < 4; step++)
    {
        io::printfn("Scheduler step %d", step);
        fiber::switch_to(co);
    }

    // Clean up
    fiber::delete(co);
    io::printfn("All done. Counter = %d", counter);
}
```

**Expected output:**
```
Scheduler step 0
Coroutine step 0
Scheduler step 1
Coroutine step 1
Scheduler step 2
Coroutine step 2
Scheduler step 3
Coroutine done
All done. Counter = 3
```


Back to [ext.c3l](../../README.md) library.

