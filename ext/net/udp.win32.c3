// udp.win32.c3 - Windows implementation with IPv4/IPv6 support

module ext::net::udp @if(env::WIN32);

import c::winsock2;
import c::ws2tcpip;
import c::errno;

import ext::net::wsa;

typedef UdpSocket = inline winsock2::Socket;

fn int detect_ip_version(String ip) 
{
    foreach (c : ip) {
        if (c == ':') return winsock2::AF_INET6;
    }
    return winsock2::AF_INET;
}

fn UdpSocket? new(int version = winsock2::AF_INET) 
{
    wsa::startup()!;
    
    int family = (int)version;
    UdpSocket sock = (UdpSocket)winsock2::socket(family, winsock2::SOCK_DGRAM, 
        family == winsock2::AF_INET6 ? winsock2::IPPROTO_IPV6 : winsock2::IPPROTO_UDP);
    
    if (sock == winsock2::INVALID_SOCKET) {
        return errno::get_fault()~;
    }
    return sock;
}

fn void? UdpSocket.bind(sock, ushort port, String opt_ip = "*") 
{
    int option = 1;
    winsock2::setsockopt(sock, winsock2::SOL_SOCKET, winsock2::SO_REUSEADDR, (char*)&option, $sizeof(option));

    int version = detect_ip_version(opt_ip);
    
    if (version == winsock2::AF_INET6) {
        winsock2::SockAddrIn6 adr;
        adr.sin6_family = winsock2::AF_INET6;
        
        if (opt_ip == "::") {
            // Bind to all IPv6 addresses
            winsock2::In6Addr any_addr;
            // Set to in6addr_any equivalent (all zeros)
            for (int i = 0; i < 16; i++) {
                any_addr.u.byte[i] = 0;
            }
            adr.sin6_addr = any_addr;
        } else if (ws2tcpip::inet_pton(winsock2::AF_INET6, opt_ip.ptr, &adr.sin6_addr) <= 0) {
            return errno::get_fault()~;
        }
        
        adr.sin6_port = winsock2::htons(port);

        if (winsock2::bind(sock, (winsock2::SockAddr*)&adr, $sizeof(adr)) == winsock2::SOCKET_ERROR) {
            return errno::get_fault()~;
        }
    } else {
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
    winsock2::SockAddrStorage adr;
    int size = $sizeof(adr);
    
    int len = winsock2::recvfrom(sock, msgbuf.ptr, (int)msgbuf.len, 0, (winsock2::SockAddr*)&adr, &size);
    if (len == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
    
    if (adr.ss_family == winsock2::AF_INET6) {
        winsock2::SockAddrIn6* adr6 = (winsock2::SockAddrIn6*)&adr;
        if (ws2tcpip::inet_ntop(winsock2::AF_INET6, &(adr6.sin6_addr), ip.ptr, (ulong)ip.len) == null) {
            return errno::get_fault()~;
        }
        *port = winsock2::ntohs(adr6.sin6_port);
    } else {
        winsock2::SockAddrIn* adr4 = (winsock2::SockAddrIn*)&adr;
        if (ws2tcpip::inet_ntop(winsock2::AF_INET, &(adr4.sin_addr), ip.ptr, (ulong)ip.len) == null) {
            return errno::get_fault()~;
        }
        *port = winsock2::ntohs(adr4.sin_port);
    }

    return (isz)len;
}

fn isz? UdpSocket.sendto(sock, char[] msgbuf, String ip, ushort port)
{
    int version = detect_ip_version(ip);
    
    if (version == winsock2::AF_INET6) {
        winsock2::SockAddrIn6 adr;
        adr.sin6_family = winsock2::AF_INET6;
        adr.sin6_port = winsock2::htons(port);
        
        if (ws2tcpip::inet_pton(winsock2::AF_INET6, ip.ptr, &adr.sin6_addr) <= 0) {
            return errno::get_fault()~;
        }
        
        int len = winsock2::sendto(sock, msgbuf.ptr, (int)msgbuf.len, 0, (winsock2::SockAddr*)&adr, $sizeof(adr));
        if (len == winsock2::SOCKET_ERROR) {
            return errno::get_fault()~;
        }
        return (isz)len;
    } else {
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

fn void? UdpSocket.set_non_blocking(sock) @maydiscard 
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
