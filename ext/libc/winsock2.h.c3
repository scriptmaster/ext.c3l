// winsock2.h.c3 
module winsock2 @if(env::WIN32);

// Windows Socket API 2
// C3 mapping for winsock2.h

// Common Windows types
alias Handle = void*;
alias DWord = uint;
alias Bool = int;
alias PVoid = void*;
alias ULong = uint;
alias UShort = ushort;
alias UChar = char;
alias ULongPtr = ulong*;

// Socket types
alias Socket = uptr;
alias Group = uint;

// Address family constants
const int AF_UNSPEC = 0;
const int AF_UNIX = 1;
const int AF_INET = 2;
const int AF_IMPLINK = 3;
const int AF_PUP = 4;
const int AF_CHAOS = 5;
const int AF_NS = 6;
const int AF_IPX = 6;
const int AF_ISO = 7;
const int AF_OSI = 7;
const int AF_ECMA = 8;
const int AF_DATAKIT = 9;
const int AF_CCITT = 10;
const int AF_SNA = 11;
const int AF_DECNET = 12;
const int AF_DLI = 13;
const int AF_LAT = 14;
const int AF_HYLINK = 15;
const int AF_APPLETALK = 16;
const int AF_NETBIOS = 17;
const int AF_VOICEVIEW = 18;
const int AF_FIREFOX = 19;
const int AF_UNKNOWN1 = 20;
const int AF_BAN = 21;
const int AF_ATM = 22;
const int AF_INET6 = 23;
const int AF_CLUSTER = 24;
const int AF_12844 = 25;
const int AF_IRDA = 26;
const int AF_NETDES = 28;
const int AF_TCNPROCESS = 29;
const int AF_TCNMESSAGE = 30;
const int AF_ICLFXBM = 31;
const int AF_BTH = 32;
const int AF_LINK = 33;
const int AF_HYPERV = 34;
const int AF_MAX = 35;

// Socket types
const int SOCK_STREAM = 1;
const int SOCK_DGRAM = 2;
const int SOCK_RAW = 3;
const int SOCK_RDM = 4;
const int SOCK_SEQPACKET = 5;

// Protocol constants
const int IPPROTO_IP = 0;
const int IPPROTO_ICMP = 1;
const int IPPROTO_IGMP = 2;
const int IPPROTO_GGP = 3;
const int IPPROTO_TCP = 6;
const int IPPROTO_PUP = 12;
const int IPPROTO_UDP = 17;
const int IPPROTO_IDP = 22;
const int IPPROTO_IPV6 = 41;
const int IPPROTO_ROUTING = 43;
const int IPPROTO_FRAGMENT = 44;
const int IPPROTO_ESP = 50;
const int IPPROTO_AH = 51;
const int IPPROTO_ICMPV6 = 58;
const int IPPROTO_NONE = 59;
const int IPPROTO_DSTOPTS = 60;
const int IPPROTO_ND = 77;
const int IPPROTO_ICLFXBM = 78;
const int IPPROTO_RAW = 255;
const int IPPROTO_MAX = 256;

// Socket options
const int SOL_SOCKET = 0xFFFF;

const int SO_DEBUG = 0x0001;
const int SO_ACCEPTCONN = 0x0002;
const int SO_REUSEADDR = 0x0004;
const int SO_KEEPALIVE = 0x0008;
const int SO_DONTROUTE = 0x0010;
const int SO_BROADCAST = 0x0020;
const int SO_USELOOPBACK = 0x0040;
const int SO_LINGER = 0x0080;
const int SO_OOBINLINE = 0x0100;
const int SO_DONTLINGER = 0xFF7F;
const uint SO_EXCLUSIVEADDRUSE = 0xFFFFFFFE;
const int SO_SNDBUF = 0x1001;
const int SO_RCVBUF = 0x1002;
const int SO_SNDLOWAT = 0x1003;
const int SO_RCVLOWAT = 0x1004;
const int SO_SNDTIMEO = 0x1005;
const int SO_RCVTIMEO = 0x1006;
const int SO_ERROR = 0x1007;
const int SO_TYPE = 0x1008;
const int SO_GROUP_ID = 0x2001;
const int SO_GROUP_PRIORITY = 0x2002;
const int SO_MAX_MSG_SIZE = 0x2003;
const int SO_PROTOCOL_INFOA = 0x2004;
const int SO_PROTOCOL_INFOW = 0x2005;
const int SO_CONDITIONAL_ACCEPT = 0x3002;
const int SO_PAUSE_ACCEPT = 0x3003;
const int SO_COMPARTMENT_ID = 0x3004;
const int SO_RANDOMIZE_PORT = 0x3005;
const int SO_PORT_SCALABILITY = 0x3006;
const int SO_REUSE_UNICASTPORT = 0x3007;
const int SO_REUSE_MULTICASTPORT = 0x3008;

// TCP options
const int TCP_NODELAY = 0x0001;
const int TCP_EXPEDITED_1122 = 0x0002;
const int TCP_KEEPALIVE = 3;
const int TCP_MAXSEG = 4;
const int TCP_MAXRT = 5;
const int TCP_STDURG = 6;
const int TCP_NOURG = 7;
const int TCP_ATMARK = 8;
const int TCP_NOSYNRETRIES = 9;
const int TCP_TIMESTAMPS = 10;
const int TCP_OFFLOAD_PREFERENCE = 11;
const int TCP_CONGESTION_ALGORITHM = 12;
const int TCP_DELAY_FIN_ACK = 13;

// IP options
const int IP_OPTIONS = 1;
const int IP_HDRINCL = 2;
const int IP_TOS = 3;
const int IP_TTL = 4;
const int IP_MULTICAST_IF = 9;
const int IP_MULTICAST_TTL = 10;
const int IP_MULTICAST_LOOP = 11;
const int IP_ADD_MEMBERSHIP = 12;
const int IP_DROP_MEMBERSHIP = 13;
const int IP_DONTFRAGMENT = 14;
const int IP_ADD_SOURCE_MEMBERSHIP = 15;
const int IP_DROP_SOURCE_MEMBERSHIP = 16;
const int IP_BLOCK_SOURCE = 17;
const int IP_UNBLOCK_SOURCE = 18;
const int IP_PKTINFO = 19;
const int IP_RECEIVE_BROADCAST = 22;

// IPv6 options
const int IPV6_HOPOPTS = 1;
const int IPV6_HDRINCL = 2;
const int IPV6_UNICAST_HOPS = 4;
const int IPV6_MULTICAST_IF = 9;
const int IPV6_MULTICAST_HOPS = 10;
const int IPV6_MULTICAST_LOOP = 11;
const int IPV6_ADD_MEMBERSHIP = 12;
const int IPV6_DROP_MEMBERSHIP = 13;
const int IPV6_DONTFRAG = 14;
const int IPV6_PKTINFO = 19;
const int IPV6_HOPLIMIT = 21;
const int IPV6_CHECKSUM = 26;
const int IPV6_V6ONLY = 27;

// Shutdown options
const int SD_RECEIVE = 0x00;
const int SD_SEND = 0x01;
const int SD_BOTH = 0x02;

// Message flags
const int MSG_OOB = 0x1;
const int MSG_PEEK = 0x2;
const int MSG_DONTROUTE = 0x4;
const int MSG_WAITALL = 0x8;
const int MSG_PARTIAL = 0x8000;
const int MSG_INTERRUPT = 0x10;
const int MSG_MAXIOVLEN = 16;

// Constants
const Socket INVALID_SOCKET = 0xFFFFFFFFFFFFFFFF;
const int SOCKET_ERROR = -1;
const int INADDR_ANY = 0x00000000;
const uint INADDR_LOOPBACK = 0x7F000001;
const uint INADDR_BROADCAST = 0xFFFFFFFF;
const uint INADDR_NONE = 0xFFFFFFFF;

// IO control codes
const uint FIONREAD = 0x4004667F;
const uint FIONBIO = 0x8004667E;
const uint FIOASYNC = 0x8004667D;
const uint SIOCSHIWAT = 0x80047300;
const uint SIOCGHIWAT = 0x40047301;
const uint SIOCSLOWAT = 0x80047302;
const uint SIOCGLOWAT = 0x40047303;
const uint SIOCATMARK = 0x40047307;

// WSA constants
const int WSADESCRIPTION_LEN = 256;
const int WSASYS_STATUS_LEN = 128;
const int WSA_FLAG_OVERLAPPED = 0x01;
const int WSA_FLAG_MULTIPOINT_C_ROOT = 0x02;
const int WSA_FLAG_MULTIPOINT_C_LEAF = 0x04;
const int WSA_FLAG_MULTIPOINT_D_ROOT = 0x08;
const int WSA_FLAG_MULTIPOINT_D_LEAF = 0x10;
const int WSA_FLAG_ACCESS_SYSTEM_SECURITY = 0x40;
const int WSA_FLAG_NO_HANDLE_INHERIT = 0x80;
const int WSA_FLAG_REGISTERED_IO = 0x100;

// Maximum queue length for listen
const int SOMAXCONN = 0x7FFFFFFF;

// FD_SET constants
const int FD_SETSIZE = 64;

// Structures
struct InAddr {
    union {
        struct {
            UChar s_b1;
            UChar s_b2;
            UChar s_b3;
            UChar s_b4;
        } 
        struct {
            UShort s_w1;
            UShort s_w2;
        } 
        ULong s_addr;
    } 
}

struct In6Addr {
    union u {
        UChar[16] byte;
        UShort[8] word;
    } 
}

struct SockAddr {
    UShort sa_family;
    char[14] sa_data;
}

struct SockAddrIn {
    short sin_family;
    UShort sin_port;
    InAddr sin_addr;
    char[8] sin_zero;
}

struct SockAddrIn6 {
    short sin6_family;
    UShort sin6_port;
    ULong sin6_flowinfo;
    In6Addr sin6_addr;
    ULong sin6_scope_id;
}

struct SockAddrStorage {
    short ss_family;
    char[6] __ss_pad1;
    long __ss_align;
    char[112] __ss_pad2;
}

struct AddrInfo {
    int ai_flags;
    int ai_family;
    int ai_socktype;
    int ai_protocol;
    ulong ai_addrlen;
    char* ai_canonname;
    SockAddr* ai_addr;
    AddrInfo* ai_next;
}

struct AddrInfoW {
    int ai_flags;
    int ai_family;
    int ai_socktype;
    int ai_protocol;
    ulong ai_addrlen;
    short* ai_canonname;
    SockAddr* ai_addr;
    AddrInfoW* ai_next;
}

struct HostEnt {
    char* h_name;
    char** h_aliases;
    short h_addrtype;
    short h_length;
    char** h_addr_list;
}

struct ServEnt {
    char* s_name;
    char** s_aliases;
    short s_port;
    char* s_proto;
}

struct ProtoEnt {
    char* p_name;
    char** p_aliases;
    short p_proto;
}

struct NetEnt {
    char* n_name;
    char** n_aliases;
    short n_addrtype;
    ULong n_net;
}

struct Linger {
    UShort l_onoff;
    UShort l_linger;
}

struct TimeVal {
    int tv_sec;
    int tv_usec;
}

struct FdSet {
    uint fd_count;
    Socket[FD_SETSIZE] fd_array;
}

struct WSAData {
    ushort w_version;
    ushort w_high_version;
    char[WSADESCRIPTION_LEN + 1] sz_description;
    char[WSASYS_STATUS_LEN + 1] sz_system_status;
    ushort i_max_sockets;
    ushort i_max_udp_dg;
    char* lp_vendor_info;
}

struct WSABuf {
    ULong len;
    char* buf;
}

struct WSAMsg {
    SockAddr* name;
    int name_len;
    WSABuf* buffers;
    ULong buffer_count;
    WSABuf control;
    ULong flags;
}

struct QoS {
    void* sending_flowspec;
    void* receiving_flowspec;
    WSABuf provider_specific;
}

struct WSAOverlapped {
    ULongPtr internal;
    ULongPtr internal_high;
    union u {
        struct s {
            DWord offset;
            DWord offset_high;
        } 
        PVoid pointer;
    } 
    Handle event;
}

alias WSAOverlappedCompletionRoutine = fn void(
    DWord error,
    DWord bytes_transferred,
    WSAOverlapped* overlapped,
    DWord flags
);

// Core Socket Functions
extern fn Socket socket(int af, int type, int protocol) @cname("socket");

extern fn Socket wsa_socket_a(
    int af,
    int type,
    int protocol,
    void* protocol_info,
    Group g,
    DWord flags
) @cname("WSASocketA");

extern fn Socket wsa_socket_w(
    int af,
    int type,
    int protocol,
    void* protocol_info,
    Group g,
    DWord flags
) @cname("WSASocketW");

extern fn int closesocket(Socket s) @cname("closesocket");

extern fn int bind(Socket s, SockAddr* name, int namelen) @cname("bind");

extern fn int listen(Socket s, int backlog) @cname("listen");

extern fn Socket accept(Socket s, SockAddr* addr, int* addrlen) @cname("accept");

extern fn Socket wsa_accept(
    Socket s,
    SockAddr* addr,
    int* addrlen,
    void* condition_func,
    DWord callback_data
) @cname("WSAAccept");

extern fn int connect(Socket s, SockAddr* name, int namelen) @cname("connect");

extern fn int wsa_connect(
    Socket s,
    SockAddr* name,
    int namelen,
    WSABuf* caller_data,
    WSABuf* callee_data,
    QoS* sqos,
    QoS* gqos
) @cname("WSAConnect");

extern fn int send(Socket s, char* buf, int len, int flags) @cname("send");

extern fn int sendto(
    Socket s,
    char* buf,
    int len,
    int flags,
    SockAddr* to,
    int tolen
) @cname("sendto");

extern fn int wsa_send(
    Socket s,
    WSABuf* buffers,
    DWord buffer_count,
    DWord* bytes_sent,
    DWord flags,
    WSAOverlapped* overlapped,
    WSAOverlappedCompletionRoutine completion_routine
) @cname("WSASend");

extern fn int wsa_send_to(
    Socket s,
    WSABuf* buffers,
    DWord buffer_count,
    DWord* bytes_sent,
    DWord flags,
    SockAddr* to,
    int to_len,
    WSAOverlapped* overlapped,
    WSAOverlappedCompletionRoutine completion_routine
) @cname("WSASendTo");

extern fn int wsa_send_msg(
    Socket s,
    WSAMsg* msg,
    DWord flags,
    DWord* bytes_sent,
    WSAOverlapped* overlapped,
    WSAOverlappedCompletionRoutine completion_routine
) @cname("WSASendMsg");

extern fn int recv(Socket s, char* buf, int len, int flags) @cname("recv");

extern fn int recvfrom(
    Socket s,
    char* buf,
    int len,
    int flags,
    SockAddr* from,
    int* fromlen
) @cname("recvfrom");

extern fn int wsa_recv(
    Socket s,
    WSABuf* buffers,
    DWord buffer_count,
    DWord* bytes_received,
    DWord* flags,
    WSAOverlapped* overlapped,
    WSAOverlappedCompletionRoutine completion_routine
) @cname("WSARecv");

extern fn int wsa_recv_from(
    Socket s,
    WSABuf* buffers,
    DWord buffer_count,
    DWord* bytes_received,
    DWord* flags,
    SockAddr* from,
    int* from_len,
    WSAOverlapped* overlapped,
    WSAOverlappedCompletionRoutine completion_routine
) @cname("WSARecvFrom");

extern fn int wsa_recv_msg(
    Socket s,
    WSAMsg* msg,
    DWord* bytes_received,
    WSAOverlapped* overlapped,
    WSAOverlappedCompletionRoutine completion_routine
) @cname("WSARecvMsg");

extern fn int shutdown(Socket s, int how) @cname("shutdown");

// Socket Options
extern fn int getsockopt(
    Socket s,
    int level,
    int optname,
    char* optval,
    int* optlen
) @cname("getsockopt");

extern fn int setsockopt(
    Socket s,
    int level,
    int optname,
    char* optval,
    int optlen
) @cname("setsockopt");

extern fn int getsockname(Socket s, SockAddr* name, int* namelen) @cname("getsockname");

extern fn int getpeername(Socket s, SockAddr* name, int* namelen) @cname("getpeername");

// I/O Control
extern fn int ioctlsocket(Socket s, uint cmd, ULong* argp) @cname("ioctlsocket");

extern fn int wsa_ioctl(
    Socket s,
    DWord io_control_code,
    PVoid in_buffer,
    DWord in_buffer_size,
    PVoid out_buffer,
    DWord out_buffer_size,
    DWord* bytes_returned,
    WSAOverlapped* overlapped,
    WSAOverlappedCompletionRoutine completion_routine
) @cname("WSAIoctl");

// Select
extern fn int select(
    int nfds,
    FdSet* readfds,
    FdSet* writefds,
    FdSet* exceptfds,
    TimeVal* timeout
) @cname("select");

extern fn int wsa_poll(
    void* fds,
    ULong fds_count,
    int timeout
) @cname("WSAPoll");

// WSA Initialization
extern fn int wsa_startup(ushort version_required, WSAData* wsa_data) @cname("WSAStartup");

extern fn int wsa_cleanup() @cname("WSACleanup");

extern fn int wsa_get_last_error() @cname("WSAGetLastError");

extern fn void wsa_set_last_error(int error) @cname("WSASetLastError");

// Address Resolution
extern fn int getaddrinfo(
    char* node_name,
    char* service_name,
    AddrInfo* hints,
    AddrInfo** result
) @cname("getaddrinfo");

extern fn int get_addr_info_w(
    short* node_name,
    short* service_name,
    AddrInfoW* hints,
    AddrInfoW** result
) @cname("GetAddrInfoW");

extern fn void freeaddrinfo(AddrInfo* ai) @cname("freeaddrinfo");

extern fn void free_addr_info_w(AddrInfoW* ai) @cname("FreeAddrInfoW");

extern fn int getnameinfo(
    SockAddr* sa,
    int salen,
    char* host,
    DWord hostlen,
    char* serv,
    DWord servlen,
    int flags
) @cname("getnameinfo");

extern fn int get_name_info_w(
    SockAddr* sa,
    int salen,
    short* host,
    DWord hostlen,
    short* serv,
    DWord servlen,
    int flags
) @cname("GetNameInfoW");

// Legacy hostname resolution
extern fn HostEnt* gethostbyname(char* name) @cname("gethostbyname");

extern fn HostEnt* gethostbyaddr(char* addr, int len, int type) @cname("gethostbyaddr");

extern fn int gethostname(char* name, int namelen) @cname("gethostname");

extern fn ServEnt* getservbyname(char* name, char* proto) @cname("getservbyname");

extern fn ServEnt* getservbyport(int port, char* proto) @cname("getservbyport");

extern fn ProtoEnt* getprotobyname(char* name) @cname("getprotobyname");

extern fn ProtoEnt* getprotobynumber(int number) @cname("getprotobynumber");

// Network byte order conversion
extern fn ULong htonl(ULong hostlong) @cname("htonl");

extern fn UShort htons(UShort hostshort) @cname("htons");

extern fn ULong ntohl(ULong netlong) @cname("ntohl");

extern fn UShort ntohs(UShort netshort) @cname("ntohs");

// IP address conversion
extern fn ULong inet_addr(char* cp) @cname("inet_addr");

extern fn char* inet_ntoa(InAddr in_addr) @cname("inet_ntoa");

extern fn int inet_pton(int family, char* src, PVoid dst) @cname("inet_pton");

extern fn char* inet_ntop(int family, PVoid src, char* dst, ulong size) @cname("inet_ntop");

// Event handling
extern fn Handle wsa_create_event() @cname("WSACreateEvent");

extern fn Bool wsa_close_event(Handle event) @cname("WSACloseEvent");

extern fn Bool wsa_set_event(Handle event) @cname("WSASetEvent");

extern fn Bool wsa_reset_event(Handle event) @cname("WSAResetEvent");

extern fn DWord wsa_wait_for_multiple_events(
    DWord count,
    Handle* events,
    Bool wait_all,
    DWord timeout,
    Bool alertable
) @cname("WSAWaitForMultipleEvents");

extern fn int wsa_event_select(Socket s, Handle event, int network_events) @cname("WSAEventSelect");

extern fn int wsa_enum_network_events(
    Socket s,
    Handle event,
    void* network_events
) @cname("WSAEnumNetworkEvents");

// Asynchronous operations
extern fn int wsa_async_select(
    Socket s,
    Handle hwnd,
    uint msg,
    int event
) @cname("WSAAsyncSelect");

extern fn Handle wsa_async_get_host_by_name(
    Handle hwnd,
    uint msg,
    char* name,
    char* buf,
    int buflen
) @cname("WSAAsyncGetHostByName");

extern fn Handle wsa_async_get_host_by_addr(
    Handle hwnd,
    uint msg,
    char* addr,
    int len,
    int type,
    char* buf,
    int buflen
) @cname("WSAAsyncGetHostByAddr");

extern fn int wsa_cancel_async_request(Handle async_task_handle) @cname("WSACancelAsyncRequest");

extern fn int wsa_cancel_blocking_call() @cname("WSACancelBlockingCall");

// FD_SET macros as functions (since C3 doesn't have macros)
extern fn void fd_clr(Socket fd, FdSet* set);
extern fn void fd_set(Socket fd, FdSet* set);
extern fn Bool fd_isset(Socket fd, FdSet* set);
extern fn void fd_zero(FdSet* set);

// Network event flags
const int FD_READ = 0x01;
const int FD_WRITE = 0x02;
const int FD_OOB = 0x04;
const int FD_ACCEPT = 0x08;
const int FD_CONNECT = 0x10;
const int FD_CLOSE = 0x20;
const int FD_QOS = 0x40;
const int FD_GROUP_QOS = 0x80;
const int FD_ROUTING_INTERFACE_CHANGE = 0x100;
const int FD_ADDRESS_LIST_CHANGE = 0x200;
const int FD_MAX_EVENTS = 10;

// AddrInfo flags
const int AI_PASSIVE = 0x00000001;
const int AI_CANONNAME = 0x00000002;
const int AI_NUMERICHOST = 0x00000004;
const int AI_NUMERICSERV = 0x00000008;
const int AI_ALL = 0x00000100;
const int AI_ADDRCONFIG = 0x00000400;
const int AI_V4MAPPED = 0x00000800;
const int AI_NON_AUTHORITATIVE = 0x00004000;
const int AI_SECURE = 0x00008000;
const int AI_RETURN_PREFERRED_NAMES = 0x00010000;
const int AI_FQDN = 0x00020000;
const int AI_FILESERVER = 0x00040000;

// Name info flags
const int NI_NOFQDN = 0x01;
const int NI_NUMERICHOST = 0x02;
const int NI_NAMEREQD = 0x04;
const int NI_NUMERICSERV = 0x08;
const int NI_DGRAM = 0x10;

// WSA error codes (common ones)
const int WSABASEERR = 10000;
const int WSAEINTR = 10004;
const int WSAEBADF = 10009;
const int WSAEACCES = 10013;
const int WSAEFAULT = 10014;
const int WSAEINVAL = 10022;
const int WSAEMFILE = 10024;
const int WSAEWOULDBLOCK = 10035;
const int WSAEINPROGRESS = 10036;
const int WSAEALREADY = 10037;
const int WSAENOTSOCK = 10038;
const int WSAEDESTADDRREQ = 10039;
const int WSAEMSGSIZE = 10040;
const int WSAEPROTOTYPE = 10041;
const int WSAENOPROTOOPT = 10042;
const int WSAEPROTONOSUPPORT = 10043;
const int WSAESOCKTNOSUPPORT = 10044;
const int WSAEOPNOTSUPP = 10045;
const int WSAEPFNOSUPPORT = 10046;
const int WSAEAFNOSUPPORT = 10047;
const int WSAEADDRINUSE = 10048;
const int WSAEADDRNOTAVAIL = 10049;
const int WSAENETDOWN = 10050;
const int WSAENETUNREACH = 10051;
const int WSAENETRESET = 10052;
const int WSAECONNABORTED = 10053;
const int WSAECONNRESET = 10054;
const int WSAENOBUFS = 10055;
const int WSAEISCONN = 10056;
const int WSAENOTCONN = 10057;
const int WSAESHUTDOWN = 10058;
const int WSAETOOMANYREFS = 10059;
const int WSAETIMEDOUT = 10060;
const int WSAECONNREFUSED = 10061;
const int WSAELOOP = 10062;
const int WSAENAMETOOLONG = 10063;
const int WSAEHOSTDOWN = 10064;
const int WSAEHOSTUNREACH = 10065;
const int WSAENOTEMPTY = 10066;
const int WSAEPROCLIM = 10067;
const int WSAEUSERS = 10068;
const int WSAEDQUOT = 10069;
const int WSAESTALE = 10070;
const int WSAEREMOTE = 10071;
const int WSASYSNOTREADY = 10091;
const int WSAVERNOTSUPPORTED = 10092;
const int WSANOTINITIALISED = 10093;
const int WSAEDISCON = 10101;
const int WSAENOMORE = 10102;
const int WSAECANCELLED = 10103;
const int WSAEINVALIDPROCTABLE = 10104;
const int WSAEINVALIDPROVIDER = 10105;
const int WSAEPROVIDERFAILEDINIT = 10106;
const int WSASYSCALLFAILURE = 10107;
const int WSASERVICE_NOT_FOUND = 10108;
const int WSATYPE_NOT_FOUND = 10109;
const int WSA_E_NO_MORE = 10110;
const int WSA_E_CANCELLED = 10111;
const int WSAEREFUSED = 10112;
const int WSAHOST_NOT_FOUND = 11001;
const int WSATRY_AGAIN = 11002;
const int WSANO_RECOVERY = 11003;
const int WSANO_DATA = 11004;
