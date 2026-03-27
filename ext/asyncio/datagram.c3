// datagram.c3

module ext::asyncio;

import std::io;
import c::stdlib; // libc
import c::string; // libc
import ext::debug;
import ext::mem;

struct Datagram {
    int fd;
    bool closed;
    fault error;
}

fn Datagram* datagram_new(int fd) // called at loop.open_datagram(ip, port)
{
    Datagram* d = mem_alloc(Datagram);
    *d = {
        .fd = fd,
        .closed = false,
        .error = NONE,
    };
    
    set_nonblocking(fd);
    
    return d;
}

fn void Datagram._free(&self) 
{
    mem_free(self);
}

fn usz Datagram.sendto(&self, char[] data, char[] ip, short port)
{
    char[128] ipaddr;
    string::memcpy(&ipaddr, ip.ptr, ip.len);
    ipaddr[ip.len] = 0;
    usz? n = async_sendto(self.fd, data.ptr, data.len, &ipaddr[0], port);
    if (catch err = n) {
        self.error = err;
        return 0;
    }
    return n;
}

fn usz Datagram.recvfrom(&self, char[] data, char[] ip, usz* ip_len, ushort* port)
{
    usz? n = async_recvfrom(self.fd, data.ptr, data.len, ip.ptr, ip_len, port);
    if (catch err = n) {
        self.error = err;
        return 0;
    }
    return n;
}

fn usz EventLoop.sock_sendto(&self, int sock_fd, char[] data, char[] ip, short port)
{
    char[128] ipaddr;
    string::memcpy(&ipaddr, ip.ptr, ip.len);
    ipaddr[ip.len] = 0;
    usz? n = async_sendto(sock_fd, data.ptr, data.len, &ipaddr[0], port);
    if (catch err = n) {
        return 0;
    }
    return n;
}

fn usz EventLoop.sock_recvfrom(&self, int sock_fd, char[] data, char[] ip, usz* ip_len, ushort* port)
{
    usz? n = async_recvfrom(sock_fd, data.ptr, data.len, ip.ptr, ip_len, port);
    if (catch err = n) {
        return 0;
    }
    return n;
}


module ext::asyncio @if(!env::WIN32);

import c::string; // libc
import c::fcntl; // libc
import c::unistd; // libc

fn void Datagram.close(&self) 
{
    if (self.closed) return;
    self.closed = true;

    unregister(self.fd);
    unistd::close(self.fd);
    self._free();
}

module ext::asyncio @if(env::WIN32);

import c::winbase; // libc
import c::winsock2; // libc

fn void Datagram.close(&self) 
{
    if (self.closed) return;
    self.closed = true;

    unregister(self.fd);

    if (_is_socket((winbase::Handle)(iptr)self.fd)) {
        winsock2::closesocket((winsock2::Socket)self.fd);
    } else {
        winbase::closeHandle((winbase::Handle)(iptr)self.fd);
    }
    self._free();
}
