# asyncio for C3

This is a C3 port of Python's asyncio library. It follows Python's API, as it is the most approachable among libraries of its kind.
It is based on C3's [fiber](../fiber/README.md) coroutine.

### Available module

| Module | Description |
|--------|-------------|
| `ext::asyncio` | Python asyncio-similar operations: Future, Task, EventLoop, Stream, Datagram, Transport, Protocol, DatagramProtocol |

This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

### Key concepts

* `Future` is a value container that will be filled at some point in the future. The primary operation on a future is `.await()`, which blocks until another coroutine calls `.set_value()` to fill it.
* `Task` is a handle for an independently running coroutine. A task can be `.await()`ed to wait for its completion. If not awaited, a task can finish silently and `autofree` itself. Within a task, `.set_result(void*)` can be called on a future.
* `EventLoop` is a scheduler. All activity is driven by the scheduler. It provides `.create_future()` and `.create_task()`. An event loop can be started with `.run()`, and `.gather()` can be used to join and free multiple tasks.
* `EventLoop` also handles other scheduling operations such as `.sleep()`, `.wait_for()`, and `.call_later()`.
* For finer concurrency control, `Lock`, `Queue`, `Semaphore`, `Event`, or `Channel` can be used.
* `TaskGroup` allows multiple tasks to be created via `.create_task()` and joined via `.wait()`.
* For networking, `Stream` handles TCP and `Datagram` handles UDP. Use `.open_connection()` to obtain a client `Stream`, and `.open_datagram()` to obtain a client `Datagram`.
* `Server` is a TCP server. Use `.start_server()` to create one, then call `.serve_forever()` to run it indefinitely.
* For UDP, use `.bind_datagram()` to obtain a server-side `Datagram`. A plain UDP `.socket()` can then call `.sock_sendto()` or `.sock_recvfrom()` to communicate with the server `Datagram`.
* Event-driven, callback-style communication is achieved by implementing interfaces such as `Protocol` (for TCP) or `DatagramProtocol` (for UDP). These interfaces require implementing reactive methods like `.connection_made()`, `.data_received()`, `.connection_lost()`, and `.error_received()`. Actual data transfer is performed through a `Transport`.


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
