# asyncio for C3

This is a C3 version of Python's asyncio library. It follows the python's API, because it is the easiest one among its kind.

It's based on C3's [fiber](../fiber/README.md) coroutine.

### Available module

| Module | Description |
|--------|-------------|
| `ext::asyncio` | Python asyncio-similar operationsFuture, Task, EventLoop, Stream, Datagram, Transport, Protocol, DatagramProtocol |

This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

### Key concepts

* `Future` is a kind of variable holder, which will be filled in the future. Main action on a future is `.await()` until the value gets filled in the future in some other function.
* `Task` is a handler of a coroutine, that is running independantly. A task `.await()` to finish. If not awaited, a task can finish silently and `autofree` itself. Within a task, we can call `.set_result(void*)` onto a future.
* `EventLoop` is a scheduler. Everything is initiated by the scheduler. `.create_future()` or `.create_task()`. You can `.run()` an event loop, you can `.gather()` tasks.
* `EventLoop` does various othe scheduling things like `.sleep()`, `.wait_for()`, `.call_later()`.
* For more controle of concurrency, `Lock`, `Queue`, `Semaphore`, `Event` or `Channel` can be utilized.
* `TaskGroup` is for multiple tasks to be `.create_task()` or for joining `.wait()`.
* For networking, `Stream` is for TCP, `Datagram` is for UDP. You can `.open_connection()` to get a client `Stream`, you can `.open_datagram()` to get a client `Datagram`.
* `Server` is a TCP server. You can `.start_server()` to make a server, and call `.serve_forever()` for indefinite service.
* For UDP, you can `.bind_datagram()` to get a server `Datagram`. Simple "UDP" `.socket()` is used to call `.sock_sendto()` or `.sock_recvfrom()` for communication with the server `Datagram`.
* Event driven, callback style communication is done by implementing `Protocol` (TCP) or `DatagramProtocol` (UDP) interfaces. These interfaces require implementing reactive functions like `.connection_made()`, `.data_received()`, `.connection_lost()` or `.error_received()`. In this case, real data transfer is done through `Transport`.

### Files

* [common.c3](common.c3): debugging, mem allocation
* [loop.c3](loop.c3): EventLoop, scheduling
* [future.c3](future.c3): Future, Task
* [primitives.c3](primitives.c3): Lock, Queue, Semaphore, Event, Channel
* [taskgroup.c3](taskgroup.c3): TaskGroup
* [io.posix.c3](io.posix.c3): async io for posix
* [io.win32.c3](io.win32.c3): async io for windows
* [net.posix.c3](net.posix.c3): net sockets for posix
* [net.win32.c3](net.win32.c3): net sockets fo windows
* [stream.c3](stream.c3): TCP Stream
* [datagram.c3](datagram.c3): UDP Datagram
* [protocol.c3](protocol.c3): Protocol, DatagramProtocol, Transport

* [../../examples/asyncio/sample1.c3](../../examples/asyncio/sample1.c3)
* [../../examples/asyncio/sample2.c3](../../examples/asyncio/sample2.c3)
* [../../examples/asyncio/sample3.c3](../../examples/asyncio/sample3.c3)
* [../../examples/asyncio/sample4.c3](../../examples/asyncio/sample4.c3)
* [../../examples/asyncio/sample5.c3](../../examples/asyncio/sample5.c3)
* [../../examples/asyncio/sample6.c3](../../examples/asyncio/sample6.c3)
* [../../examples/asyncio/sample7.c3](../../examples/asyncio/sample7.c3)
* [../../examples/asyncio/sample8.c3](../../examples/asyncio/sample8.c3)
* [../../examples/asyncio/sample9.c3](../../examples/asyncio/sample9.c3)
* [../../examples/asyncio/sample10.c3](../../examples/asyncio/sample10.c3)
* [../../examples/asyncio/sample11.c3](../../examples/asyncio/sample11.c3)
* [../../examples/asyncio/sample12.c3](../../examples/asyncio/sample12.c3)
