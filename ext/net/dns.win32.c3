// dns.win32.c3

module ext::net::dns @if(env::WIN32);

import stdio;
import stdlib;
import string;
import errno;
import winsock2;
import ws2tcpip;
import std::collections::list;
import ext::net::wsa;

fn List{String}? get_addrinfo(Allocator allocx, String host)
{
    wsa::startup()!;

    char[128] hostname;
    usz copy_len = host.len < 127 ? host.len : 127;
    string::strncpy(&hostname[0], host.ptr, copy_len);
    hostname[copy_len] = 0;
    
    ws2tcpip::AddrInfo hints = {};
    hints.ai_family = winsock2::AF_UNSPEC; // Both IPv4, IPv6
    hints.ai_socktype = winsock2::SOCK_STREAM; // TCP

    // DNS Lookup
    ws2tcpip::AddrInfo* result;
    int r = ws2tcpip::getaddrinfo(&hostname[0], null, &hints, &result);
    if (r != 0) {
        return errno::get_fault()~;
    }

    List{String} ips;
    ips.init(allocx);
    
    for (ws2tcpip::AddrInfo* rp = result; rp != null; rp = rp.ai_next) {
        void* addr;

        if (rp.ai_family == winsock2::AF_INET) {
            // IPv4
            winsock2::SockAddrIn* ipv4 = (winsock2::SockAddrIn*)rp.ai_addr;
            addr = &(ipv4.sin_addr);
        } else if (rp.ai_family == winsock2::AF_INET6) {
            // IPv6
            winsock2::SockAddrIn6* ipv6 = (winsock2::SockAddrIn6*)rp.ai_addr;
            addr = &(ipv6.sin6_addr);
        } else {
            continue;
        }

        char[ws2tcpip::INET6_ADDRSTRLEN] ipstr;
        char* p = ws2tcpip::inet_ntop(rp.ai_family, addr, &ipstr[0], ipstr.len);
        if (p == null) continue;
        
        ips.push(((ZString)&ipstr[0]).str_view().copy(mem));
    }

    ws2tcpip::freeaddrinfo(result);
    return ips;
}