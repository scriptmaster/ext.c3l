
// tcp.win32.c3 - Windows implementation with IPv4/IPv6 support

module ext::net::tcp @if(env::WIN32);

import winsock2;
import ws2tcpip;
import ext::net::wsa;
import errno;

typedef TcpSocket = inline winsock2::Socket;

fn int detect_ip_version(String ip) 
{
    foreach (c : ip) {
        if (c == ':') return winsock2::AF_INET6;
    }
    return winsock2::AF_INET;
}

fn TcpSocket? new(int version = winsock2::AF_INET) 
{
    wsa::startup()!;
    
    int family = (int)version;
    TcpSocket sock = (TcpSocket)winsock2::socket(family, winsock2::SOCK_STREAM, 
        family == winsock2::AF_INET6 ? winsock2::IPPROTO_IPV6 : winsock2::IPPROTO_TCP);
    
    if (sock == winsock2::INVALID_SOCKET) {
        return errno::get_fault()~;
    }
    return sock;
}

fn int? TcpSocket.listen(sock, ushort port, String opt_ip = "*", int backlog = 10) 
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
    
    int r = winsock2::listen(sock, backlog);
    if (r == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
    
    return 0;
}

fn TcpSocket? new_listen(ushort port, String opt_ip = "*", int backlog = 10)
{
    int version = detect_ip_version(opt_ip);
    TcpSocket sock = new(version)!;
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
    winsock2::SockAddrStorage adr;
    int size = $sizeof(adr);
    
    TcpSocket s = (TcpSocket)winsock2::accept(sock, (winsock2::SockAddr*)&adr, &size);
    if (s == winsock2::INVALID_SOCKET) {
        return errno::get_fault()~;
    }
    
    if (ip != &__null__ && port != null) {
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
    }
    
    return s;
}

fn void? TcpSocket.connect(sock, String ip, ushort port)
{
    int version = detect_ip_version(ip);
    
    if (version == winsock2::AF_INET6) {
        winsock2::SockAddrIn6 adr;
        adr.sin6_family = winsock2::AF_INET6;
        adr.sin6_port = winsock2::htons(port);
        
        if (ws2tcpip::inet_pton(winsock2::AF_INET6, ip.ptr, &adr.sin6_addr) <= 0) {
            return errno::get_fault()~;
        }
        
        int r = winsock2::connect(sock, (winsock2::SockAddr*)&adr, $sizeof(adr));
        if (r == winsock2::SOCKET_ERROR) {
            return errno::get_fault()~;
        }
    } else {
        winsock2::SockAddrIn adr;
        adr.sin_family = winsock2::AF_INET;
        adr.sin_port = winsock2::htons(port);

        winsock2::InAddr addr;
        if (ws2tcpip::inet_pton(winsock2::AF_INET, ip.ptr, &addr) <= 0) {
            return errno::get_fault()~;
        }
        adr.sin_addr = addr;
        
        int r = winsock2::connect(sock, (winsock2::SockAddr*)&adr, $sizeof(adr));
        if (r == winsock2::SOCKET_ERROR) {
            return errno::get_fault()~;
        }
    }
}

fn TcpSocket? new_connect(String ip, ushort port)
{
    int version = detect_ip_version(ip);
    TcpSocket sock = new(version)!;
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
        return errno::get_fault()~;
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
        return errno::get_fault()~;
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
            return errno::get_fault()~;
        }
        if (r == 0) break;

        line[n] = c;
        n++;
        if (n == line.len-1) break;
        if (c == '\n') break;
    }
    if (n == 0) {
        return errno::EOF~;
    }
    line[n] = '\0';
    return n;
}

fn void? TcpSocket.set_non_blocking(sock) @maydiscard 
{
    uint mode = 1; // non-blocking mode
    int r = winsock2::ioctlsocket(sock, winsock2::FIONBIO, &mode);
    if (r == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
}

fn void? TcpSocket.close(sock) @maydiscard
{
    int r = winsock2::closesocket(sock);
    if (r == winsock2::SOCKET_ERROR) {
        return errno::get_fault()~;
    }
}
