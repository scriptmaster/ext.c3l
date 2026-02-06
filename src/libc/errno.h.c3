
// errno.h.c3

// Available functions
// errno(), set_errno()
// get_fault() == errno()+errno_to_fault()
// errno_to_fault()

module errno @if(env::WIN32);

// Common fault definition
faultdef E_ARG_TOO_BIG, E_ACCESS_DENIED, E_ADDR_IN_USE, E_ADDR_NOT_AVAIL, E_ADDR_FAMILY_NOT_SUPPORTED, E_AGAIN, E_ALREADY, E_BAD_FILE_DESC, E_BAD_MESSAGE, E_BUSY, E_CANCELED, E_NO_CHILD, E_CONN_ABORTED, E_CONN_REFUSED, E_CONN_RESET, E_DEADLOCK, E_DEST_ADDR_REQUIRED, E_DOMAIN, E_DISK_QUOTA, E_EXISTS, E_BAD_ADDRESS, E_FILE_TOO_BIG, E_HOST_DOWN, E_HOST_UNREACHABLE, E_ID_REMOVED, E_ILLEGAL_SEQUENCE, E_IN_PROGRESS, E_INTERRUPTED, E_INVALID, E_IO, E_IS_CONNECTED, E_IS_DIRECTORY, E_TOO_MANY_SYMLINKS, E_TOO_MANY_FILES, E_TOO_MANY_LINKS, E_MSG_TOO_LONG, E_NAME_TOO_LONG, E_NET_DOWN, E_NET_RESET, E_NET_UNREACHABLE, E_FILE_TABLE_OVERFLOW, E_NO_BUFFER, E_NO_DEVICE, E_NOT_FOUND, E_EXEC_FORMAT, E_NO_LOCK, E_NO_MEMORY, E_NO_MESSAGE, E_NO_PROTO_OPTION, E_NO_SPACE, E_NOT_IMPLEMENTED, E_NOT_BLOCK_DEVICE, E_NOT_CONNECTED, E_NOT_DIRECTORY, E_NOT_EMPTY, E_NOT_RECOVERABLE, E_NOT_SOCKET, E_NOT_TTY, E_NO_SUCH_DEVICE, E_OP_NOT_SUPPORTED, E_OVERFLOW, E_OWNER_DEAD, E_PERMISSION, E_PROTO_FAMILY_NOT_SUPPORTED, E_BROKEN_PIPE, E_PROTOCOL, E_PROTO_NOT_SUPPORTED, E_PROTO_WRONG_TYPE, E_OUT_OF_RANGE, E_REMOTE, E_READ_ONLY_FS, E_SHUTDOWN, E_SOCKET_TYPE_NOT_SUPPORTED, E_ILLEGAL_SEEK, E_NO_SUCH_PROCESS, E_STALE_HANDLE, E_TIMED_OUT, E_TOO_MANY_REFS, E_TEXT_BUSY, E_TOO_MANY_USERS, E_WOULD_BLOCK, E_CROSS_DEVICE, E_GENERAL_ERR;


fn fault get_fault() 
{
    return errno_to_fault(errno());
}

fn fault errno_to_fault(int err) 
{
    switch (err) {
        case E2BIG: return E_ARG_TOO_BIG;
        case EACCES: return E_ACCESS_DENIED;
        case EADDRINUSE: return E_ADDR_IN_USE;
        case EADDRNOTAVAIL: return E_ADDR_NOT_AVAIL;
        case EAFNOSUPPORT: return E_ADDR_FAMILY_NOT_SUPPORTED;
        case EAGAIN: return E_AGAIN;
        case EALREADY: return E_ALREADY;
        case EBADF: return E_BAD_FILE_DESC;
        case EBADMSG: return E_BAD_MESSAGE;
        case EBUSY: return E_BUSY;
        case ECANCELED: return E_CANCELED;
        case ECHILD: return E_NO_CHILD;
        case ECONNABORTED: return E_CONN_ABORTED;
        case ECONNREFUSED: return E_CONN_REFUSED;
        case ECONNRESET: return E_CONN_RESET;
        case EDEADLK: return E_DEADLOCK;
        case EDESTADDRREQ: return E_DEST_ADDR_REQUIRED;
        case EDOM: return E_DOMAIN;
        case EDQUOT: return E_DISK_QUOTA;
        case EEXIST: return E_EXISTS;
        case EFAULT: return E_BAD_ADDRESS;
        case EFBIG: return E_FILE_TOO_BIG;
        case EHOSTDOWN: return E_HOST_DOWN;
        case EHOSTUNREACH: return E_HOST_UNREACHABLE;
        case EIDRM: return E_ID_REMOVED;
        case EILSEQ: return E_ILLEGAL_SEQUENCE;
        case EINPROGRESS: return E_IN_PROGRESS;
        case EINTR: return E_INTERRUPTED;
        case EINVAL: return E_INVALID;
        case EIO: return E_IO;
        case EISCONN: return E_IS_CONNECTED;
        case EISDIR: return E_IS_DIRECTORY;
        case ELOOP: return E_TOO_MANY_SYMLINKS;
        case EMFILE: return E_TOO_MANY_FILES;
        case EMLINK: return E_TOO_MANY_LINKS;
        case EMSGSIZE: return E_MSG_TOO_LONG;
        case ENAMETOOLONG: return E_NAME_TOO_LONG;
        case ENETDOWN: return E_NET_DOWN;
        case ENETRESET: return E_NET_RESET;
        case ENETUNREACH: return E_NET_UNREACHABLE;
        case ENFILE: return E_FILE_TABLE_OVERFLOW;
        case ENOBUFS: return E_NO_BUFFER;
        case ENODEV: return E_NO_DEVICE;
        case ENOENT: return E_NOT_FOUND;
        case ENOEXEC: return E_EXEC_FORMAT;
        case ENOLCK: return E_NO_LOCK;
        case ENOMEM: return E_NO_MEMORY;
        case ENOMSG: return E_NO_MESSAGE;
        case ENOPROTOOPT: return E_NO_PROTO_OPTION;
        case ENOSPC: return E_NO_SPACE;
        case ENOSYS: return E_NOT_IMPLEMENTED;
        case ENOTBLK: return E_NOT_BLOCK_DEVICE;
        case ENOTCONN: return E_NOT_CONNECTED;
        case ENOTDIR: return E_NOT_DIRECTORY;
        case ENOTEMPTY: return E_NOT_EMPTY;
        case ENOTRECOVERABLE: return E_NOT_RECOVERABLE;
        case ENOTSOCK: return E_NOT_SOCKET;
        case ENOTTY: return E_NOT_TTY;
        case ENXIO: return E_NO_SUCH_DEVICE;
        case EOPNOTSUPP: return E_OP_NOT_SUPPORTED;
        case EOVERFLOW: return E_OVERFLOW;
        case EOWNERDEAD: return E_OWNER_DEAD;
        case EPERM: return E_PERMISSION;
        case EPFNOSUPPORT: return E_PROTO_FAMILY_NOT_SUPPORTED;
        case EPIPE: return E_BROKEN_PIPE;
        case EPROTO: return E_PROTOCOL;
        case EPROTONOSUPPORT: return E_PROTO_NOT_SUPPORTED;
        case EPROTOTYPE: return E_PROTO_WRONG_TYPE;
        case ERANGE: return E_OUT_OF_RANGE;
        case EREMOTE: return E_REMOTE;
        case EROFS: return E_READ_ONLY_FS;
        case ESHUTDOWN: return E_SHUTDOWN;
        case ESOCKTNOSUPPORT: return E_SOCKET_TYPE_NOT_SUPPORTED;
        case ESPIPE: return E_ILLEGAL_SEEK;
        case ESRCH: return E_NO_SUCH_PROCESS;
        case ESTALE: return E_STALE_HANDLE;
        case ETIMEDOUT: return E_TIMED_OUT;
        case ETOOMANYREFS: return E_TOO_MANY_REFS;
        case ETXTBSY: return E_TEXT_BUSY;
        case EUSERS: return E_TOO_MANY_USERS;
        case EWOULDBLOCK: return E_WOULD_BLOCK;
        case EXDEV: return E_CROSS_DEVICE;
        default: return E_GENERAL_ERR;
    }
}

// ========== Linux ==========

module errno @if(env::LINUX);

// Function Declarations
extern fn int* __errno_location() @cname("__errno_location");

// Inline helper to get errno value
fn int errno() @inline => *__errno_location();

// Inline helper to set errno value
fn void set_errno(int value) @inline { *__errno_location() = value; }

// Error number constants (POSIX + Linux extensions)

// Operation not permitted
const int EPERM = 1;
// No such file or directory
const int ENOENT = 2;
// No such process
const int ESRCH = 3;
// Interrupted system call
const int EINTR = 4;
// I/O error
const int EIO = 5;
// No such device or address
const int ENXIO = 6;
// Argument list too long
const int E2BIG = 7;
// Exec format error
const int ENOEXEC = 8;
// Bad file number
const int EBADF = 9;
// No child processes
const int ECHILD = 10;
// Try again
const int EAGAIN = 11;
// Out of memory
const int ENOMEM = 12;
// Permission denied
const int EACCES = 13;
// Bad address
const int EFAULT = 14;
// Block device required
const int ENOTBLK = 15;
// Device or resource busy
const int EBUSY = 16;
// File exists
const int EEXIST = 17;
// Cross-device link
const int EXDEV = 18;
// No such device
const int ENODEV = 19;
// Not a directory
const int ENOTDIR = 20;
// Is a directory
const int EISDIR = 21;
// Invalid argument
const int EINVAL = 22;
// File table overflow
const int ENFILE = 23;
// Too many open files
const int EMFILE = 24;
// Not a typewriter
const int ENOTTY = 25;
// Text file busy
const int ETXTBSY = 26;
// File too large
const int EFBIG = 27;
// No space left on device
const int ENOSPC = 28;
// Illegal seek
const int ESPIPE = 29;
// Read-only file system
const int EROFS = 30;
// Too many links
const int EMLINK = 31;
// Broken pipe
const int EPIPE = 32;
// Math argument out of domain of func
const int EDOM = 33;
// Math result not representable
const int ERANGE = 34;

// Resource deadlock would occur
const int EDEADLK = 35;
// File name too long
const int ENAMETOOLONG = 36;
// No record locks available
const int ENOLCK = 37;
// Function not implemented
const int ENOSYS = 38;
// Directory not empty
const int ENOTEMPTY = 39;
// Too many symbolic links encountered
const int ELOOP = 40;
// Operation would block (same as EAGAIN)
const int EWOULDBLOCK = 11;
// No message of desired type
const int ENOMSG = 42;
// Identifier removed
const int EIDRM = 43;
// Channel number out of range
const int ECHRNG = 44;
// Level 2 not synchronized
const int EL2NSYNC = 45;
// Level 3 halted
const int EL3HLT = 46;
// Level 3 reset
const int EL3RST = 47;
// Link number out of range
const int ELNRNG = 48;
// Protocol driver not attached
const int EUNATCH = 49;
// No CSI structure available
const int ENOCSI = 50;
// Level 2 halted
const int EL2HLT = 51;
// Invalid exchange
const int EBADE = 52;
// Invalid request descriptor
const int EBADR = 53;
// Exchange full
const int EXFULL = 54;
// No anode
const int ENOANO = 55;
// Invalid request code
const int EBADRQC = 56;
// Invalid slot
const int EBADSLT = 57;

const int EDEADLOCK = 35;

// Bad font file format
const int EBFONT = 59;
// Device not a stream
const int ENOSTR = 60;
// No data available
const int ENODATA = 61;
// Timer expired
const int ETIME = 62;
// Out of streams resources
const int ENOSR = 63;
// Machine is not on the network
const int ENONET = 64;
// Package not installed
const int ENOPKG = 65;
// Object is remote
const int EREMOTE = 66;
// Link has been severed
const int ENOLINK = 67;
// Advertise error
const int EADV = 68;
// Srmount error
const int ESRMNT = 69;
// Communication error on send
const int ECOMM = 70;
// Protocol error
const int EPROTO = 71;
// Multihop attempted
const int EMULTIHOP = 72;
// RFS specific error
const int EDOTDOT = 73;
// Not a data message
const int EBADMSG = 74;
// Value too large for defined data type
const int EOVERFLOW = 75;
// Name not unique on network
const int ENOTUNIQ = 76;
// File descriptor in bad state
const int EBADFD = 77;
// Remote address changed
const int EREMCHG = 78;
// Can not access a needed shared library
const int ELIBACC = 79;
// Accessing a corrupted shared library
const int ELIBBAD = 80;
// .lib section in a.out corrupted
const int ELIBSCN = 81;
// Attempting to link in too many shared libraries
const int ELIBMAX = 82;
// Cannot exec a shared library directly
const int ELIBEXEC = 83;
// Illegal byte sequence
const int EILSEQ = 84;
// Interrupted system call should be restarted
const int ERESTART = 85;
// Streams pipe error
const int ESTRPIPE = 86;
// Too many users
const int EUSERS = 87;
// Socket operation on non-socket
const int ENOTSOCK = 88;
// Destination address required
const int EDESTADDRREQ = 89;
// Message too long
const int EMSGSIZE = 90;
// Protocol wrong type for socket
const int EPROTOTYPE = 91;
// Protocol not available
const int ENOPROTOOPT = 92;
// Protocol not supported
const int EPROTONOSUPPORT = 93;
// Socket type not supported
const int ESOCKTNOSUPPORT = 94;
// Operation not supported on transport endpoint
const int EOPNOTSUPP = 95;
// Protocol family not supported
const int EPFNOSUPPORT = 96;
// Address family not supported by protocol
const int EAFNOSUPPORT = 97;
// Address already in use
const int EADDRINUSE = 98;
// Cannot assign requested address
const int EADDRNOTAVAIL = 99;
// Network is down
const int ENETDOWN = 100;
// Network is unreachable
const int ENETUNREACH = 101;
// Network dropped connection because of reset
const int ENETRESET = 102;
// Software caused connection abort
const int ECONNABORTED = 103;
// Connection reset by peer
const int ECONNRESET = 104;
// No buffer space available
const int ENOBUFS = 105;
// Transport endpoint is already connected
const int EISCONN = 106;
// Transport endpoint is not connected
const int ENOTCONN = 107;
// Cannot send after transport endpoint shutdown
const int ESHUTDOWN = 108;
// Too many references: cannot splice
const int ETOOMANYREFS = 109;
// Connection timed out
const int ETIMEDOUT = 110;
// Connection refused
const int ECONNREFUSED = 111;
// Host is down
const int EHOSTDOWN = 112;
// No route to host
const int EHOSTUNREACH = 113;
// Operation already in progress
const int EALREADY = 114;
// Operation now in progress
const int EINPROGRESS = 115;
// Stale file handle
const int ESTALE = 116;
// Structure needs cleaning
const int EUCLEAN = 117;
// Not a XENIX named type file
const int ENOTNAM = 118;
// No XENIX semaphores available
const int ENAVAIL = 119;
// Is a named type file
const int EISNAM = 120;
// Remote I/O error
const int EREMOTEIO = 121;
// Quota exceeded
const int EDQUOT = 122;
// No medium found
const int ENOMEDIUM = 123;
// Wrong medium type
const int EMEDIUMTYPE = 124;
// Operation Canceled
const int ECANCELED = 125;
// Required key not available
const int ENOKEY = 126;
// Key has expired
const int EKEYEXPIRED = 127;
// Key has been revoked
const int EKEYREVOKED = 128;
// Key was rejected by service
const int EKEYREJECTED = 129;

// for robust mutexes
// Owner died
const int EOWNERDEAD = 130;
// State not recoverable
const int ENOTRECOVERABLE = 131;

// Operation not possible due to RF-kill
const int ERFKILL = 132;

// Memory page has hardware error
const int EHWPOISON = 133;


// ========== macOS ==========

module errno @if(env::DARWIN);

// Function Declarations
extern fn int* __error() @cname("__error");

// Inline helper to get errno value
fn int errno() @inline => *__error();

// Inline helper to set errno value
fn void set_errno(int value) @inline { *__error() = value; }

// Error number constants (POSIX + macOS extensions)

const int EPERM = 1;
const int ENOENT = 2;
const int ESRCH = 3;
const int EINTR = 4;
const int EIO = 5;
const int ENXIO = 6;
const int E2BIG = 7;
const int ENOEXEC = 8;
const int EBADF = 9;
const int ECHILD = 10;
const int EDEADLK = 11;
const int ENOMEM = 12;
const int EACCES = 13;
const int EFAULT = 14;
const int ENOTBLK = 15;
const int EBUSY = 16;
const int EEXIST = 17;
const int EXDEV = 18;
const int ENODEV = 19;
const int ENOTDIR = 20;
const int EISDIR = 21;
const int EINVAL = 22;
const int ENFILE = 23;
const int EMFILE = 24;
const int ENOTTY = 25;
const int ETXTBSY = 26;
const int EFBIG = 27;
const int ENOSPC = 28;
const int ESPIPE = 29;
const int EROFS = 30;
const int EMLINK = 31;
const int EPIPE = 32;
const int EDOM = 33;
const int ERANGE = 34;
const int EAGAIN = 35;
const int EWOULDBLOCK = 35;
const int EINPROGRESS = 36;
const int EALREADY = 37;
const int ENOTSOCK = 38;
const int EDESTADDRREQ = 39;
const int EMSGSIZE = 40;
const int EPROTOTYPE = 41;
const int ENOPROTOOPT = 42;
const int EPROTONOSUPPORT = 43;
const int ESOCKTNOSUPPORT = 44;
const int ENOTSUP = 45;
const int EPFNOSUPPORT = 46;
const int EAFNOSUPPORT = 47;
const int EADDRINUSE = 48;
const int EADDRNOTAVAIL = 49;
const int ENETDOWN = 50;
const int ENETUNREACH = 51;
const int ENETRESET = 52;
const int ECONNABORTED = 53;
const int ECONNRESET = 54;
const int ENOBUFS = 55;
const int EISCONN = 56;
const int ENOTCONN = 57;
const int ESHUTDOWN = 58;
const int ETOOMANYREFS = 59;
const int ETIMEDOUT = 60;
const int ECONNREFUSED = 61;
const int ELOOP = 62;
const int ENAMETOOLONG = 63;
const int EHOSTDOWN = 64;
const int EHOSTUNREACH = 65;
const int ENOTEMPTY = 66;
const int EPROCLIM = 67;
const int EUSERS = 68;
const int EDQUOT = 69;
const int ESTALE = 70;
const int EREMOTE = 71;
const int EBADRPC = 72;
const int ERPCMISMATCH = 73;
const int EPROGUNAVAIL = 74;
const int EPROGMISMATCH = 75;
const int EPROCUNAVAIL = 76;
const int ENOLCK = 77;
const int ENOSYS = 78;
const int EFTYPE = 79;
const int EAUTH = 80;
const int ENEEDAUTH = 81;
const int EPWROFF = 82;
const int EDEVERR = 83;
const int EOVERFLOW = 84;
const int EBADEXEC = 85;
const int EBADARCH = 86;
const int ESHLIBVERS = 87;
const int EBADMACHO = 88;
const int ECANCELED = 89;
const int EIDRM = 90;
const int ENOMSG = 91;
const int EILSEQ = 92;
const int ENOATTR = 93;
const int EBADMSG = 94;
const int EMULTIHOP = 95;
const int ENODATA = 96;
const int ENOLINK = 97;
const int ENOSR = 98;
const int ENOSTR = 99;
const int EPROTO = 100;
const int ETIME = 101;
const int EOPNOTSUPP = 102;
const int ENOPOLICY = 103;
const int ENOTRECOVERABLE = 104;
const int EOWNERDEAD = 105;
const int EQFULL = 106;
const int ELAST = 106;


// ========== FreeBSD ==========

module errno @if(env::FREEBSD);

// Function Declarations
extern fn int* __error() @cname("__error");

// Inline helper to get errno value
fn int errno() @inline => *__error();

// Inline helper to set errno value
fn void set_errno(int value) @inline { *__error() = value; }

// Error number constants (POSIX + FreeBSD extensions)

const int EPERM = 1;
const int ENOENT = 2;
const int ESRCH = 3;
const int EINTR = 4;
const int EIO = 5;
const int ENXIO = 6;
const int E2BIG = 7;
const int ENOEXEC = 8;
const int EBADF = 9;
const int ECHILD = 10;
const int EDEADLK = 11;
const int ENOMEM = 12;
const int EACCES = 13;
const int EFAULT = 14;
const int ENOTBLK = 15;
const int EBUSY = 16;
const int EEXIST = 17;
const int EXDEV = 18;
const int ENODEV = 19;
const int ENOTDIR = 20;
const int EISDIR = 21;
const int EINVAL = 22;
const int ENFILE = 23;
const int EMFILE = 24;
const int ENOTTY = 25;
const int ETXTBSY = 26;
const int EFBIG = 27;
const int ENOSPC = 28;
const int ESPIPE = 29;
const int EROFS = 30;
const int EMLINK = 31;
const int EPIPE = 32;
const int EDOM = 33;
const int ERANGE = 34;
const int EAGAIN = 35;
const int EWOULDBLOCK = 35;
const int EINPROGRESS = 36;
const int EALREADY = 37;
const int ENOTSOCK = 38;
const int EDESTADDRREQ = 39;
const int EMSGSIZE = 40;
const int EPROTOTYPE = 41;
const int ENOPROTOOPT = 42;
const int EPROTONOSUPPORT = 43;
const int ESOCKTNOSUPPORT = 44;
const int EOPNOTSUPP = 45;
const int EPFNOSUPPORT = 46;
const int EAFNOSUPPORT = 47;
const int EADDRINUSE = 48;
const int EADDRNOTAVAIL = 49;
const int ENETDOWN = 50;
const int ENETUNREACH = 51;
const int ENETRESET = 52;
const int ECONNABORTED = 53;
const int ECONNRESET = 54;
const int ENOBUFS = 55;
const int EISCONN = 56;
const int ENOTCONN = 57;
const int ESHUTDOWN = 58;
const int ETOOMANYREFS = 59;
const int ETIMEDOUT = 60;
const int ECONNREFUSED = 61;
const int ELOOP = 62;
const int ENAMETOOLONG = 63;
const int EHOSTDOWN = 64;
const int EHOSTUNREACH = 65;
const int ENOTEMPTY = 66;
const int EPROCLIM = 67;
const int EUSERS = 68;
const int EDQUOT = 69;
const int ESTALE = 70;
const int EREMOTE = 71;
const int EBADRPC = 72;
const int ERPCMISMATCH = 73;
const int EPROGUNAVAIL = 74;
const int EPROGMISMATCH = 75;
const int EPROCUNAVAIL = 76;
const int ENOLCK = 77;
const int ENOSYS = 78;
const int EFTYPE = 79;
const int EAUTH = 80;
const int ENEEDAUTH = 81;
const int EIDRM = 82;
const int ENOMSG = 83;
const int EOVERFLOW = 84;
const int ECANCELED = 85;
const int EILSEQ = 86;
const int ENOATTR = 87;
const int EDOOFUS = 88;
const int EBADMSG = 89;
const int EMULTIHOP = 90;
const int ENOLINK = 91;
const int EPROTO = 92;
const int ENOTCAPABLE = 93;
const int ECAPMODE = 94;
const int ENOTRECOVERABLE = 95;
const int EOWNERDEAD = 96;
const int EINTEGRITY = 97;
const int ELAST = 97;


// ========== NetBSD ==========

module errno @if(env::NETBSD);

// Function Declarations
extern fn int* __errno() @cname("__errno");

// Inline helper to get errno value
fn int errno() @inline => *__errno();

// Inline helper to set errno value
fn void set_errno(int value) @inline { *__errno() = value; }

// Error number constants (POSIX + NetBSD extensions)

const int EPERM = 1;
const int ENOENT = 2;
const int ESRCH = 3;
const int EINTR = 4;
const int EIO = 5;
const int ENXIO = 6;
const int E2BIG = 7;
const int ENOEXEC = 8;
const int EBADF = 9;
const int ECHILD = 10;
const int EDEADLK = 11;
const int ENOMEM = 12;
const int EACCES = 13;
const int EFAULT = 14;
const int ENOTBLK = 15;
const int EBUSY = 16;
const int EEXIST = 17;
const int EXDEV = 18;
const int ENODEV = 19;
const int ENOTDIR = 20;
const int EISDIR = 21;
const int EINVAL = 22;
const int ENFILE = 23;
const int EMFILE = 24;
const int ENOTTY = 25;
const int ETXTBSY = 26;
const int EFBIG = 27;
const int ENOSPC = 28;
const int ESPIPE = 29;
const int EROFS = 30;
const int EMLINK = 31;
const int EPIPE = 32;
const int EDOM = 33;
const int ERANGE = 34;
const int EAGAIN = 35;
const int EWOULDBLOCK = 35;
const int EINPROGRESS = 36;
const int EALREADY = 37;
const int ENOTSOCK = 38;
const int EDESTADDRREQ = 39;
const int EMSGSIZE = 40;
const int EPROTOTYPE = 41;
const int ENOPROTOOPT = 42;
const int EPROTONOSUPPORT = 43;
const int ESOCKTNOSUPPORT = 44;
const int EOPNOTSUPP = 45;
const int EPFNOSUPPORT = 46;
const int EAFNOSUPPORT = 47;
const int EADDRINUSE = 48;
const int EADDRNOTAVAIL = 49;
const int ENETDOWN = 50;
const int ENETUNREACH = 51;
const int ENETRESET = 52;
const int ECONNABORTED = 53;
const int ECONNRESET = 54;
const int ENOBUFS = 55;
const int EISCONN = 56;
const int ENOTCONN = 57;
const int ESHUTDOWN = 58;
const int ETOOMANYREFS = 59;
const int ETIMEDOUT = 60;
const int ECONNREFUSED = 61;
const int ELOOP = 62;
const int ENAMETOOLONG = 63;
const int EHOSTDOWN = 64;
const int EHOSTUNREACH = 65;
const int ENOTEMPTY = 66;
const int EPROCLIM = 67;
const int EUSERS = 68;
const int EDQUOT = 69;
const int ESTALE = 70;
const int EREMOTE = 71;
const int EBADRPC = 72;
const int ERPCMISMATCH = 73;
const int EPROGUNAVAIL = 74;
const int EPROGMISMATCH = 75;
const int EPROCUNAVAIL = 76;
const int ENOLCK = 77;
const int ENOSYS = 78;
const int EFTYPE = 79;
const int EAUTH = 80;
const int ENEEDAUTH = 81;
const int EIDRM = 82;
const int ENOMSG = 83;
const int EOVERFLOW = 84;
const int EILSEQ = 85;
const int ENOTSUP = 86;
const int ECANCELED = 87;
const int EBADMSG = 88;
const int ENODATA = 89;
const int ENOSR = 90;
const int ENOSTR = 91;
const int ETIME = 92;
const int ENOATTR = 93;
const int EMULTIHOP = 94;
const int ENOLINK = 95;
const int EPROTO = 96;
const int EOWNERDEAD = 97;
const int ENOTRECOVERABLE = 98;
const int ELAST = 98;


// ========== OpenBSD ==========

module errno @if(env::OPENBSD);

// Function Declarations
extern fn int* __errno() @cname("__errno");

// Inline helper to get errno value
fn int errno() @inline => *__errno();

// Inline helper to set errno value
fn void set_errno(int value) @inline { *__errno() = value; }

// Error number constants (POSIX + OpenBSD extensions)

const int EPERM = 1;
const int ENOENT = 2;
const int ESRCH = 3;
const int EINTR = 4;
const int EIO = 5;
const int ENXIO = 6;
const int E2BIG = 7;
const int ENOEXEC = 8;
const int EBADF = 9;
const int ECHILD = 10;
const int EDEADLK = 11;
const int ENOMEM = 12;
const int EACCES = 13;
const int EFAULT = 14;
const int ENOTBLK = 15;
const int EBUSY = 16;
const int EEXIST = 17;
const int EXDEV = 18;
const int ENODEV = 19;
const int ENOTDIR = 20;
const int EISDIR = 21;
const int EINVAL = 22;
const int ENFILE = 23;
const int EMFILE = 24;
const int ENOTTY = 25;
const int ETXTBSY = 26;
const int EFBIG = 27;
const int ENOSPC = 28;
const int ESPIPE = 29;
const int EROFS = 30;
const int EMLINK = 31;
const int EPIPE = 32;
const int EDOM = 33;
const int ERANGE = 34;
const int EAGAIN = 35;
const int EWOULDBLOCK = 35;
const int EINPROGRESS = 36;
const int EALREADY = 37;
const int ENOTSOCK = 38;
const int EDESTADDRREQ = 39;
const int EMSGSIZE = 40;
const int EPROTOTYPE = 41;
const int ENOPROTOOPT = 42;
const int EPROTONOSUPPORT = 43;
const int ESOCKTNOSUPPORT = 44;
const int EOPNOTSUPP = 45;
const int EPFNOSUPPORT = 46;
const int EAFNOSUPPORT = 47;
const int EADDRINUSE = 48;
const int EADDRNOTAVAIL = 49;
const int ENETDOWN = 50;
const int ENETUNREACH = 51;
const int ENETRESET = 52;
const int ECONNABORTED = 53;
const int ECONNRESET = 54;
const int ENOBUFS = 55;
const int EISCONN = 56;
const int ENOTCONN = 57;
const int ESHUTDOWN = 58;
const int ETOOMANYREFS = 59;
const int ETIMEDOUT = 60;
const int ECONNREFUSED = 61;
const int ELOOP = 62;
const int ENAMETOOLONG = 63;
const int EHOSTDOWN = 64;
const int EHOSTUNREACH = 65;
const int ENOTEMPTY = 66;
const int EPROCLIM = 67;
const int EUSERS = 68;
const int EDQUOT = 69;
const int ESTALE = 70;
const int EREMOTE = 71;
const int EBADRPC = 72;
const int ERPCMISMATCH = 73;
const int EPROGUNAVAIL = 74;
const int EPROGMISMATCH = 75;
const int EPROCUNAVAIL = 76;
const int ENOLCK = 77;
const int ENOSYS = 78;
const int EFTYPE = 79;
const int EAUTH = 80;
const int ENEEDAUTH = 81;
const int EIPSEC = 82;
const int ENOATTR = 83;
const int EILSEQ = 84;
const int ENOMEDIUM = 85;
const int EMEDIUMTYPE = 86;
const int EOVERFLOW = 87;
const int ECANCELED = 88;
const int EIDRM = 89;
const int ENOMSG = 90;
const int ENOTSUP = 91;
const int EBADMSG = 92;
const int ENOTRECOVERABLE = 93;
const int EOWNERDEAD = 94;
const int EPROTO = 95;
const int ELAST = 95;





/*
import errno;

fn void? open_file(String filename) {
    int fd = open(filename.ptr, O_RDONLY);
    if (fd < 0) {
        return errno::errno_fault()~;
    }
    defer close(fd);
    // ...
}


fn void? connect_socket(String host, int port) {
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        return errno::errno_fault()~;
    }
    
    // ...
    
    if (connect(sockfd, &addr, sizeof(addr)) < 0) {
        int err = errno::errno();
        close(sockfd);
        return errno::errno_to_fault(err)~;
    }
    
    return sockfd;
}

fn int? read_nonblocking(int fd, char[] buffer) {
    int bytes = read(fd, buffer.ptr, buffer.len);
    if (bytes < 0) {
        fault f = errno::errno_fault();
        if (f == errno::E_AGAIN || f == errno::E_WOULD_BLOCK) {
            return 0; 
        }
        return f~;
    }
    return bytes;
}

fn void? handle_file_operation(String path) {
    int fd = open(path.ptr, O_RDWR);
    if (fd < 0) {
        fault f = errno::errno_fault();
        switch (f) {
            case errno::E_NOT_FOUND:
                io::printfn("File not found: %s", path);
            case errno::E_ACCESS_DENIED:
                io::printfn("Permission denied: %s", path);
            case errno::E_IS_DIRECTORY:
                io::printfn("Is a directory: %s", path);
            case errno::E_TOO_MANY_FILES:
                io::printfn("Too many open files");
            default:
                io::printfn("Unknown error: %d", errno::errno());
        }
        return f~;
    }
    defer close(fd);
    // ... 
}
*/

/*
import errno;

fn void test_file_operation()
{
    int fd = open("nonexistent.txt", O_RDONLY);
    if (fd < 0) {
        int err = errno::errno();
        if (err == errno::ENOENT) {
            io::printn("File not found!");
        } else if (err == errno::EACCES) {
            io::printn("Permission denied!");
        }
    }
}
*/
