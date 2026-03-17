# libc - C Standard Header Bindings for C3

A comprehensive collection of C header bindings for the [C3 programming language](https://c3-lang.org/), providing cross-platform system programming capabilities.

## Overview

`libc` provides C3 modules that correspond to standard C headers, enabling seamless translation of C code to C3 and direct access to system-level functionality. This library bridges the gap between C3 and native system APIs across POSIX (Linux, BSD, macOS) and Windows platforms.

## Features

- **Cross-Platform Support**: Comprehensive bindings for both POSIX and Windows systems
- **Standard Library Coverage**: Networking, file I/O, threading, memory management, and more
- **File System Utilities**: High-level cross-platform file operations and metadata queries
- **Direct C Interop**: Faithful mappings of C APIs to C3 modules
- **Easy Integration**: Simple dependency management via C3's package system
- **Translation-Friendly**: Designed specifically to facilitate C-to-C3 code translation
- **Foundation for Higher-Level Libraries**: Serves as the base for networking and system utilities


## Usage

Import the modules you need in your C3 source files:

```c3
import stdio;
import unistd;
import sys::socket;
import errno;
```

Access functions and constants using the module namespace:

```c3
import stdio;

fn void main() 
{
    stdio::printf("Hello from ext_libc!\n");
}
```

### Windows-Specific Example

```c3
import winsock2;
import ws2tcpip;

fn void init_networking() 
{
    WSAData wsa_data;
    winsock2::wsa_startup(0x0202, &wsa_data);
}
```

### POSIX Example

```c3
import sys::socket;
import netinet::in;
import unistd;
import errno;

fn int? create_server_socket(ushort port) 
{
    int sockfd = socket::socket(socket::AF_INET, socket::SOCK_STREAM, 0);
    if (sockfd < 0) {
        return errno::get_fault()~;
    }
    // ... bind, listen, etc.
    return sockfd;
}
```

* Browse [libc](./) header files.

### Discrepencies

C3 has strong naming rules, which hinders away 1:1 direct conversion.
* Types (Structure names) should start with uppercase.
* variables and functions should start with lowercase.
* CONSTANTS should all be uppercase.

```c3
// C
// winsock2.h
struct WSADATA {

};

int WSAStartup(unsitned short version_required, struct WSADATA* wsa_data);

// C3
// winsock2.h.c3
struct WSAData {

}

extern fn int wsa_startup(ushort version_required, WSAData* wsa_data) @cname("WSAStartup");
```

## Available Modules

### POSIX/Unix Headers

| Module | Description |
|--------|-------------|
| `arpa::inet` | Internet address manipulation |
| `complex` | Complex number mathematics |
| `dirent` | Directory operations |
| `fcntl` | File control operations |
| `math` | Mathematical functions |
| `netdb` | Network database operations |
| `netinet::in` | Internet protocol family |
| `netinet::tcp` | TCP protocol definitions |
| `netinet::udp` | UDP protocol definitions |
| `poll` | I/O multiplexing |
| `pthread` | POSIX threads |
| `regex` | Regular expressions |
| `signal` | Signal handling |
| `spawn` | Process spawning |
| `stddef` | Standard type definitions |
| `stdio` | Standard input/output |
| `stdlib` | Standard library functions |
| `string` | String manipulation |
| `sys::mman` | Memory management |
| `sys::socket` | Socket interface |
| `sys::stat` | File status |
| `sys::time` | Time types |
| `sys::wait` | Process waiting |
| `time` | Time and date functions |
| `unistd` | POSIX operating system API |
| `errno` | provides `errno()` and `get_fault()` |

### Windows Headers

| Module | Description |
|--------|-------------|
| `errhandlingapi` | Error handling functions |
| `fileapi` | File management functions |
| `handleapi` | Handle management |
| `io` | Low-level I/O operations |
| `ioapiset` | I/O API functions (overlapped I/O, completion ports) |
| `memoryapi` | Memory management functions |
| `process` | Process control |
| `processthreadapi` | Process and thread functions |
| `synchapi` | Synchronization functions |
| `sysinfoapi` | System information functions |
| `windows` | Core Windows API |
| `winioctl` | Windows device I/O control codes and structures |
| `winsock2` | Windows Sockets 2 |
| `ws2tcpip` | Windows Sockets TCP/IP functions |
| `errno` | provides `errno()` and `get_fault()` |

This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

* Browse [libc](./) header files.

## Module Naming Convention

C header files are mapped to C3 modules using the following pattern:

- C header: `sys/socket.h` → C3 module: `sys.socket.h.c3` → Import as: `import sys::socket;`
- C header: `stdio.h` → C3 module: `stdio.h.c3` → Import as: `import stdio;`
- C header: `winsock2.h` → C3 module: `winsock2.h.c3` → Import as: `import winsock2;`

## Use Cases

- **C Code Translation**: Port existing C codebases to C3 with minimal API changes
- **System Programming**: Direct access to OS-level functionality
- **Network Programming**: Socket operations, protocol handling
- **File System Operations**: Cross-platform file metadata and permission queries
- **Cross-Platform Development**: Write portable system code targeting multiple platforms
- **Low-Level Libraries**: Build system-level C3 libraries and tools

This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.
