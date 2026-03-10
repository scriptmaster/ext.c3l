// udp.posix.c3 - IPv4/IPv6 Support

module ext::net::udp @if(!env::WIN32);

import string;
import netinet::in;
import sys::socket;
import unistd;
import fcntl;
import errno;

typedef UdpSocket = inline int;

fn int detect_ip_version(String ip) 
{
    foreach (c : ip) {
        if (c == ':') return socket::AF_INET6;
    }
    return socket::AF_INET;
}

fn UdpSocket? new(int version = socket::AF_INET) 
{
    int family = (int)version;
    UdpSocket sock = (UdpSocket)socket::socket(family, socket::SOCK_DGRAM, 0);
    if (sock == -1) {
        return errno::get_fault()~;
    }
    return sock;
}

fn void? UdpSocket.bind(sock, ushort port, String opt_ip = "*") 
{
    int option = 1; // true
    int optlen = $sizeof(option);
    socket::setsockopt(sock, socket::SOL_SOCKET, socket::SO_REUSEADDR, (void*)&option, optlen);

    int version = detect_ip_version(opt_ip);
    
    if (version == socket::AF_INET6) {
        SockAddrIn6 adr;
        string::memset(&adr, 0, $sizeof(adr));
        adr.sin6_family = socket::AF_INET6;
        
        if (opt_ip == "::") {
            adr.sin6_addr = {}; // in::in6addr_any;
            string::memset(&adr.sin6_addr, 0, In6Addr.sizeof);

        } else if (in::inet_pton(socket::AF_INET6, opt_ip.ptr, &adr.sin6_addr) != 1) {
            return errno::get_fault()~;
        }
        
        adr.sin6_port = in::htons(port);

        if (socket::bind(sock, (SockAddr*)&adr, $sizeof(adr)) == -1) {
            return errno::get_fault()~;
        }
    } else {
        SockAddrIn adr;
        string::memset(&adr, 0, $sizeof(adr));
        adr.sin_family = socket::AF_INET;
        
        if (opt_ip == "*") {
            adr.sin_addr.s_addr = in::htonl(in::INADDR_ANY);
        } else if (in::inet_pton(socket::AF_INET, opt_ip.ptr, &adr.sin_addr) != 1) {
            return errno::get_fault()~;
        }
        
        adr.sin_port = in::htons(port);

        if (socket::bind(sock, (SockAddr*)&adr, $sizeof(adr)) == -1) {
            return errno::get_fault()~;
        }
    }
    
    return;
}

fn UdpSocket? new_bind(ushort port, String ip = "*")
{
    int version = detect_ip_version(ip);
    UdpSocket sock = new(version)!;
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
    socket::SockAddrStorage adr;
    socket::SockLen size = $sizeof(adr);
    
    isz len = socket::recvfrom(sock, msgbuf.ptr, msgbuf.len, 0, (socket::SockAddr*)&adr, &size);
    if (len < 0) {
        return errno::get_fault()~;
    }
    
    if (adr.ss_family == socket::AF_INET6) {
        in::SockAddrIn6* adr6 = (in::SockAddrIn6*)&adr;
        if (in::inet_ntop(socket::AF_INET6, &(adr6.sin6_addr), ip.ptr, ip.len) == null) {
            return errno::get_fault()~;
        }
        *port = in::ntohs(adr6.sin6_port);
    } else {
        in::SockAddrIn* adr4 = (in::SockAddrIn*)&adr;
        if (in::inet_ntop(socket::AF_INET, &(adr4.sin_addr), ip.ptr, ip.len) == null) {
            return errno::get_fault()~;
        }
        *port = in::ntohs(adr4.sin_port);
    }

    return len;
}

fn isz? UdpSocket.sendto(sock, char[] msgbuf, String ip, ushort port)
{
    int version = detect_ip_version(ip);
    
    if (version == socket::AF_INET6) {
        in::SockAddrIn6 adr;
        string::memset(&adr, 0, $sizeof(adr));
        adr.sin6_family = socket::AF_INET6;
        adr.sin6_port = in::htons(port);

        if (in::inet_pton(socket::AF_INET6, ip.ptr, &adr.sin6_addr) != 1) {
            return errno::get_fault()~;
        }
        
        isz len = socket::sendto(sock, msgbuf.ptr, msgbuf.len, 0, (SockAddr*)&adr, $sizeof(adr));
        if (len < 0) {
            return errno::get_fault()~;
        }
        return len;
    } else {
        in::SockAddrIn adr;
        string::memset(&adr, 0, $sizeof(adr));
        adr.sin_family = socket::AF_INET;
        adr.sin_port = in::htons(port);

        if (in::inet_pton(socket::AF_INET, ip.ptr, &adr.sin_addr) != 1) {
            return errno::get_fault()~;
        }
        
        isz len = socket::sendto(sock, msgbuf.ptr, msgbuf.len, 0, (socket::SockAddr*)&adr, $sizeof(adr));
        if (len < 0) {
            return errno::get_fault()~;
        }
        return len;
    }
}

fn isz? UdpSocket.send(sock, char[] buf) 
{
    isz n = socket::send(sock, buf.ptr, buf.len, 0);
    if (n < 0) {
        return errno::get_fault()~;
    }
    return n;
}

fn isz? UdpSocket.recv(sock, char[] buf) 
{
    isz n = socket::recv(sock, buf.ptr, buf.len-1, 0);
    if (n < 0) {
        return errno::get_fault()~;
    }
    buf[n] = 0;
    return n;
}

fn void? UdpSocket.set_non_blocking(sock) @maydiscard 
{
    int flags = fcntl::fcntl(sock, fcntl::F_GETFL, 0);
    if (flags < 0) {
        return errno::get_fault()~;
    }
    int r = fcntl::fcntl(sock, fcntl::F_SETFL, flags | fcntl::O_NONBLOCK);
    if (r < 0) {
        return errno::get_fault()~;
    }
}

fn void? UdpSocket.close(sock) @maydiscard
{
    int r = unistd::close(sock);
    if (r < 0) {
        return errno::get_fault()~;
    }
}
