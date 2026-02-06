
# ext::net - High-Level Networking Library for C3

A modern, ergonomic networking library for the [C3 programming language](https://c3-lang.org/), providing simplified abstractions over raw socket APIs with comprehensive TCP and UDP, DNS lookup support.

## Overview

`ext::net` provides high-level networking capabilities, offering an intuitive API for common networking patterns while maintaining the performance and control of system-level programming.


## API Reference

### TCP Module (`ext::net::tcp`)

```c3
import ext::net::tcp;

typedef TcpSocket = inline int;

faultdef SOCKET_ERR, BIND_ERR, LISTEN_ERR, ACCEPT_ERR, CONNECT_ERR, 
         NTOP_ERR, PTON_ERR, SEND_ERR, RECV_ERR, FCNTL_ERR, 
         CLOSE_ERR, READ_ERR, EOF;

TcpSocket? sock = tcp::new();
int? r = server.listen(ushort port, String opt_ip = "*", int backlog = 10); // sets reuse_addr
TcpSocket? server = tcp::new_listen(ushort port, String opt_ip = "*", int backlog = 10); // sets reuse_addr

void? sock.connect(String ip, ushort port);
TcpSocket? client = tcp::new_connect(String ip, ushort port);
TcpSocket? sock = server.accept(char[] ip = &__null__, ushort* port = null);

isz? n = sock.send(char[] buf);
isz? n = sock.recv(char[] buf);
isz? n = sock.write(char[] buf);
isz? n = socket.read(char[] buf);
isz? n = sock.readline(char[] line);

void? sock.set_non_blocking();

void? socket.close();
```

### UDP Module (`ext::net::udp`)

```c3
import ext::net::udp;

typedef UdpSocket = inline int;

faultdef SOCKET_ERR, BIND_ERR, RECVFROM_ERR, SENDTO_ERR, 
         NTOP_ERR, PTON_ERR, SEND_ERR, RECV_ERR, 
         FCNTL_ERR, CLOSE_ERR;

UdpSocket? sock = udp::new();
void? sock.bind(ushort port, String opt_ip = "*"); // missing in std lib
UdpSocket? server = udp::new_bind(ushort port, String ip = "*"); // missing in std lib

isz? n = sock.recvfrom(char[] msgbuf, char[] ip, ushort* port); // missing in stdlib
isz? n = sock.sendto(char[] msgbuf, String ip, ushort port); // missing is std lib

isz? n = sock.send(char[] buf);
isz? n = sock.recv(char[] buf);

void? sock.set_non_blocking();

void? sock.close();
```

### DNS module (`ext::net::dns`)

```c3 
import ext::net::dns;
import std::collections::list;

List{String}? ips =  dns::get_addrinfo(Allocator mem, String host);
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

