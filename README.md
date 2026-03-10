# ext.c3l

An extended library for the C3 programming language, providing essential system-level functionality, networking capabilities, and cross-platform C header bindings.

## Overview

`ext.c3l` bridges the gap between C3 and system-level programming by providing:
- C header bindings (POSIX and Win32)
- High-level networking APIs (TCP, UDP, DNS)
- File system and I/O utilities
- Regular expression support
- Fiber coroutine 
- Async I/O for C3

## Why ext library?

C3 standard library is minimalistic, lacks something. Ext library fills the gap, and it's extremly lightweight.

## Installation

### Prerequisites

First, install the `c3l` library manager:

```bash
git clone https://github.com/konimarti/c3l
cd c3l
sudo make install
```

### Adding ext.c3l to Your Project

In your C3 project directory and fetch the library:

```bash
c3l fetch https://github.com/nomota/ext.c3l
```

This will download the library as a zip-packed file: `lib/ext.c3l`.

And in your `project.json`
```json
    "dependancies": [ "ext" ],
```

Now it's ready to be used in your project.


## Features

### C Header Bindings 

* [ext/libc](ext/libc)

Provides bridge modules to C header files for both POSIX and Windows platforms:

| C Header | C3 Module | Import Statement |
|----------|-----------|------------------|
| `stdio.h` | `stdio.h.c3` | `import stdio;` |
| `unistd.h` | `unistd.h.c3` | `import unistd;` |
| `netinet/in.h` | `netinet.in.h.c3` | `import netinet::in;` |
| `winsock2.h` | `winsock2.h.c3` | `import winsock2;` |
| ... | ... | ... |


Import your familiar C header files.

```c3
import stdio;
import string;
import errno; // provides errno(), get_fault()
import sys::time; // POSIX
import netinet::in; // POSIX
import unistd; // POSIX

import io; // Win32
import process; // Win32
import winsock2; // Win32
import ws2tcpip; // Win32

sidio::printf("Hello\n");

winsock2::WSAData wsa_data;
int result = winsock2::wsa_startup(0x0202, &wsa_data);

UdpSocket? sock = (UdpSocket)winsock2::socket(winsock2::AF_INET, winsock2::SOCK_DGRAM, winsock2::IPPROTO_UDP);
```

- More about [C Header bindings](ext/libc/README.md)

### Networking 

* [ext/net](ext/net)

High-level networking capabilities including TCP, UDP, and DNS:

| Module | Description |
|--------|-------------|
| `ext::io::tcp` | TCP operations: new(), new_listen(), listen(), connect(), accept(), send(), recv(), read(), write(), readline(), set_non_blocking(), close()|
| `ext::io::udp` | UDP operations: new(), new_bind(), bind(), send(), recv(), sendto(), recvfrom(), set_non_blocking(), close() |
| `ext::io::dns` | DNS operations: get_addrinfo() |


- More about [Networking APIs](ext/net/README.md)


### I/O Operations

* [ext/io](ext/io)

File system operations including stat, directory handling, and file utilities:

| Module | Description |
|--------|-------------|
| `ext::io::stat` | File stat operations: exists(), size(), is_(file/dir/link), is_(readable/writable/executable), read_link(), last_modified(), change_mode() |
| `ext::io::cfile` | File operations: open(), close(), read(), read_byte(), write(), write_byte(), printf(), seek(), tell(), eof(), load(), save(), copy(), rename(), remove(), exists(), size(), last_modified(), is_file(), is_dir(), change_mode() |
| `ext::io::dir` | Directory/folder operations: get_cur_dir(), change_dir(), make_dir(), remove_dir(), rename(), list_dir(), exists(), is_dir(), is_file(), change_mode() |

- More about [I/O Operations](ext/io/README.md)

### Hash Operations

* [ext/hash](ext/hash)

| Module | Description |
|--------|-------------|
| `ext::hash::murmur` | MurmurHash3 functions: hash3_x86_32(), hash3_x86_128(), hash3_x64_128() |
| `ext::hash::city` | CityHash functions: hash64(), hash64_with_seed(), hash128(), hash128_with_seed(), hash128_crc(), hash128_ rc_with_seed() |

- More about [Hash Operations](ext/hash/README.md)


### Regular Expressions

Regex support for C3 based on C regex library.

| Module | Description |
|--------|-------------|
| `ext::regex` | RegEx operations: new_compile(), match(), group(), free(), replace(), split(), reg_match(), reg_replace(), reg_split();|
| `slre` | SLRE operations: compile(), match(), reg_match(), reg_replace() |


* [ext/regex](ext/regex)
- More about [Regular Expressions](ext/regex/README.md)

### Fiber coroutine

It provides a lightweight cooperative multitasking system, allowing you to create and switch between multiple execution contexts (fibers) within a single thread.

Based on:
* X86_64, AARCH64: Assembly code, fast switching
* Windows: Native Fiber interface
* Other Posix: based on sigsetjmp() /siglongjmp()

| Module | Description |
|--------|-------------|
| `ext::thread::fiber` | Fiber operations: create(), delete(), active(), switch_to(), yield() |

* [ext/fiber](ext/fiber)
- More about [Fiber Coroutine](ext/fiber/README.md)

### Async I/O 

This is a C3 version of Python's `asyncio` library. It follows the python's API, because it is the easiest one among its kind.

It's based on C3's [fiber](../fiber/README.md) coroutine.

| Module | Description |
|--------|-------------|
| `ext::asyncio` | Python asyncio-similar operationsFuture, Task, EventLoop, Stream, Datagram, Transport, Protocol, DatagramProtocol |

* [ext/asyncio](ext/asyncio)
- More about [Asyncio for C3](ext/asyncio/README.md)


## Usage Example

```c3
import ext::net::udp;
import ext::io::stat;
import stdio;

fn int main()
{
    // Check if a configuration file exists
    if (stat::exists("config.ini"))
    {
        stdio::printf("Configuration found!\n");
    }
    
    // Create a UDP server
    UdpSock? server = udp::new_bind(8080);
    
    stdio::printf("UDP server listening on port 8080\n");
    
    return 0;
}
```

## Platform Support

- **POSIX** systems (Linux, macOS, BSD variants)
- **Windows** (Win32 API support)

Cross-platform compatibility is a primary goal, with platform-specific implementations abstracted behind unified APIs where possible.

## Contributing

Contributions are welcome! When submitting pull requests:

1. Ensure cross-platform compatibility
2. Update relevant README files in sub-libraries
3. Follow existing code style and conventions
4. Test on both POSIX and Windows platforms when applicable

## Repository

GitHub: [https://github.com/nomota/ext.c3l](https://github.com/nomota/ext.c3l)

## License

MIT License

---

For detailed documentation on specific modules, please refer to the README files in each subdirectory under `ext/`.
