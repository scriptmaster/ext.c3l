
# ext::net - High-Level Networking Library for C3

A networking library for the [C3 programming language](https://c3-lang.org/), providing simplified abstractions over raw socket APIs with comprehensive TCP and UDP, DNS lookup support.

## Available Modules

| Module | Description |
|--------|-------------|
| `ext::io::tcp` | TCP operations: new(), new_listen(), listen(), connect(), accept(), send(), recv(), read(), write(), readline(), set_non_blocking(), close()|
| `ext::io::udp` | UDP operations: new(), new_bind(), bind(), send(), recv(), sendto(), recvfrom(), set_non_blocking(), close() |
| `ext::io::dns` | DNS operations: get_addrinfo() |

### TCP Module (`ext::net::tcp`)

* [tcp.posix.c3](tcp.posix.c3)
* [tcp.win32.c3](tcp.win32.c3)

Available functions:

```c3
import ext::net::tcp;

TcpSocket? sock = tcp::new(int version = AF_INET);
int? r = sock.listen(ushort port, String opt_ip = "*", int backlog = 10); // sets reuse_addr, "::" for AF_INET6
TcpSocket? sock = tcp::new_listen(ushort port, String opt_ip = "*", int backlog = 10); // sets reuse_addr, "::" for AF_INET6

void? sock.connect(String ip, ushort port);
TcpSocket? client = tcp::new_connect(String ip, ushort port);
TcpSocket? sock = server.accept(char[] ip = &__null__, ushort* port = null);

isz? n = sock.send(char[] buf);
isz? n = sock.recv(char[] buf);
isz? n = sock.write(char[] buf);
isz? n = sock.read(char[] buf);
isz? n = sock.readline(char[] line);

void? sock.set_non_blocking() @maydiscard;

void? socket.close() @maydiscard;
```

### UDP Module (`ext::net::udp`)

* [udp.posix.c3](udp.posix.c3)
* [udp.win32.c3](udp.win32.c3)

Available functions:

```c3
import ext::net::udp;

UdpSocket? sock = udp::new(int version = AF_INET);
void? sock.bind(ushort port, String opt_ip = "*"); // sets reuse_addr, "::" for AF_INET6 // missing in std lib
UdpSocket? sock = udp::new_bind(ushort port, String ip = "*"); // sets reuse_addr, "::" for AF_INET6 // missing in std lib

isz? n = sock.recvfrom(char[] msgbuf, char[] ip, ushort* port); // missing in stdlib
isz? n = sock.sendto(char[] msgbuf, String ip, ushort port); // missing is std lib

isz? n = sock.send(char[] buf);
isz? n = sock.recv(char[] buf);

void? sock.set_non_blocking() @maydiscard;

void? sock.close() @maydiscard;
```

### DNS module (`ext::net::dns`)

* [dns.posix.c3](dns.posix.c3)
* [dns.win32.c3](dns.win32.c3)

Available functions:

```c3 
import ext::net::dns;
import std::collections::list;

List{String}? ips =  dns::get_addrinfo(Allocator allocx, String host); // should properly free() result

foreach (e: ips) { e.free(); }
ips.free();
```

### TCP Server Example

```c3
import std::io;

import ext::net::tcp; // from src/net
import stdio; // from src/libc

fn void main() 
{
    // Create and bind a TCP server on port 8080
    TcpSocket? server = tcp::new_listen(8080);
    if (catch err = server) {
        io::printfn("%s", err);
        return;
    }

    io::printfn("Server listening on port 8080...");
    
    while (true) {
        // Accept incoming connections
        char[16] client_ip;
        ushort client_port;
        TcpSocket? client = server.accept(&client_ip, &client_port);
        if (catch err = client) {
            io::printfn("%s", err);
            return;
        }
        
        stdio::printf("Client connected from %s:%d\n", &client_ip[0], client_port);
        
        // Receive data
        char[1024] buffer;
        isz? bytes_read = client.recv(&buffer);
        if (catch err = bytes_read) {
            io::printfn("%s", err);
            return;
        }
        
        io::printfn("Received: %s", buffer[:bytes_read]);
        
        // Send response
        (void)client.send("Hello from server!\n");
        client.close()!!;
    }
}

### TCP Client Example

```c3
import ext::net::tcp; // from src/net
import std::io;

fn void main() 
{
    // Connect to server
    TcpSocket? sock = tcp::new_connect("127.0.0.1", 8080);
    if (catch err = sock) {
        io::printfn("%s", err);
        return;
    }

    io::printfn("Connected to server");
    
    // Send data
    sock.send("Hello, server!\n")!!;
    
    // Receive response
    char[1024] buffer;
    isz bytes = sock.recv(&buffer)!!;
    io::printfn("Server response: %s", (String)buffer[:bytes]);
    
    sock.close()!!;
}
```

### UDP Server Example

```c3
import ext::net::udp; // from src/net
import std::io;

fn void main() 
{
    // Create and bind UDP socket
    UdpSocket? sock = udp::new_bind(9000);
    if (catch err = sock) {
        io::printfn("%s", err);
        return;
    }
    io::printfn("UDP server listening on port 9000...");
    
    char[1024] buffer;
    char[16] client_ip;
    ushort client_port;
    
    while (true) {
        // Receive datagram
        isz len = sock.recvfrom(&buffer, &client_ip, &client_port)!!;
        io::printfn("Received from %s:%d: %s", (ZString)&client_ip[0], client_port, (String)buffer[:len]);
        
        // Send response
        sock.sendto("Acknowledged\n", client_ip, client_port)!!;
    }
}
```

### UDP Client Example

```c3
import ext::net::udp; // from src/net
import std::io;

fn void main() 
{
    // Create UDP socket
    UdpSocket sock = udp::new()!!;
    
    // Send datagram
    sock.sendto("Hello, UDP server!\n", "127.0.0.1", 9000)!!;
    
    // Receive response
    char[1024] buffer;
    char[16] server_ip;
    ushort server_port;
    isz len = sock.recvfrom(&buffer, &server_ip, &server_port);
    io::printfn("Response: %s", (String)buffer[:len]);
    
    sock.close()!!;
}
```




## Error Handling

`ext_net` uses C3's optional return types for error handling. All functions that can fail return optional types (`?`).

### Example with Error Handling

```c3
import ext::net::tcp; // from src/net
import std::io;

fn void main() 
{
    TcpSocket? sock = tcp::new_listen(8080);
    
    if (catch err = sock) {
        io::printfn("Failed to create server: %s", err);
        return;
    }
    
    while (true) {
        TcpSocket? client = sock.accept();
        if (catch err = client) {
            io::printfn("Accept failed: %s", err);
            continue;
        }
        
        // Handle client...
        
        client.close()!!;
    }
}
```

## Advanced Features

### Non-Blocking I/O

```c3
import ext::net::tcp;

fn void main() 
{
    TcpSocket sock = tcp::new_connect("127.0.0.1", 8080)!!;
    sock.set_non_blocking()!!;
    
    // Now socket operations won't block
    // Handle EAGAIN/EWOULDBLOCK appropriately
}
```

### Reading Lines

Perfect for text-based protocols:

```c3
import ext::net::tcp;
import std::io;

fn void? handle_client(TcpSocket sock) 
{
    char[1024] line;
    
    while (true) {
        isz? len = sock.readline(&line);
        if (catch err = len) {
            if (err == tcp::EOF) break;  // Connection closed
            io::printfn("Read error: %s", err);
            break;
        }
        
        io::printfn("Received line: %s", (String)line[:len]);
        sock.send("OK\n")!;
    }
}
```

## Testing

The library includes comprehensive test examples in the `examples/` directory:

- `tcpserver.c3` - TCP echo server implementation
- `tcpclient.c3` - TCP client example
- `udpserver.c3` - UDP echo server implementation  
- `udpclient.c3` - UDP client example

Run the tests to verify installation and see usage examples:

```bash
# Terminal 1: Start TCP server
make tcpserver

# Terminal 2: Run TCP client
make tcpclient
```

