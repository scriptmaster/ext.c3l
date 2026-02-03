// udp.posix.c3

module ext::net::udp @if(!env::WIN32);

import string;
import netinet::in;
import sys::socket;
import unistd;
import fcntl;

typedef UdpSocket = inline int;

faultdef SOCKET_ERR, BIND_ERR, RECVFROM_ERR, SENDTO_ERR, NTOP_ERR, PTON_ERR, SEND_ERR, RECV_ERR, FCNTL_ERR, CLOSE_ERR;

fn UdpSocket? new() 
{
    UdpSocket sock = (UdpSocket)socket::socket(socket::PF_INET, socket::SOCK_DGRAM, 0);
    if (sock == -1) {
        return SOCKET_ERR~;
    }
    return sock;
}

fn void? UdpSocket.bind(sock, ushort port, String opt_ip = "*") 
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
    
    return;
}

fn UdpSocket? new_bind(ushort port, String ip = "*")
{
    UdpSocket? sock = new();
    if (catch err = sock) {
        return err~;
    }
    defer (catch err) {
        (void) sock.close();
    }
    if (catch err = sock.bind(port, ip)) {
        return err~;
    }
    return sock;
}

fn isz? UdpSocket.recvfrom(sock, char[] msgbuf, char[] ip, ushort* port)
{
    SockAddrIn adr;
    SockLen size = $sizeof(adr);
    
    isz len = socket::recvfrom(sock, msgbuf.ptr, msgbuf.len, 0, (SockAddr*)&adr, &size);
    if (len < 0) {
        return RECVFROM_ERR~;
    }
    
    if (in::inet_ntop(socket::AF_INET, &(adr.sin_addr), ip.ptr, ip.len) == null) {
        return NTOP_ERR~;
    }
    
    *port = in::ntohs(adr.sin_port);

    return len;
}

fn isz? UdpSocket.sendto(sock, char[] msgbuf, String ip, ushort port)
{
    SockAddrIn adr;
    //string::memset(&adr, 0, $sizeof(adr));
    adr.sin_family = socket::AF_INET;
    adr.sin_port = in::htons(port);

    if (in::inet_pton(socket::AF_INET, ip.ptr, &adr.sin_addr) == 0) {
        return PTON_ERR~;
    }
    
    isz len = socket::sendto(sock, msgbuf.ptr, msgbuf.len, 0, (SockAddr*)&adr, $sizeof(adr));
    if (len < 0) {
        return SENDTO_ERR~;
    }
    return len;
}

fn isz? UdpSocket.send(sock, char[] buf) 
{
    isz n = socket::send(sock, buf.ptr, buf.len, 0);
    if (n < 0) {
        return SEND_ERR~;
    }
    return n;
}

fn isz? UdpSocket.recv(sock, char[] buf) 
{
    isz n = socket::recv(sock, buf.ptr, buf.len-1, 0);
    if (n < 0) {
        return RECV_ERR~;
    }
    buf[n] = 0;
    return n;
}

fn void? UdpSocket.set_non_blocking(sock) 
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

fn void? UdpSocket.close(sock)
{
    int r = unistd::close(sock);
    if (r < 0) {
        return CLOSE_ERR~;
    }
}