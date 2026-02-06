// dns.win32.c3

module ext::net @if(env::WIN32);

bool __wsa_initialized @if(! $defined(__wsa_initialized))
    = false;

module ext::net::dns @if(env::WIN32);

import stdio;
import stdlib;
import string;
import errno;
import win32::winsock2;
import win32::ws2tcpip;
import std::collections::list;

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


List{String}? get_addrinfo(Allocator allocx, String host)
{
    __wsa_startup()!;

    char[128] hostname;
    usz copy_len = host.len < 127 ? host.len : 127;
    string::strncpy(&hostname[0], host.ptr, copy_len);
    hostname[copy_len] = 0;
    
    winsock2::AddrinfoA hints = {};
    hints.ai_family = winsock2::AF_UNSPEC; // Both IPv4, IPv6
    hints.ai_socktype = winsock2::SOCK_STREAM; // TCP

    // DNS Lookup
    winsock2::AddrInfo* result;
    int r = ws2tcpip::getaddrinfo(&hostname[0], null, &hints, &result);
    if (r != 0) {
        return errno::get_fault()~;
    }

    List{String} ips;
    ips.init(allocx);
    
    for (winsock2::AddrInfo* rp = result; rp != null; rp = rp.ai_next) {
        void* addr;

        if (rp.ai_family == winsock2::AF_INET) {
            // IPv4
            winsock2::SockaddrIn* ipv4 = (winsock2::SockaddrIn*)rp.ai_addr;
            addr = &(ipv4.sin_addr);
        } else if (rp.ai_family == winsock2::AF_INET6) {
            // IPv6
            winsock2::SockaddrIn6* ipv6 = (winsock2::SockaddrIn6*)rp.ai_addr;
            addr = &(ipv6.sin6_addr);
        } else {
            continue;
        }

        char[winsock2::INET6_ADDRSTRLEN] ipstr;
        char* p = ws2tcpip::inet_ntop(rp.ai_family, addr, &ipstr[0], ipstr.len);
        if (p == null) continue;
        
        ips.push(((Zstring)&ipstr[0]).str_view().copy(mem));
    }

    ws2tcpip::freeaddrinfo(result);
    return ips;
}