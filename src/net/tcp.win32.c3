
// tcp.win32.c3 - Windows implementation

module ext::net @if(env::WIN32);

bool __wsa_initialized @if(! $defined(__wsa_initialized))
    = false;

module ext::net::tcp @if(env::WIN32);

import winsock2;
import ws2tcpip;
import ext::net;

typedef TcpSocket = inline winsock2::Socket;

faultdef SOCKET_ERR, BIND_ERR, LISTEN_ERR, ACCEPT_ERR, CONNECT_ERR, NTOP_ERR, PTON_ERR, SEND_ERR, RECV_ERR, FCNTL_ERR, CLOSE_ERR, READ_ERR, EOF, WSA_STARTUP_ERR;

fn void? __wsa_startup() 
{
    if (net::__wsa_initialized) return;
    
    winsock2::WSAData wsa_data;
    int result = winsock2::wsa_startup(0x0202, &wsa_data);
    if (result != 0) {
        return WSA_STARTUP_ERR~;
    }
    net::__wsa_initialized = true;
}

fn void __wsa_cleanup() 
{
    if (net::__wsa_initialized) {
        winsock2::wsa_cleanup();
        net::__wsa_initialized = false;
    }
}

fn TcpSocket? new() 
{
    __wsa_startup()!;
    TcpSocket sock = (TcpSocket)winsock2::socket(winsock2::AF_INET, winsock2::SOCK_STREAM, winsock2::IPPROTO_TCP);
    
    if (sock == winsock2::INVALID_SOCKET) {
        return SOCKET_ERR~;
    }
    return sock;
}

fn int? TcpSocket.listen(sock, ushort port, String opt_ip = "*", int backlog = 10) 
{
    int option = 1;
    winsock2::setsockopt(sock, winsock2::SOL_SOCKET, winsock2::SO_REUSEADDR, (char*)&option, $sizeof(option));
    
    winsock2::SockAddrIn adr;
    adr.sin_family = winsock2::AF_INET;
    if (opt_ip == "*") {
        adr.sin_addr.s_addr = winsock2::htonl(winsock2::INADDR_ANY);
    } else {
        winsock2::InAddr addr;
        if (ws2tcpip::inet_pton(winsock2::AF_INET, opt_ip.ptr, &addr) <= 0) {
            return PTON_ERR~;
        }
        adr.sin_addr = addr;
    }
    
    adr.sin_port = winsock2::htons(port);

    if (winsock2::bind(sock, (winsock2::SockAddr*)&adr, $sizeof(adr)) == winsock2::SOCKET_ERROR) {
        return BIND_ERR~;
    }
    
    int r = winsock2::listen(sock, backlog);
    if (r == winsock2::SOCKET_ERROR) {
        return LISTEN_ERR~;
    }
    
    return 0;
}

fn TcpSocket? new_listen(ushort port, String opt_ip = "*", int backlog = 10)
{
    TcpSocket? sock = new();
    if (catch err = sock) {
        return err~;
    }
    defer (catch err) {
        (void) sock.close();
    }
    if (catch err = sock.listen(port, opt_ip, backlog)) {
        return err~;
    }
    return sock;
}

char[1] __null__;
fn TcpSocket? TcpSocket.accept(sock, char[] ip = &__null__, ushort* port = null)
{
    winsock2::SockAddrIn adr;
    int size = $sizeof(adr);
    
    TcpSocket s = (TcpSocket)winsock2::accept(sock, (winsock2::SockAddr*)&adr, &size);
    if (s == winsock2::INVALID_SOCKET) {
        return ACCEPT_ERR~;
    }
    if (ip != &__null__ && port != null) {
        if (ws2tcpip::inet_ntop(winsock2::AF_INET, &(adr.sin_addr), ip.ptr, (ulong)ip.len) == null) {
            return NTOP_ERR~;
        }
        *port = winsock2::ntohs(adr.sin_port);
    }
    
    return s;
}

fn void? TcpSocket.connect(sock, String ip, ushort port)
{
    winsock2::SockAddrIn adr;
    adr.sin_family = winsock2::AF_INET;
    adr.sin_port = winsock2::htons(port);

    winsock2::InAddr addr;
    if (ws2tcpip::inet_pton(winsock2::AF_INET, ip.ptr, &addr) <= 0) {
        return PTON_ERR~;
    }
    adr.sin_addr = addr;
    
    int r = winsock2::connect(sock, (winsock2::SockAddr*)&adr, $sizeof(adr));
    if (r == winsock2::SOCKET_ERROR) {
        return CONNECT_ERR~;
    }
}

fn TcpSocket? new_connect(String ip, ushort port)
{
    TcpSocket? sock = new();
    if (catch err = sock) {
        return err~;
    }
    defer (catch err) {
        (void) sock.close();
    }
    if (catch err = sock.connect(ip, port)) {
        return err~;
    }
    return sock;
}

fn isz? TcpSocket.send(sock, char[] buf) 
{
    int n = winsock2::send(sock, buf.ptr, (int)buf.len, 0);
    if (n == winsock2::SOCKET_ERROR) {
        return SEND_ERR~;
    }
    return (isz)n;
}

macro isz? TcpSocket.write(sock, char[] buf) 
{
    return sock.send(buf);
}

fn isz? TcpSocket.recv(sock, char[] buf) 
{
    int n = winsock2::recv(sock, buf.ptr, (int)(buf.len-1), 0);
    if (n == winsock2::SOCKET_ERROR) {
        return RECV_ERR~;
    }
    buf[n] = 0;
    return (isz)n;
}

macro isz? TcpSocket.read(sock, char[] buf) 
{
    return sock.recv(buf);
}

fn isz? TcpSocket.readline(sock, char[] line)
{
    isz n = 0;
    while (true) {
        char c;
        int r = winsock2::recv(sock, &c, 1, 0);
        if (r == winsock2::SOCKET_ERROR) {
            return READ_ERR~;
        }
        if (r == 0) break;

        line[n] = c;
        n++;
        if (n == line.len-1) break;
        if (c == '\n') break;
    }
    if (n == 0) {
        return EOF~;
    }
    line[n] = '\0';
    return n;
}

fn void? TcpSocket.set_non_blocking(sock) 
{
    uint mode = 1; // non-blocking mode
    int r = winsock2::ioctlsocket(sock, winsock2::FIONBIO, &mode);
    if (r == winsock2::SOCKET_ERROR) {
        return FCNTL_ERR~;
    }
}

fn void? TcpSocket.close(sock)
{
    int r = winsock2::closesocket(sock);
    if (r == winsock2::SOCKET_ERROR) {
        return CLOSE_ERR~;
    }
}
