// tcp.c3 - IPv4/IPv6 Support

module ext::net::tcp @if(!env::WIN32);

import string;
import netinet::in;
import sys::socket;
import unistd;
import fcntl;
import errno;

typedef TcpSocket = inline int;

fn int detect_ip_version(String ip) 
{
    foreach (c : ip) {
        if (c == ':') return socket::AF_INET6;
    }
    return socket::AF_INET;
}

fn TcpSocket? new(int version = socket::AF_INET) 
{
    int family = (int)version;
    TcpSocket sock = (TcpSocket)socket::socket(family, socket::SOCK_STREAM, 0);
    if (sock == -1) {
        return errno::get_fault()~;
    }
    return sock;
}

fn int? TcpSocket.listen(sock, ushort port, String opt_ip = "*", int backlog = 10) 
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
            // adr.sin6_addr = in::in6addr_any;
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
    
    int r = socket::listen(sock, backlog);
    if (r < 0) {
        return errno::get_fault()~;
    }
    return r;
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
    SockAddrStorage adr;
    SockLen size = $sizeof(adr);
    
    TcpSocket s = (TcpSocket)socket::accept(sock, (SockAddr*)&adr, &size);
    if (s < 0) {
        return errno::get_fault()~;
    }
    
    if (ip != &__null__ && port != null) {
        if (adr.ss_family == socket::AF_INET6) {
            SockAddrIn6* adr6 = (SockAddrIn6*)&adr;
            if (in::inet_ntop(socket::AF_INET6, &(adr6.sin6_addr), ip.ptr, ip.len) == null) {
                return errno::get_fault()~;
            }
            *port = in::ntohs(adr6.sin6_port);
        } else {
            SockAddrIn* adr4 = (SockAddrIn*)&adr;
            if (in::inet_ntop(socket::AF_INET, &(adr4.sin_addr), ip.ptr, ip.len) == null) {
                return errno::get_fault()~;
            }
            *port = in::ntohs(adr4.sin_port);
        }
    }
    
    return s;
}

fn void? TcpSocket.connect(sock, String ip, ushort port)
{
    int version = detect_ip_version(ip);
    
    if (version == socket::AF_INET6) {
        SockAddrIn6 adr;
        string::memset(&adr, 0, $sizeof(adr));
        adr.sin6_family = socket::AF_INET6;
        adr.sin6_port = in::htons(port);
        
        if (in::inet_pton(socket::AF_INET6, ip.ptr, &adr.sin6_addr) != 1) {
            return errno::get_fault()~;
        }
        
        int r = socket::connect(sock, (SockAddr*)&adr, $sizeof(adr));
        if (r < 0) {
            return errno::get_fault()~;
        }
    } else {
        SockAddrIn adr;
        string::memset(&adr, 0, $sizeof(adr));
        adr.sin_family = socket::AF_INET;
        adr.sin_port = in::htons(port);
        
        if (in::inet_pton(socket::AF_INET, ip.ptr, &adr.sin_addr) != 1) {
            return errno::get_fault()~;
        }
        
        int r = socket::connect(sock, (SockAddr*)&adr, $sizeof(adr));
        if (r < 0) {
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
    isz n = socket::send(sock, buf.ptr, buf.len, 0);
    if (n < 0) {
        return errno::get_fault()~;
    }
    return n;
}

macro isz? TcpSocket.write(sock, char[] buf) 
{
    return sock.send(buf)!;
}

fn isz? TcpSocket.recv(sock, char[] buf) 
{
    isz n = socket::recv(sock, buf.ptr, buf.len-1, 0);
    if (n < 0) {
        return errno::get_fault()~;
    }
    buf[n] = 0;
    return n;
}

macro isz? TcpSocket.read(sock, char[] buf) 
{
    return sock.recv(buf)!;
}


fn isz? TcpSocket.readline(sock, char[] line)
{
    isz n = 0;
    while (true) {
        char c;
        isz r = socket::recv(sock, &c, 1, 0);
        if (r < 0) {
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
    int flags = fcntl::fcntl(sock, fcntl::F_GETFL, 0);
    if (flags < 0) {
        return errno::get_fault()~;
    }
    int r = fcntl::fcntl(sock, fcntl::F_SETFL, flags | fcntl::O_NONBLOCK);
    if (r < 0) {
        return errno::get_fault()~;
    }
}

fn void? TcpSocket.close(sock) @maydiscard
{
    int r = unistd::close(sock);
    if (r < 0) {
        return errno::get_fault()~;
    }
}
