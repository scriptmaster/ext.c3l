// poll.h.c3

module poll;

// ========== Linux ==========

module poll @if(env::LINUX);

// Structure for poll()
struct PollFd {
    int fd;         // File descriptor
    short events;   // Requested events
    short revents;  // Returned events
}

// Function Declarations
extern fn int poll(PollFd* fds, ulong nfds, int timeout);
extern fn int ppoll(PollFd* fds, ulong nfds, TimeSpec* timeout, void* sigmask);

// TimeSpec for ppoll
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Event types for events and revents
const short POLLIN = 0x0001;        // Data available to read
const short POLLPRI = 0x0002;       // High priority data available
const short POLLOUT = 0x0004;       // Ready for writing
const short POLLERR = 0x0008;       // Error condition (revents only)
const short POLLHUP = 0x0010;       // Hang up (revents only)
const short POLLNVAL = 0x0020;      // Invalid request (revents only)

// Linux-specific extensions
const short POLLRDNORM = 0x0040;    // Normal data may be read
const short POLLRDBAND = 0x0080;    // Priority data may be read
const short POLLWRNORM = 0x0100;    // Writing now will not block
const short POLLWRBAND = 0x0200;    // Priority data may be written
const short POLLMSG = 0x0400;       // Message available
const short POLLREMOVE = 0x1000;    // Remove from poll set
const short POLLRDHUP = 0x2000;     // Stream socket peer closed connection

// Infinite timeout
const int INFTIM = -1;

// ========== Darwin (macOS) ==========

module poll @if(env::DARWIN);

// Structure for poll()
struct PollFd {
    int fd;
    short events;
    short revents;
}

// Function Declarations
extern fn int poll(PollFd* fds, uint nfds, int timeout);

// Event types
const short POLLIN = 0x0001;
const short POLLPRI = 0x0002;
const short POLLOUT = 0x0004;
const short POLLRDNORM = 0x0040;
const short POLLWRNORM = 0x0004;
const short POLLRDBAND = 0x0080;
const short POLLWRBAND = 0x0100;
const short POLLEXTEND = 0x0200;
const short POLLATTRIB = 0x0400;
const short POLLNLINK = 0x0800;
const short POLLWRITE = 0x1000;
const short POLLERR = 0x0008;
const short POLLHUP = 0x0010;
const short POLLNVAL = 0x0020;

// Darwin-specific
const short POLLSTANDARD = (POLLIN | POLLPRI | POLLOUT | POLLRDNORM | POLLRDBAND | POLLWRBAND | POLLWRNORM);

// Infinite timeout
const int INFTIM = -1;

// ========== FreeBSD ==========

module poll @if(env::FREEBSD);

// Structure for poll()
struct PollFd {
    int fd;
    short events;
    short revents;
}

// Function Declarations
extern fn int poll(PollFd* fds, uint nfds, int timeout);
extern fn int ppoll(PollFd* fds, uint nfds, TimeSpec* timeout, void* sigmask);

struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Event types
const short POLLIN = 0x0001;
const short POLLPRI = 0x0002;
const short POLLOUT = 0x0004;
const short POLLRDNORM = 0x0040;
const short POLLWRNORM = 0x0004;
const short POLLRDBAND = 0x0080;
const short POLLWRBAND = 0x0100;
const short POLLINIGNEOF = 0x2000;
const short POLLERR = 0x0008;
const short POLLHUP = 0x0010;
const short POLLNVAL = 0x0020;

// FreeBSD-specific
const short POLLSTANDARD = (POLLIN | POLLPRI | POLLOUT | POLLRDNORM | POLLRDBAND | POLLWRBAND | POLLWRNORM);

// Infinite timeout
const int INFTIM = -1;

// ========== NetBSD ==========

module poll @if(env::NETBSD);

// Structure for poll()
struct PollFd {
    int fd;
    short events;
    short revents;
}

// Function Declarations
extern fn int poll(PollFd* fds, uint nfds, int timeout);
extern fn int pollts(PollFd* fds, uint nfds, TimeSpec* timeout, void* sigmask);

struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Event types
const short POLLIN = 0x0001;
const short POLLPRI = 0x0002;
const short POLLOUT = 0x0004;
const short POLLRDNORM = 0x0040;
const short POLLWRNORM = 0x0004;
const short POLLRDBAND = 0x0080;
const short POLLWRBAND = 0x0100;
const short POLLERR = 0x0008;
const short POLLHUP = 0x0010;
const short POLLNVAL = 0x0020;

// NetBSD-specific
const short POLLSTANDARD = (POLLIN | POLLPRI | POLLOUT | POLLRDNORM | POLLRDBAND | POLLWRBAND | POLLWRNORM);

// Infinite timeout
const int INFTIM = -1;

// ========== OpenBSD ==========

module poll @if(env::OPENBSD);

// Structure for poll()
struct PollFd {
    int fd;
    short events;
    short revents;
}

// Function Declarations
extern fn int poll(PollFd* fds, uint nfds, int timeout);
extern fn int ppoll(PollFd* fds, uint nfds, TimeSpec* timeout, void* sigmask);

struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Event types
const short POLLIN = 0x0001;
const short POLLPRI = 0x0002;
const short POLLOUT = 0x0004;
const short POLLRDNORM = 0x0040;
const short POLLWRNORM = 0x0004;
const short POLLRDBAND = 0x0080;
const short POLLWRBAND = 0x0100;
const short POLLERR = 0x0008;
const short POLLHUP = 0x0010;
const short POLLNVAL = 0x0020;

// OpenBSD-specific
const short POLLSTANDARD = (POLLIN | POLLPRI | POLLOUT | POLLRDNORM | POLLRDBAND | POLLWRBAND | POLLWRNORM);

// Infinite timeout
const int INFTIM = -1;

// ========== Windows ==========

module poll @if(env::WIN32);

// Windows does not have poll() natively
// However, WSAPoll() is available (Windows Vista+)
// For compatibility, MinGW/Cygwin may provide poll()

// Structure for poll() (if available through compatibility layer)
struct PollFd {
    int fd;
    short events;
    short revents;
}

// Function Declaration (WSAPoll or compatibility layer)
extern fn int poll(PollFd* fds, ulong nfds, int timeout);

// Windows WSAPoll uses similar constants
const short POLLIN = 0x0001;
const short POLLPRI = 0x0002;
const short POLLOUT = 0x0004;
const short POLLERR = 0x0008;
const short POLLHUP = 0x0010;
const short POLLNVAL = 0x0020;

// For native Windows WSAPoll, include winsock2.h and use:
// int WSAAPI WSAPoll(WSAPOLLFD *fdArray, ULONG fds, INT timeout);
// WSAPOLLFD is similar to pollfd

// Infinite timeout
const int INFTIM = -1;

// Note: For production Windows code, consider using:
// 1. WSAPoll() from winsock2.h (for sockets only)
// 2. WaitForMultipleObjects() for general handles
// 3. IOCP (I/O Completion Ports) for high-performance
// 4. select() for cross-platform compatibility
