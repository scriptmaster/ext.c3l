
# ext::net - High-Level Networking Library for C3

A modern, ergonomic networking library for the [C3 programming language](https://c3-lang.org/), providing simplified abstractions over raw socket APIs with comprehensive TCP and UDP support.

## Overview

`ext::net` provides high-level networking capabilities, offering an intuitive API for common networking patterns while maintaining the performance and control of system-level programming.

## Features

- **TCP Socket Support**: Full-featured TCP client/server operations
- **UDP Socket Support**: Datagram-based communication
- **Idiomatic C3**: Leverages C3's optional returns and error handling
- **Non-Blocking I/O**: Support for asynchronous operations
- **Type-Safe**: Strong typing with inline type aliases
- **Easy to Use**: Simple API for common networking tasks


## Quick Start

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

## API Reference

### TCP Module (`ext::net::tcp`)

#### Types

```c3
typedef TcpSocket = inline int;
```

#### Error Faults

```c3
faultdef SOCKET_ERR, BIND_ERR, LISTEN_ERR, ACCEPT_ERR, CONNECT_ERR, 
         NTOP_ERR, PTON_ERR, SEND_ERR, RECV_ERR, FCNTL_ERR, 
         CLOSE_ERR, READ_ERR, EOF;
```

#### Functions

**Socket Creation**

```c3
TcpSocket? sock = tcp::new();
```
Creates a new TCP socket.

```c3
TcpSocket? server = tcp::new_listen(ushort port, String opt_ip = "*", int backlog = 10);
```
Creates a TCP socket, binds it to the specified port, and starts listening. Returns a ready-to-use server socket.

```c3
TcpSocket? client = tcp::new_connect(String ip, ushort port);
```
Creates a TCP socket and connects to the specified address. Returns a connected client socket.

**Server Operations**

```c3
int? r = server.listen(ushort port, String opt_ip = "*", int backlog = 10);
```
Binds the socket to an address and starts listening for connections.

```c3
TcpSocket? sock = server.accept(char[] ip = &__null__, ushort* port = null);
```
Accepts an incoming connection. Optionally retrieves the client's IP address and port.

**Client Operations**

```c3
void? sock.connect(String ip, ushort port);
```
Connects the socket to a remote address.

**Data Transfer**

```c3
isz? n = sock.send(char[] buf);
```
Sends data through the socket. Returns the number of bytes sent.

```c3
isz? n = sock.recv(char[] buf);
```
Receives data from the socket. Returns the number of bytes received.

```c3
isz? n = sock.write(char[] buf);
```
Alias for `send()`.

```c3
isz? n = socket.read(char[] buf);
```
Alias for `recv()`.

```c3
isz? n = sock.readline(char[] line);
```
Reads a line from the socket (up to `\n` or buffer size). Returns `EOF` fault when connection closes.

**Socket Configuration**

```c3
void? sock.set_non_blocking();
```
Sets the socket to non-blocking mode.

```c3
void? socket.close();
```
Closes the socket.

### UDP Module (`ext::net::udp`)

#### Types

```c3
typedef UdpSocket = inline int;
```

#### Error Faults

```c3
faultdef SOCKET_ERR, BIND_ERR, RECVFROM_ERR, SENDTO_ERR, 
         NTOP_ERR, PTON_ERR, SEND_ERR, RECV_ERR, 
         FCNTL_ERR, CLOSE_ERR;
```

#### Functions

**Socket Creation**

```c3
UdpSocket? sock = udp::new();
```
Creates a new UDP socket.

```c3
UdpSocket? server = udp::new_bind(ushort port, String ip = "*");
```
Creates a UDP socket and binds it to the specified port. Returns a ready-to-use socket.

**Binding**

```c3
void? sock.bind(ushort port, String opt_ip = "*");
```
Binds the socket to an address.

**Data Transfer**

```c3
isz? n = sock.recvfrom(char[] msgbuf, char[] ip, ushort* port);
```
Receives a datagram and retrieves the sender's address.

```c3
isz? n = sock.sendto(char[] msgbuf, String ip, ushort port);
```
Sends a datagram to the specified address.

```c3
isz? n = sock.send(char[] buf);
```
Sends data through a connected UDP socket.

```c3
isz? n = sock.recv(char[] buf);
```
Receives data from a connected UDP socket.

**Socket Configuration**

```c3
void? sock.set_non_blocking();
```
Sets the socket to non-blocking mode.

```c3
void? sock.close();
```
Closes the socket.

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

