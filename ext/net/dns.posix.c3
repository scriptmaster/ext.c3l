// dns.posix.c3

module ext::net::dns @if(!env::WIN32);

import stdio;
import stdlib;
import string;
import netdb;
import errno;
import arpa::inet;
import netinet::in;
import sys::socket;
import std::collections::list;

<*
  should properly free returned List
*>
List{String}? get_addrinfo(Allocator allocx, String host)
{
    char[128] hostname;
    usz copy_len = host.len < 127 ? host.len : 127;
    string::strncpy(&hostname[0], host.ptr, copy_len);
    hostname[copy_len] = 0;
    
    in::AddrInfo hints = {};
    hints.ai_family = socket::AF_UNSPEC; // Both IPv4, IPv6
    hints.ai_socktype = socket::SOCK_STREAM; // TCP

    // DNS Lookup
    in::AddrInfo* result;
    int r = netdb::getaddrinfo(hostname, null, &hints, &result);
    if (r != 0) {
        return errno::get_fault()~;
    }

    List{String} ips;
    ips.init(allocx);
    
    for (in::AddrInfo* rp = result; rp != null; rp = rp.ai_next) {
        void *addr;

        if (rp.ai_family == socket::AF_INET) {
            in::SockAddrIn* ipv4 = (in::SockAddrIn*)rp.ai_addr;
            addr = &(ipv4.sin_addr);
        } else {
            in::SockAddrIn6* ipv6 = (in::SockAddrIn6*)rp.ai_addr;
            addr = &(ipv6.sin6_addr);
        } else {
            continue;
        }

        char[inet::INET6_ADDRSTRLEN] ipstr;
        char* p = inet_ntop(rp->ai_family, addr, &[0]ipstr, ipstr.len);
        if (p == null) continue;
        
        ips.push(((Zstring)&ipstr[0]).str_view().copy(mem));
    }

    netdb::freeaddrinfo(result);
    return ips;
}
