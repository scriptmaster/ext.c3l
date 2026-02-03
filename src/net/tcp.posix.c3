// tcp.c3

module ext::net::tcp @if(!env::WIN32);

import string;
import netinet::in;
import sys::socket;
import unistd;
import fcntl;

typedef TcpSocket = inline int;

faultdef SOCKET_ERR, BIND_ERR, LISTEN_ERR, ACCEPT_ERR, CONNECT_ERR, NTOP_ERR, PTON_ERR, SEND_ERR, RECV_ERR, FCNTL_ERR, CLOSE_ERR, READ_ERR, EOF;

fn TcpSocket? new() 
{
    TcpSocket sock = (TcpSocket)socket::socket(socket::PF_INET, socket::SOCK_STREAM, 0);
    if (sock == -1) {
        return SOCKET_ERR~;
    }
    return sock;
}

fn int? TcpSocket.listen(sock, ushort port, String opt_ip = "*", int backlog = 10) 
{
    int option = 1; // true
    int optlen = $sizeof(option);
    socket::setsockopt(sock, socket::SOL_SOCKET, socket::SO_REUSEADDR, (void*)&option, optlen);

    SockAddrIn adr;
    //string::memset(&adr, 0, $sizeof(adr));
    adr.sin_family = socket::AF_INET;
    if (opt_ip == "*") {
        adr.sin_addr.s_addr = in::htonl(in::INADDR_ANY);
    } else if (in::inet_pton(socket::AF_INET, opt_ip.ptr, &adr.sin_addr) == 0) {
        return PTON_ERR~;
    }
    
    adr.sin_port = in::htons(port);

    if (socket::bind(sock, (SockAddr*)&adr, $sizeof(adr)) == -1) {
        return BIND_ERR~;
    }
    
    int r = socket::listen(sock, backlog);
    if (r < 0) {
        return LISTEN_ERR~;
    }
    return r;
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
    SockAddrIn adr;
    SockLen size = $sizeof(adr);
    
    TcpSocket s = (TcpSocket)socket::accept(sock, (SockAddr*)&adr, &size);
    if (s < 0) {
        return ACCEPT_ERR~;
    }
    if (ip != &__null__ && port != null) {
        if (in::inet_ntop(socket::AF_INET, &(adr.sin_addr), ip.ptr, ip.len) == null) {
            return NTOP_ERR~;
        }
        *port = in::ntohs(adr.sin_port);
    }
    
    return s;
}

fn void? TcpSocket.connect(sock, String ip, ushort port)
{
    SockAddrIn adr;
    //string::memset(&adr, 0, $sizeof(adr));
    adr.sin_family = socket::AF_INET;
    adr.sin_port = in::htons(port);

    if (in::inet_pton(socket::AF_INET, ip.ptr, &adr.sin_addr) == 0) {
        return PTON_ERR~;
    }
    
    int r = socket::connect(sock, (SockAddr*)&adr, $sizeof(adr));
    if (r < 0) {
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
    isz n = socket::send(sock, buf.ptr, buf.len, 0);
    if (n < 0) {
        return SEND_ERR~;
    }
    return n;
}

macro isz? TcpSocket.write(sock, char[] buf) 
{
    return sock.send(buf);
}

fn isz? TcpSocket.recv(sock, char[] buf) 
{
    isz n = socket::recv(sock, buf.ptr, buf.len-1, 0);
    if (n < 0) {
        return RECV_ERR~;
    }
    buf[n] = 0;
    return n;
}

macro isz? TcpSocket.read(sock, char[] buf) 
{
    return sock.read(buf);
}


fn isz? TcpSocket.readline(sock, char[] line)
{
    isz n = 0;
    while (true) {
        char c;
        isz r = socket::recv(sock, &c, 1, 0);
        if (r < 0) {
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
    int flags = fcntl::fcntl(sock, fcntl::F_GETFL, 0);
    if (flags < 0) {
        return FCNTL_ERR~;
    }
    int r = fcntl::fcntl(sock, fcntl::F_SETFL, flags | fcntl::O_NONBLOCK);
    if (r < 0) {
        return FCNTL_ERR~;
    }
}

fn void? TcpSocket.close(sock)
{
    int r = unistd::close(sock);
    if (r < 0) {
        return CLOSE_ERR~;
    }
}
