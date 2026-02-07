// netinet.in.h.c3

module netinet::in @if(env::LINUX);

// ========== Function Declarations ==========

// Byte order conversion functions
extern fn ushort htons(ushort hostshort);
extern fn uint htonl(uint hostlong);
extern fn ushort ntohs(ushort netshort);
extern fn uint ntohl(uint netlong);

// Address conversion functions
extern fn uint inet_addr(char* cp);
extern fn char* inet_ntoa(InAddr in_);
extern fn int inet_pton(int af, char* src, void* dst);
extern fn char* inet_ntop(int af, void* src, char* dst, uint size);
extern fn int inet_aton(char* cp, InAddr* inp);

// Network/host address conversion
extern fn uint inet_network(char* cp);
extern fn InAddr inet_makeaddr(uint net, uint host);
extern fn uint inet_lnaof(InAddr in_);
extern fn uint inet_netof(InAddr in_);

// ========== Type Definitions ==========

// Internet address structure
struct InAddr {
    uint s_addr;
}

// IPv6 address structure
struct In6Addr {
    union {
        char[16] s6_addr;
        ushort[8] s6_addr16;
        uint[4] s6_addr32;
    }
}

// Socket address structures (Linux)
struct SockAddrIn {
    ushort sin_family;
    ushort sin_port;
    InAddr sin_addr;
    char[8] sin_zero;
}

struct SockAddrIn6 {
    ushort sin6_family;
    ushort sin6_port;
    uint sin6_flowinfo;
    In6Addr sin6_addr;
    uint sin6_scope_id;
}

// Multicast request structures
struct IpMreq {
    InAddr imr_multiaddr;
    InAddr imr_interface;
}

struct IpMreqn {
    InAddr imr_multiaddr;
    InAddr imr_address;
    int imr_ifindex;
}

struct IpMreqSource {
    InAddr imr_multiaddr;
    InAddr imr_interface;
    InAddr imr_sourceaddr;
}

struct Ipv6Mreq {
    In6Addr ipv6mr_multiaddr;
    uint ipv6mr_interface;
}

// Additional structures
struct IpPktinfo {
    int ipi_ifindex;
    InAddr ipi_spec_dst;
    InAddr ipi_addr;
}

struct Ipv6Pktinfo {
    In6Addr ipi6_addr;
    uint ipi6_ifindex;
}

struct InPktinfo {
    int ipi_ifindex;
    InAddr ipi_spec_dst;
    InAddr ipi_addr;
}

struct In6Pktinfo {
    In6Addr ipi6_addr;
    uint ipi6_ifindex;
}

// ========== Constants ==========

// IP protocols
const int IPPROTO_IP = 0;
const int IPPROTO_ICMP = 1;
const int IPPROTO_IGMP = 2;
const int IPPROTO_IPIP = 4;
const int IPPROTO_TCP = 6;
const int IPPROTO_EGP = 8;
const int IPPROTO_PUP = 12;
const int IPPROTO_UDP = 17;
const int IPPROTO_IDP = 22;
const int IPPROTO_TP = 29;
const int IPPROTO_DCCP = 33;
const int IPPROTO_IPV6 = 41;
const int IPPROTO_RSVP = 46;
const int IPPROTO_GRE = 47;
const int IPPROTO_ESP = 50;
const int IPPROTO_AH = 51;
const int IPPROTO_MTP = 92;
const int IPPROTO_BEETPH = 94;
const int IPPROTO_ENCAP = 98;
const int IPPROTO_PIM = 103;
const int IPPROTO_COMP = 108;
const int IPPROTO_SCTP = 132;
const int IPPROTO_UDPLITE = 136;
const int IPPROTO_MPLS = 137;
const int IPPROTO_RAW = 255;

// Standard well-defined IP protocols
const int IPPROTO_HOPOPTS = 0;
const int IPPROTO_ROUTING = 43;
const int IPPROTO_FRAGMENT = 44;
const int IPPROTO_ICMPV6 = 58;
const int IPPROTO_NONE = 59;
const int IPPROTO_DSTOPTS = 60;
const int IPPROTO_MH = 135;

// Port numbers
const ushort IPPORT_ECHO = 7;
const ushort IPPORT_DISCARD = 9;
const ushort IPPORT_SYSTAT = 11;
const ushort IPPORT_DAYTIME = 13;
const ushort IPPORT_NETSTAT = 15;
const ushort IPPORT_FTP = 21;
const ushort IPPORT_TELNET = 23;
const ushort IPPORT_SMTP = 25;
const ushort IPPORT_TIMESERVER = 37;
const ushort IPPORT_NAMESERVER = 42;
const ushort IPPORT_WHOIS = 43;
const ushort IPPORT_MTP = 57;

// Special values
const ushort IPPORT_RESERVED = 1024;
const ushort IPPORT_USERRESERVED = 5000;

// IPv4 multicast addresses
const uint INADDR_ANY = 0x00000000;
const uint INADDR_BROADCAST = 0xffffffff;
const uint INADDR_NONE = 0xffffffff;
const uint INADDR_LOOPBACK = 0x7f000001;

const uint INADDR_UNSPEC_GROUP = 0xe0000000;
const uint INADDR_ALLHOSTS_GROUP = 0xe0000001;
const uint INADDR_ALLRTRS_GROUP = 0xe0000002;
const uint INADDR_MAX_LOCAL_GROUP = 0xe00000ff;

// IP options for setsockopt
const int IP_OPTIONS = 4;
const int IP_HDRINCL = 3;
const int IP_TOS = 1;
const int IP_TTL = 2;
const int IP_RECVOPTS = 6;
const int IP_RETOPTS = 7;
const int IP_RECVRETOPTS = IP_RETOPTS;
const int IP_RECVDSTADDR = 7;
const int IP_MULTICAST_IF = 32;
const int IP_MULTICAST_TTL = 33;
const int IP_MULTICAST_LOOP = 34;
const int IP_ADD_MEMBERSHIP = 35;
const int IP_DROP_MEMBERSHIP = 36;
const int IP_UNBLOCK_SOURCE = 37;
const int IP_BLOCK_SOURCE = 38;
const int IP_ADD_SOURCE_MEMBERSHIP = 39;
const int IP_DROP_SOURCE_MEMBERSHIP = 40;
const int IP_MSFILTER = 41;

// Linux-specific IP options
const int IP_PKTINFO = 8;
const int IP_PKTOPTIONS = 9;
const int IP_PMTUDISC = 10;
const int IP_MTU_DISCOVER = 10;
const int IP_RECVERR = 11;
const int IP_RECVTTL = 12;
const int IP_RECVTOS = 13;
const int IP_MTU = 14;
const int IP_FREEBIND = 15;
const int IP_IPSEC_POLICY = 16;
const int IP_XFRM_POLICY = 17;
const int IP_PASSSEC = 18;
const int IP_TRANSPARENT = 19;
const int IP_ORIGDSTADDR = 20;
const int IP_RECVORIGDSTADDR = IP_ORIGDSTADDR;
const int IP_MINTTL = 21;
const int IP_NODEFRAG = 22;
const int IP_CHECKSUM = 23;
const int IP_BIND_ADDRESS_NO_PORT = 24;

// Path MTU discovery values
const int IP_PMTUDISC_DONT = 0;
const int IP_PMTUDISC_WANT = 1;
const int IP_PMTUDISC_DO = 2;
const int IP_PMTUDISC_PROBE = 3;
const int IP_PMTUDISC_INTERFACE = 4;
const int IP_PMTUDISC_OMIT = 5;

// IPv6 options (Linux)
const int IPV6_ADDRFORM = 1;
const int IPV6_2292PKTINFO = 2;
const int IPV6_2292HOPOPTS = 3;
const int IPV6_2292DSTOPTS = 4;
const int IPV6_2292RTHDR = 5;
const int IPV6_2292PKTOPTIONS = 6;
const int IPV6_CHECKSUM = 7;
const int IPV6_2292HOPLIMIT = 8;
const int IPV6_NEXTHOP = 9;
const int IPV6_AUTHHDR = 10;
const int IPV6_FLOWINFO = 11;
const int IPV6_UNICAST_HOPS = 16;
const int IPV6_MULTICAST_IF = 17;
const int IPV6_MULTICAST_HOPS = 18;
const int IPV6_MULTICAST_LOOP = 19;
const int IPV6_ADD_MEMBERSHIP = 20;
const int IPV6_DROP_MEMBERSHIP = 21;
const int IPV6_JOIN_GROUP = 20;
const int IPV6_LEAVE_GROUP = 21;
const int IPV6_ROUTER_ALERT = 22;
const int IPV6_MTU_DISCOVER = 23;
const int IPV6_MTU = 24;
const int IPV6_RECVERR = 25;
const int IPV6_V6ONLY = 26;
const int IPV6_JOIN_ANYCAST = 27;
const int IPV6_LEAVE_ANYCAST = 28;
const int IPV6_IPSEC_POLICY = 34;
const int IPV6_XFRM_POLICY = 35;
const int IPV6_RECVPKTINFO = 49;
const int IPV6_PKTINFO = 50;
const int IPV6_RECVHOPLIMIT = 51;
const int IPV6_HOPLIMIT = 52;
const int IPV6_RECVHOPOPTS = 53;
const int IPV6_HOPOPTS = 54;
const int IPV6_RTHDRDSTOPTS = 55;
const int IPV6_RECVRTHDR = 56;
const int IPV6_RTHDR = 57;
const int IPV6_RECVDSTOPTS = 58;
const int IPV6_DSTOPTS = 59;
const int IPV6_RECVPATHMTU = 60;
const int IPV6_PATHMTU = 61;
const int IPV6_DONTFRAG = 62;
const int IPV6_RECVTCLASS = 66;
const int IPV6_TCLASS = 67;




module netinet::in @if(env::DARWIN);

// ========== Function Declarations ==========

// Byte order conversion functions
extern fn ushort htons(ushort hostshort);
extern fn uint htonl(uint hostlong);
extern fn ushort ntohs(ushort netshort);
extern fn uint ntohl(uint netlong);

// Address conversion functions
extern fn uint inet_addr(char* cp);
extern fn char* inet_ntoa(InAddr in_);
extern fn int inet_pton(int af, char* src, void* dst);
extern fn char* inet_ntop(int af, void* src, char* dst, uint size);
extern fn int inet_aton(char* cp, InAddr* inp);

// Network/host address conversion
extern fn uint inet_network(char* cp);
extern fn InAddr inet_makeaddr(uint net, uint host);
extern fn uint inet_lnaof(InAddr in_);
extern fn uint inet_netof(InAddr in_);

// ========== Type Definitions ==========

// Internet address structure
struct InAddr {
    uint s_addr;
}

// IPv6 address structure
struct In6Addr {
    union {
        char[16] s6_addr;
        ushort[8] s6_addr16;
        uint[4] s6_addr32;
    }
}

// Socket address structures (Darwin - includes length field)
struct SockAddrIn {
    char sin_len;
    char sin_family;
    ushort sin_port;
    InAddr sin_addr;
    char[8] sin_zero;
}

struct SockAddrIn6 {
    char sin6_len;
    char sin6_family;
    ushort sin6_port;
    uint sin6_flowinfo;
    In6Addr sin6_addr;
    uint sin6_scope_id;
}

// Multicast request structures
struct IpMreq {
    InAddr imr_multiaddr;
    InAddr imr_interface;
}

struct IpMreqn {
    InAddr imr_multiaddr;
    InAddr imr_address;
    int imr_ifindex;
}

struct IpMreqSource {
    InAddr imr_multiaddr;
    InAddr imr_interface;
    InAddr imr_sourceaddr;
}

struct Ipv6Mreq {
    In6Addr ipv6mr_multiaddr;
    uint ipv6mr_interface;
}

// Additional structures
struct IpPktinfo {
    uint ipi_ifindex;
    InAddr ipi_spec_dst;
    InAddr ipi_addr;
}

struct Ipv6Pktinfo {
    In6Addr ipi6_addr;
    uint ipi6_ifindex;
}

// ========== Constants ==========

// IP protocols
const int IPPROTO_IP = 0;
const int IPPROTO_ICMP = 1;
const int IPPROTO_IGMP = 2;
const int IPPROTO_IPIP = 4;
const int IPPROTO_TCP = 6;
const int IPPROTO_EGP = 8;
const int IPPROTO_PUP = 12;
const int IPPROTO_UDP = 17;
const int IPPROTO_IDP = 22;
const int IPPROTO_TP = 29;
const int IPPROTO_DCCP = 33;
const int IPPROTO_IPV6 = 41;
const int IPPROTO_RSVP = 46;
const int IPPROTO_GRE = 47;
const int IPPROTO_ESP = 50;
const int IPPROTO_AH = 51;
const int IPPROTO_MTP = 92;
const int IPPROTO_BEETPH = 94;
const int IPPROTO_ENCAP = 98;
const int IPPROTO_PIM = 103;
const int IPPROTO_COMP = 108;
const int IPPROTO_SCTP = 132;
const int IPPROTO_UDPLITE = 136;
const int IPPROTO_MPLS = 137;
const int IPPROTO_RAW = 255;

// Standard well-defined IP protocols
const int IPPROTO_HOPOPTS = 0;
const int IPPROTO_ROUTING = 43;
const int IPPROTO_FRAGMENT = 44;
const int IPPROTO_ICMPV6 = 58;
const int IPPROTO_NONE = 59;
const int IPPROTO_DSTOPTS = 60;
const int IPPROTO_MH = 135;

// Port numbers
const ushort IPPORT_ECHO = 7;
const ushort IPPORT_DISCARD = 9;
const ushort IPPORT_SYSTAT = 11;
const ushort IPPORT_DAYTIME = 13;
const ushort IPPORT_NETSTAT = 15;
const ushort IPPORT_FTP = 21;
const ushort IPPORT_TELNET = 23;
const ushort IPPORT_SMTP = 25;
const ushort IPPORT_TIMESERVER = 37;
const ushort IPPORT_NAMESERVER = 42;
const ushort IPPORT_WHOIS = 43;
const ushort IPPORT_MTP = 57;

// Special values
const ushort IPPORT_RESERVED = 1024;
const ushort IPPORT_USERRESERVED = 5000;

// IPv4 multicast addresses
const uint INADDR_ANY = 0x00000000;
const uint INADDR_BROADCAST = 0xffffffff;
const uint INADDR_NONE = 0xffffffff;
const uint INADDR_LOOPBACK = 0x7f000001;

const uint INADDR_UNSPEC_GROUP = 0xe0000000;
const uint INADDR_ALLHOSTS_GROUP = 0xe0000001;
const uint INADDR_ALLRTRS_GROUP = 0xe0000002;
const uint INADDR_MAX_LOCAL_GROUP = 0xe00000ff;

// IP options for setsockopt
const int IP_OPTIONS = 4;
const int IP_HDRINCL = 3;
const int IP_TOS = 1;
const int IP_TTL = 2;
const int IP_RECVOPTS = 6;
const int IP_RETOPTS = 8;
const int IP_RECVRETOPTS = IP_RETOPTS;
const int IP_RECVDSTADDR = 7;
const int IP_MULTICAST_IF = 32;
const int IP_MULTICAST_TTL = 33;
const int IP_MULTICAST_LOOP = 34;
const int IP_ADD_MEMBERSHIP = 35;
const int IP_DROP_MEMBERSHIP = 36;
const int IP_UNBLOCK_SOURCE = 37;
const int IP_BLOCK_SOURCE = 38;
const int IP_ADD_SOURCE_MEMBERSHIP = 39;
const int IP_DROP_SOURCE_MEMBERSHIP = 40;
const int IP_MSFILTER = 41;

// Darwin-specific IP options
const int IP_PORTRANGE = 19;
const int IP_RECVIF = 20;
const int IP_IPSEC_POLICY = 21;
const int IP_FAITH = 22;
const int IP_STRIPHDR = 23;
const int IP_RECVTTL = 24;
const int IP_BOUND_IF = 25;
const int IP_PKTINFO = 26;
const int IP_RECVPKTINFO = 26;
const int IP_RECVTOS = 27;
const int IP_DONTFRAG = 28;

// Port range options
const int IP_PORTRANGE_DEFAULT = 0;
const int IP_PORTRANGE_HIGH = 1;
const int IP_PORTRANGE_LOW = 2;

// IPv6 options (Darwin)
const int IPV6_SOCKOPT_RESERVED1 = 3;
const int IPV6_UNICAST_HOPS = 4;
const int IPV6_MULTICAST_IF = 9;
const int IPV6_MULTICAST_HOPS = 10;
const int IPV6_MULTICAST_LOOP = 11;
const int IPV6_JOIN_GROUP = 12;
const int IPV6_LEAVE_GROUP = 13;
const int IPV6_PORTRANGE = 14;
const int IPV6_PKTINFO = 19;
const int IPV6_HOPLIMIT = 20;
const int IPV6_NEXTHOP = 21;
const int IPV6_HOPOPTS = 22;
const int IPV6_DSTOPTS = 23;
const int IPV6_RTHDR = 24;
const int IPV6_PKTOPTIONS = 25;
const int IPV6_CHECKSUM = 26;
const int IPV6_V6ONLY = 27;
const int IPV6_BINDV6ONLY = 27;
const int IPV6_IPSEC_POLICY = 28;
const int IPV6_FAITH = 29;
const int IPV6_FW_ADD = 30;
const int IPV6_FW_DEL = 31;
const int IPV6_FW_FLUSH = 32;
const int IPV6_FW_ZERO = 33;
const int IPV6_FW_GET = 34;
const int IPV6_RECVTCLASS = 35;
const int IPV6_TCLASS = 36;
const int IPV6_RTHDRDSTOPTS = 57;
const int IPV6_RECVPKTINFO = 61;
const int IPV6_RECVHOPLIMIT = 37;
const int IPV6_RECVRTHDR = 38;
const int IPV6_RECVHOPOPTS = 39;
const int IPV6_RECVDSTOPTS = 40;
const int IPV6_USE_MIN_MTU = 42;
const int IPV6_RECVPATHMTU = 43;
const int IPV6_PATHMTU = 44;
const int IPV6_DONTFRAG = 62;
const int IPV6_PREFER_TEMPADDR = 63;




module netinet::in @if(env::FREEBSD);

// ========== Function Declarations ==========

// Byte order conversion functions
extern fn ushort htons(ushort hostshort);
extern fn uint htonl(uint hostlong);
extern fn ushort ntohs(ushort netshort);
extern fn uint ntohl(uint netlong);

// Address conversion functions
extern fn uint inet_addr(char* cp);
extern fn char* inet_ntoa(InAddr in_);
extern fn int inet_pton(int af, char* src, void* dst);
extern fn char* inet_ntop(int af, void* src, char* dst, uint size);
extern fn int inet_aton(char* cp, InAddr* inp);

// Network/host address conversion
extern fn uint inet_network(char* cp);
extern fn InAddr inet_makeaddr(uint net, uint host);
extern fn uint inet_lnaof(InAddr in_);
extern fn uint inet_netof(InAddr in_);

// ========== Type Definitions ==========

// Internet address structure
struct InAddr {
    uint s_addr;
}

// IPv6 address structure
struct In6Addr {
    union {
        char[16] s6_addr;
        ushort[8] s6_addr16;
        uint[4] s6_addr32;
    }
}

// Socket address structures (FreeBSD - includes length field)
struct SockAddrIn {
    char sin_len;
    char sin_family;
    ushort sin_port;
    InAddr sin_addr;
    char[8] sin_zero;
}

struct SockAddrIn6 {
    char sin6_len;
    char sin6_family;
    ushort sin6_port;
    uint sin6_flowinfo;
    In6Addr sin6_addr;
    uint sin6_scope_id;
}

// Multicast request structures
struct IpMreq {
    InAddr imr_multiaddr;
    InAddr imr_interface;
}

struct IpMreqn {
    InAddr imr_multiaddr;
    InAddr imr_address;
    int imr_ifindex;
}

struct IpMreqSource {
    InAddr imr_multiaddr;
    InAddr imr_interface;
    InAddr imr_sourceaddr;
}

struct Ipv6Mreq {
    In6Addr ipv6mr_multiaddr;
    uint ipv6mr_interface;
}

// Additional structures
struct IpPktinfo {
    uint ipi_ifindex;
    InAddr ipi_spec_dst;
    InAddr ipi_addr;
}

struct Ipv6Pktinfo {
    In6Addr ipi6_addr;
    uint ipi6_ifindex;
}

// ========== Constants ==========

// IP protocols
const int IPPROTO_IP = 0;
const int IPPROTO_ICMP = 1;
const int IPPROTO_IGMP = 2;
const int IPPROTO_IPIP = 4;
const int IPPROTO_TCP = 6;
const int IPPROTO_EGP = 8;
const int IPPROTO_PUP = 12;
const int IPPROTO_UDP = 17;
const int IPPROTO_IDP = 22;
const int IPPROTO_TP = 29;
const int IPPROTO_DCCP = 33;
const int IPPROTO_IPV6 = 41;
const int IPPROTO_RSVP = 46;
const int IPPROTO_GRE = 47;
const int IPPROTO_ESP = 50;
const int IPPROTO_AH = 51;
const int IPPROTO_MTP = 92;
const int IPPROTO_BEETPH = 94;
const int IPPROTO_ENCAP = 98;
const int IPPROTO_PIM = 103;
const int IPPROTO_COMP = 108;
const int IPPROTO_SCTP = 132;
const int IPPROTO_UDPLITE = 136;
const int IPPROTO_MPLS = 137;
const int IPPROTO_RAW = 255;

// Standard well-defined IP protocols
const int IPPROTO_HOPOPTS = 0;
const int IPPROTO_ROUTING = 43;
const int IPPROTO_FRAGMENT = 44;
const int IPPROTO_ICMPV6 = 58;
const int IPPROTO_NONE = 59;
const int IPPROTO_DSTOPTS = 60;
const int IPPROTO_MH = 135;

// Port numbers
const ushort IPPORT_ECHO = 7;
const ushort IPPORT_DISCARD = 9;
const ushort IPPORT_SYSTAT = 11;
const ushort IPPORT_DAYTIME = 13;
const ushort IPPORT_NETSTAT = 15;
const ushort IPPORT_FTP = 21;
const ushort IPPORT_TELNET = 23;
const ushort IPPORT_SMTP = 25;
const ushort IPPORT_TIMESERVER = 37;
const ushort IPPORT_NAMESERVER = 42;
const ushort IPPORT_WHOIS = 43;
const ushort IPPORT_MTP = 57;

// Special values
const ushort IPPORT_RESERVED = 1024;
const ushort IPPORT_USERRESERVED = 5000;

// IPv4 multicast addresses
const uint INADDR_ANY = 0x00000000;
const uint INADDR_BROADCAST = 0xffffffff;
const uint INADDR_NONE = 0xffffffff;
const uint INADDR_LOOPBACK = 0x7f000001;

const uint INADDR_UNSPEC_GROUP = 0xe0000000;
const uint INADDR_ALLHOSTS_GROUP = 0xe0000001;
const uint INADDR_ALLRTRS_GROUP = 0xe0000002;
const uint INADDR_MAX_LOCAL_GROUP = 0xe00000ff;

// IP options for setsockopt
const int IP_OPTIONS = 1;
const int IP_HDRINCL = 2;
const int IP_TOS = 3;
const int IP_TTL = 4;
const int IP_RECVOPTS = 5;
const int IP_RECVRETOPTS = 6;
const int IP_RECVDSTADDR = 7;
const int IP_RETOPTS = 8;
const int IP_MULTICAST_IF = 9;
const int IP_MULTICAST_TTL = 10;
const int IP_MULTICAST_LOOP = 11;
const int IP_ADD_MEMBERSHIP = 12;
const int IP_DROP_MEMBERSHIP = 13;
const int IP_MULTICAST_VIF = 14;
const int IP_RSVP_ON = 15;
const int IP_RSVP_OFF = 16;
const int IP_RSVP_VIF_ON = 17;
const int IP_RSVP_VIF_OFF = 18;
const int IP_PORTRANGE = 19;
const int IP_RECVIF = 20;
const int IP_IPSEC_POLICY = 21;
const int IP_FAITH = 22;
const int IP_ONESBCAST = 23;
const int IP_BINDANY = 24;
const int IP_BINDMULTI = 25;
const int IP_RSS_LISTEN_BUCKET = 26;
const int IP_ORIGDSTADDR = 27;
const int IP_RECVORIGDSTADDR = IP_ORIGDSTADDR;
const int IP_DONTFRAG = 67;
const int IP_RECVTOS = 68;

// FreeBSD-specific IP options
const int IP_FW_TABLE_ADD = 40;
const int IP_FW_TABLE_DEL = 41;
const int IP_FW_TABLE_FLUSH = 42;
const int IP_FW_TABLE_GETSIZE = 43;
const int IP_FW_TABLE_LIST = 44;
const int IP_FW3 = 48;
const int IP_DUMMYNET3 = 49;
const int IP_DUMMYNET_CONFIGURE = 50;
const int IP_DUMMYNET_DEL = 51;
const int IP_DUMMYNET_FLUSH = 52;
const int IP_DUMMYNET_GET = 64;

// Port range options
const int IP_PORTRANGE_DEFAULT = 0;
const int IP_PORTRANGE_HIGH = 1;
const int IP_PORTRANGE_LOW = 2;

// IPv6 options (FreeBSD)
const int IPV6_SOCKOPT_RESERVED1 = 3;
const int IPV6_UNICAST_HOPS = 4;
const int IPV6_MULTICAST_IF = 9;
const int IPV6_MULTICAST_HOPS = 10;
const int IPV6_MULTICAST_LOOP = 11;
const int IPV6_JOIN_GROUP = 12;
const int IPV6_LEAVE_GROUP = 13;
const int IPV6_PORTRANGE = 14;
const int IPV6_PKTINFO = 19;
const int IPV6_HOPLIMIT = 20;
const int IPV6_NEXTHOP = 21;
const int IPV6_HOPOPTS = 22;
const int IPV6_DSTOPTS = 23;
const int IPV6_RTHDR = 24;
const int IPV6_PKTOPTIONS = 25;
const int IPV6_CHECKSUM = 26;
const int IPV6_V6ONLY = 27;
const int IPV6_BINDV6ONLY = IPV6_V6ONLY;
const int IPV6_IPSEC_POLICY = 28;
const int IPV6_FAITH = 29;
const int IPV6_RECVPKTINFO = 36;
const int IPV6_RECVHOPLIMIT = 37;
const int IPV6_RECVRTHDR = 38;
const int IPV6_RECVHOPOPTS = 39;
const int IPV6_RECVDSTOPTS = 40;
const int IPV6_USE_MIN_MTU = 42;
const int IPV6_RECVPATHMTU = 43;
const int IPV6_PATHMTU = 44;
const int IPV6_DONTFRAG = 62;
const int IPV6_RECVTCLASS = 57;
const int IPV6_TCLASS = 61;
const int IPV6_BINDANY = 64;
const int IPV6_BINDMULTI = 65;
const int IPV6_RSS_LISTEN_BUCKET = 66;
const int IPV6_FLOWID = 67;
const int IPV6_FLOWTYPE = 68;
const int IPV6_RSSBUCKETID = 69;
const int IPV6_RECVFLOWID = 70;
const int IPV6_RECVRSSBUCKETID = 71;




module netinet::in @if(env::NETBSD);

// ========== Function Declarations ==========

// Byte order conversion functions
extern fn ushort htons(ushort hostshort);
extern fn uint htonl(uint hostlong);
extern fn ushort ntohs(ushort netshort);
extern fn uint ntohl(uint netlong);

// Address conversion functions
extern fn uint inet_addr(char* cp);
extern fn char* inet_ntoa(InAddr in_);
extern fn int inet_pton(int af, char* src, void* dst);
extern fn char* inet_ntop(int af, void* src, char* dst, uint size);
extern fn int inet_aton(char* cp, InAddr* inp);

// Network/host address conversion
extern fn uint inet_network(char* cp);
extern fn InAddr inet_makeaddr(uint net, uint host);
extern fn uint inet_lnaof(InAddr in_);
extern fn uint inet_netof(InAddr in_);

// ========== Type Definitions ==========

// Internet address structure
struct InAddr {
    uint s_addr;
}

// IPv6 address structure
struct In6Addr {
    union {
        char[16] s6_addr;
        ushort[8] s6_addr16;
        uint[4] s6_addr32;
    }
}

// Socket address structures (NetBSD - includes length field)
struct SockAddrIn {
    char sin_len;
    char sin_family;
    ushort sin_port;
    InAddr sin_addr;
    char[8] sin_zero;
}

struct SockAddrIn6 {
    char sin6_len;
    char sin6_family;
    ushort sin6_port;
    uint sin6_flowinfo;
    In6Addr sin6_addr;
    uint sin6_scope_id;
}

// Multicast request structures
struct IpMreq {
    InAddr imr_multiaddr;
    InAddr imr_interface;
}

struct IpMreqn {
    InAddr imr_multiaddr;
    InAddr imr_address;
    int imr_ifindex;
}

struct IpMreqSource {
    InAddr imr_multiaddr;
    InAddr imr_interface;
    InAddr imr_sourceaddr;
}

struct Ipv6Mreq {
    In6Addr ipv6mr_multiaddr;
    uint ipv6mr_interface;
}

// Additional structures
struct IpPktinfo {
    uint ipi_ifindex;
    InAddr ipi_spec_dst;
    InAddr ipi_addr;
}

struct Ipv6Pktinfo {
    In6Addr ipi6_addr;
    uint ipi6_ifindex;
}

// ========== Constants ==========

// IP protocols
const int IPPROTO_IP = 0;
const int IPPROTO_ICMP = 1;
const int IPPROTO_IGMP = 2;
const int IPPROTO_IPIP = 4;
const int IPPROTO_TCP = 6;
const int IPPROTO_EGP = 8;
const int IPPROTO_PUP = 12;
const int IPPROTO_UDP = 17;
const int IPPROTO_IDP = 22;
const int IPPROTO_TP = 29;
const int IPPROTO_DCCP = 33;
const int IPPROTO_IPV6 = 41;
const int IPPROTO_RSVP = 46;
const int IPPROTO_GRE = 47;
const int IPPROTO_ESP = 50;
const int IPPROTO_AH = 51;
const int IPPROTO_MOBILE = 55;
const int IPPROTO_IPV6_ICMP = 58;
const int IPPROTO_ICMPV6 = 58;
const int IPPROTO_NONE = 59;
const int IPPROTO_DSTOPTS = 60;
const int IPPROTO_EON = 80;
const int IPPROTO_ETHERIP = 97;
const int IPPROTO_ENCAP = 98;
const int IPPROTO_PIM = 103;
const int IPPROTO_IPCOMP = 108;
const int IPPROTO_VRRP = 112;
const int IPPROTO_CARP = 112;
const int IPPROTO_L2TP = 115;
const int IPPROTO_SCTP = 132;
const int IPPROTO_PFSYNC = 240;
const int IPPROTO_RAW = 255;

// Standard well-defined IP protocols
const int IPPROTO_HOPOPTS = 0;
const int IPPROTO_ROUTING = 43;
const int IPPROTO_FRAGMENT = 44;

// Port numbers
const ushort IPPORT_ECHO = 7;
const ushort IPPORT_DISCARD = 9;
const ushort IPPORT_SYSTAT = 11;
const ushort IPPORT_DAYTIME = 13;
const ushort IPPORT_NETSTAT = 15;
const ushort IPPORT_FTP = 21;
const ushort IPPORT_TELNET = 23;
const ushort IPPORT_SMTP = 25;
const ushort IPPORT_TIMESERVER = 37;
const ushort IPPORT_NAMESERVER = 42;
const ushort IPPORT_WHOIS = 43;
const ushort IPPORT_MTP = 57;

// Special values
const ushort IPPORT_RESERVED = 1024;
const ushort IPPORT_USERRESERVED = 5000;

// IPv4 multicast addresses
const uint INADDR_ANY = 0x00000000;
const uint INADDR_BROADCAST = 0xffffffff;
const uint INADDR_NONE = 0xffffffff;
const uint INADDR_LOOPBACK = 0x7f000001;

const uint INADDR_UNSPEC_GROUP = 0xe0000000;
const uint INADDR_ALLHOSTS_GROUP = 0xe0000001;
const uint INADDR_ALLRTRS_GROUP = 0xe0000002;
const uint INADDR_MAX_LOCAL_GROUP = 0xe00000ff;

// IP options for setsockopt
const int IP_OPTIONS = 1;
const int IP_HDRINCL = 2;
const int IP_TOS = 3;
const int IP_TTL = 4;
const int IP_RECVOPTS = 5;
const int IP_RECVRETOPTS = 6;
const int IP_RECVDSTADDR = 7;
const int IP_RETOPTS = 8;
const int IP_MULTICAST_IF = 9;
const int IP_MULTICAST_TTL = 10;
const int IP_MULTICAST_LOOP = 11;
const int IP_ADD_MEMBERSHIP = 12;
const int IP_DROP_MEMBERSHIP = 13;
const int IP_PORTALGO = 18;
const int IP_PORTRANGE = 19;
const int IP_RECVIF = 20;
const int IP_ERRORMTU = 21;
const int IP_IPSEC_POLICY = 22;
const int IP_RECVTTL = 23;
const int IP_MINTTL = 24;
const int IP_PKTINFO = 25;
const int IP_RECVPKTINFO = 26;
const int IP_IPSECFLOWINFO = 27;

// Port range options
const int IP_PORTRANGE_DEFAULT = 0;
const int IP_PORTRANGE_HIGH = 1;
const int IP_PORTRANGE_LOW = 2;

// IPv6 options (NetBSD)
const int IPV6_SOCKOPT_RESERVED1 = 3;
const int IPV6_UNICAST_HOPS = 4;
const int IPV6_MULTICAST_IF = 9;
const int IPV6_MULTICAST_HOPS = 10;
const int IPV6_MULTICAST_LOOP = 11;
const int IPV6_JOIN_GROUP = 12;
const int IPV6_LEAVE_GROUP = 13;
const int IPV6_PORTRANGE = 14;
const int IPV6_PKTINFO = 19;
const int IPV6_HOPLIMIT = 20;
const int IPV6_NEXTHOP = 21;
const int IPV6_HOPOPTS = 22;
const int IPV6_DSTOPTS = 23;
const int IPV6_RTHDR = 24;
const int IPV6_PKTOPTIONS = 25;
const int IPV6_CHECKSUM = 26;
const int IPV6_V6ONLY = 27;
const int IPV6_BINDV6ONLY = IPV6_V6ONLY;
const int IPV6_IPSEC_POLICY = 28;
const int IPV6_RECVPKTINFO = 36;
const int IPV6_RECVHOPLIMIT = 37;
const int IPV6_RECVRTHDR = 38;
const int IPV6_RECVHOPOPTS = 39;
const int IPV6_RECVDSTOPTS = 40;
const int IPV6_RECVRTHDRDSTOPTS = 41;
const int IPV6_USE_MIN_MTU = 42;
const int IPV6_RECVPATHMTU = 43;
const int IPV6_PATHMTU = 44;
const int IPV6_DONTFRAG = 62;
const int IPV6_RECVTCLASS = 57;
const int IPV6_TCLASS = 61;



// in.h.openbsd.c3
module netinet::in @if(env::OPENBSD);

// ========== Function Declarations ==========

// Byte order conversion functions
extern fn ushort htons(ushort hostshort);
extern fn uint htonl(uint hostlong);
extern fn ushort ntohs(ushort netshort);
extern fn uint ntohl(uint netlong);

// Address conversion functions
extern fn uint inet_addr(char* cp);
extern fn char* inet_ntoa(InAddr in_);
extern fn int inet_pton(int af, char* src, void* dst);
extern fn char* inet_ntop(int af, void* src, char* dst, uint size);
extern fn int inet_aton(char* cp, InAddr* inp);

// Network/host address conversion
extern fn uint inet_network(char* cp);
extern fn InAddr inet_makeaddr(uint net, uint host);
extern fn uint inet_lnaof(InAddr in_);
extern fn uint inet_netof(InAddr in_);

// ========== Type Definitions ==========

// Internet address structure
struct InAddr {
    uint s_addr;
}

// IPv6 address structure
struct In6Addr {
    union {
        char[16] s6_addr;
        ushort[8] s6_addr16;
        uint[4] s6_addr32;
    }
}

// Socket address structures (OpenBSD - includes length field)
struct SockAddrIn {
    char sin_len;
    char sin_family;
    ushort sin_port;
    InAddr sin_addr;
    char[8] sin_zero;
}

struct SockAddrIn6 {
    char sin6_len;
    char sin6_family;
    ushort sin6_port;
    uint sin6_flowinfo;
    In6Addr sin6_addr;
    uint sin6_scope_id;
}

// Multicast request structures
struct IpMreq {
    InAddr imr_multiaddr;
    InAddr imr_interface;
}

struct IpMreqn {
    InAddr imr_multiaddr;
    InAddr imr_address;
    int imr_ifindex;
}

struct IpMreqSource {
    InAddr imr_multiaddr;
    InAddr imr_interface;
    InAddr imr_sourceaddr;
}

struct Ipv6Mreq {
    In6Addr ipv6mr_multiaddr;
    uint ipv6mr_interface;
}

// Additional structures
struct IpPktinfo {
    uint ipi_ifindex;
    InAddr ipi_spec_dst;
    InAddr ipi_addr;
}

struct Ipv6Pktinfo {
    In6Addr ipi6_addr;
    uint ipi6_ifindex;
}

// ========== Constants ==========

// IP protocols
const int IPPROTO_IP = 0;
const int IPPROTO_ICMP = 1;
const int IPPROTO_IGMP = 2;
const int IPPROTO_IPIP = 4;
const int IPPROTO_TCP = 6;
const int IPPROTO_EGP = 8;
const int IPPROTO_PUP = 12;
const int IPPROTO_UDP = 17;
const int IPPROTO_IDP = 22;
const int IPPROTO_TP = 29;
const int IPPROTO_IPV6 = 41;
const int IPPROTO_ROUTING = 43;
const int IPPROTO_FRAGMENT = 44;
const int IPPROTO_RSVP = 46;
const int IPPROTO_GRE = 47;
const int IPPROTO_ESP = 50;
const int IPPROTO_AH = 51;
const int IPPROTO_MOBILE = 55;
const int IPPROTO_ICMPV6 = 58;
const int IPPROTO_NONE = 59;
const int IPPROTO_DSTOPTS = 60;
const int IPPROTO_EON = 80;
const int IPPROTO_ETHERIP = 97;
const int IPPROTO_ENCAP = 98;
const int IPPROTO_PIM = 103;
const int IPPROTO_IPCOMP = 108;
const int IPPROTO_CARP = 112;
const int IPPROTO_PFSYNC = 240;
const int IPPROTO_RAW = 255;

// Standard well-defined IP protocols
const int IPPROTO_HOPOPTS = 0;

// Port numbers
const ushort IPPORT_ECHO = 7;
const ushort IPPORT_DISCARD = 9;
const ushort IPPORT_SYSTAT = 11;
const ushort IPPORT_DAYTIME = 13;
const ushort IPPORT_NETSTAT = 15;
const ushort IPPORT_FTP = 21;
const ushort IPPORT_TELNET = 23;
const ushort IPPORT_SMTP = 25;
const ushort IPPORT_TIMESERVER = 37;
const ushort IPPORT_NAMESERVER = 42;
const ushort IPPORT_WHOIS = 43;
const ushort IPPORT_MTP = 57;

// Special values
const ushort IPPORT_RESERVED = 1024;
const ushort IPPORT_USERRESERVED = 5000;
const ushort IPPORT_HIFIRSTAUTO = 49152;
const ushort IPPORT_HILASTAUTO = 65535;

// IPv4 multicast addresses
const uint INADDR_ANY = 0x00000000;
const uint INADDR_BROADCAST = 0xffffffff;
const uint INADDR_NONE = 0xffffffff;
const uint INADDR_LOOPBACK = 0x7f000001;

const uint INADDR_UNSPEC_GROUP = 0xe0000000;
const uint INADDR_ALLHOSTS_GROUP = 0xe0000001;
const uint INADDR_ALLRTRS_GROUP = 0xe0000002;
const uint INADDR_MAX_LOCAL_GROUP = 0xe00000ff;

// IP options for setsockopt
const int IP_OPTIONS = 1;
const int IP_HDRINCL = 2;
const int IP_TOS = 3;
const int IP_TTL = 4;
const int IP_RECVOPTS = 5;
const int IP_RECVRETOPTS = 6;
const int IP_RECVDSTADDR = 7;
const int IP_RETOPTS = 8;
const int IP_MULTICAST_IF = 9;
const int IP_MULTICAST_TTL = 10;
const int IP_MULTICAST_LOOP = 11;
const int IP_ADD_MEMBERSHIP = 12;
const int IP_DROP_MEMBERSHIP = 13;
const int IP_PORTRANGE = 19;
const int IP_AUTH_LEVEL = 20;
const int IP_ESP_TRANS_LEVEL = 21;
const int IP_ESP_NETWORK_LEVEL = 22;
const int IP_IPSEC_LOCAL_ID = 23;
const int IP_IPSEC_REMOTE_ID = 24;
const int IP_IPSEC_LOCAL_CRED = 25;
const int IP_IPSEC_REMOTE_CRED = 26;
const int IP_IPSEC_LOCAL_AUTH = 27;
const int IP_IPSEC_REMOTE_AUTH = 28;
const int IP_IPCOMP_LEVEL = 29;
const int IP_RECVIF = 30;
const int IP_RECVTTL = 31;
const int IP_MINTTL = 32;
const int IP_RECVDSTPORT = 33;
const int IP_PIPEX = 34;
const int IP_RECVRTABLE = 35;
const int IP_IPSECFLOWINFO = 36;
const int IP_IPDEFTTL = 37;

// Port range options
const int IP_PORTRANGE_DEFAULT = 0;
const int IP_PORTRANGE_HIGH = 1;
const int IP_PORTRANGE_LOW = 2;

// IPv6 options (OpenBSD)
const int IPV6_SOCKOPT_RESERVED1 = 3;
const int IPV6_UNICAST_HOPS = 4;
const int IPV6_MULTICAST_IF = 9;
const int IPV6_MULTICAST_HOPS = 10;
const int IPV6_MULTICAST_LOOP = 11;
const int IPV6_JOIN_GROUP = 12;
const int IPV6_LEAVE_GROUP = 13;
const int IPV6_PORTRANGE = 14;
const int IPV6_PKTINFO = 19;
const int IPV6_HOPLIMIT = 20;
const int IPV6_NEXTHOP = 21;
const int IPV6_HOPOPTS = 22;
const int IPV6_DSTOPTS = 23;
const int IPV6_RTHDR = 24;
const int IPV6_PKTOPTIONS = 25;
const int IPV6_CHECKSUM = 26;
const int IPV6_V6ONLY = 27;
const int IPV6_RECVPKTINFO = 36;
const int IPV6_RECVHOPLIMIT = 37;
const int IPV6_RECVRTHDR = 38;
const int IPV6_RECVHOPOPTS = 39;
const int IPV6_RECVDSTOPTS = 40;
const int IPV6_RECVRTHDRDSTOPTS = 41;
const int IPV6_USE_MIN_MTU = 42;
const int IPV6_RECVPATHMTU = 43;
const int IPV6_PATHMTU = 44;
const int IPV6_DONTFRAG = 62;
const int IPV6_RECVTCLASS = 57;
const int IPV6_TCLASS = 61;
const int IPV6_AUTH_LEVEL = 53;
const int IPV6_ESP_TRANS_LEVEL = 54;
const int IPV6_ESP_NETWORK_LEVEL = 55;
const int IPV6_IPCOMP_LEVEL = 60;
const int IPV6_RECVIF = 58;
const int IPV6_RECVDSTPORT = 64;
const int IPV6_PIPEX = 63;
const int IPV6_RECVRTABLE = 65;
const int IPV6_IPSECFLOWINFO = 59;
const int IPV6_IPDEFTTL = 66;


