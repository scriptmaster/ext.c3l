
// udp.win32.c3 - Windows implementation

module ext::net @if(env::WIN32);

bool __wsa_initialized @if(! $defined(__wsa_initialized))
    = false;

module ext::net::udp @if(env::WIN32);

import winsock2;
import ws2tcpip;
import ext::net;
import errno;

typedef UdpSocket = inline winsock2::Socket;

fn void? __wsa_startup() 
{
    if (net::__wsa_initialized) return;
    
    winsock2::WSAData wsa_data;
    int result = winsock2::wsa_startup(0x0202, &wsa_data);
    if (result != 0) {
        return errno::get_fault()~;
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

fn UdpSocket? new() 
{
    __wsa_startup()!;
    UdpSocket sock = (UdpSocket)winsock2::socket(winsock2::AF_INET, winsock2::SOCK_DGRAM, winsock2::IPPROTO_UDP);
    
    if (sock == winsock2::INVALID_SOCKET) {
        return errno::get_fault()~;
    }
    return sock;
}

fn void? UdpSocket.bind(sock, ushort port, String opt_ip = "*") 
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
            return errno::get_fault()~;
        }
        adr.sin_addr = addr;
    }
    
    adr.sin_port = winsock2::htons(port);

    if (winsock2::bind(sock, (winsock2::SockAddr*)&adr, $sizeof(adr)) == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
    
    return;
}

fn UdpSocket? new_bind(ushort port, String ip = "*")
{
    UdpSocket sock = new()!;
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
    winsock2::SockAddrIn adr;
    int size = $sizeof(adr);
    
    int len = winsock2::recvfrom(sock, msgbuf.ptr, (int)msgbuf.len, 0, (winsock2::SockAddr*)&adr, &size);
    if (len == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
    
    if (ws2tcpip::inet_ntop(winsock2::AF_INET, &(adr.sin_addr), ip.ptr, (ulong)ip.len) == null) {
        return errno::get_fault()~;
    }
    
    *port = winsock2::ntohs(adr.sin_port);

    return (isz)len;
}

fn isz? UdpSocket.sendto(sock, char[] msgbuf, String ip, ushort port)
{
    winsock2::SockAddrIn adr;
    adr.sin_family = winsock2::AF_INET;
    adr.sin_port = winsock2::htons(port);

    winsock2::InAddr addr;
    if (ws2tcpip::inet_pton(winsock2::AF_INET, ip.ptr, &addr) <= 0) {
        return errno::get_fault()~;
    }
    adr.sin_addr = addr;
    
    int len = winsock2::sendto(sock, msgbuf.ptr, (int)msgbuf.len, 0, (winsock2::SockAddr*)&adr, $sizeof(adr));
    if (len == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
    return (isz)len;
}

fn isz? UdpSocket.send(sock, char[] buf) 
{
    int n = winsock2::send(sock, buf.ptr, (int)buf.len, 0);
    if (n == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
    return (isz)n;
}

fn isz? UdpSocket.recv(sock, char[] buf) 
{
    int n = winsock2::recv(sock, buf.ptr, (int)(buf.len-1), 0);
    if (n == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
    buf[n] = 0;
    return (isz)n;
}

fn void? UdpSocket.set_non_blocking(sock) 
{
    uint mode = 1; // non-blocking mode
    int r = winsock2::ioctlsocket(sock, winsock2::FIONBIO, &mode);
    if (r == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
}

fn void? UdpSocket.close(sock) @maydiscard
{
    int r = winsock2::closesocket(sock);
    if (r == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
}
