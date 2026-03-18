// sys.epoll.h.c3

module c::sys::epoll @if(env::LINUX);

// epoll_data union: holds user data associated with an event
union EpollData {
    void* ptr;   // Pointer to user data
    int   fd;    // File descriptor
    uint  u32;   // 32-bit integer
    ulong u64;   // 64-bit integer
}

// epoll_event structure (packed on x86_64)
struct EpollEvent @packed 
{
    uint      events;  // Epoll events bitmask
    EpollData data;    // User data variable
}

// Function Declarations
extern fn int epoll_create(int size);
extern fn int epoll_create1(int flags);
extern fn int epoll_ctl(int epfd, int op, int fd, EpollEvent* event);
extern fn int epoll_wait(int epfd, EpollEvent* events, int maxevents, int timeout);
extern fn int epoll_pwait(int epfd, EpollEvent* events, int maxevents, int timeout, void* sigmask);
extern fn int epoll_pwait2(int epfd, EpollEvent* events, int maxevents, TimeSpec* timeout, void* sigmask);

// TimeSpec for epoll_pwait2
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// epoll_create1() flags
const int EPOLL_CLOEXEC = 0x80000;  // Set close-on-exec flag on the epoll fd

// epoll_ctl() operations
const int EPOLL_CTL_ADD = 1;  // Add a file descriptor to epoll
const int EPOLL_CTL_DEL = 2;  // Remove a file descriptor from epoll
const int EPOLL_CTL_MOD = 3;  // Change event for a file descriptor

// Event types for events bitmask
const uint EPOLLIN      = 0x00000001;  // Available for read
const uint EPOLLPRI     = 0x00000002;  // Urgent data available for read
const uint EPOLLOUT     = 0x00000004;  // Available for write
const uint EPOLLERR     = 0x00000008;  // Error condition (always monitored)
const uint EPOLLHUP     = 0x00000010;  // Hang up (always monitored)
const uint EPOLLRDNORM  = 0x00000040;  // Normal data may be read
const uint EPOLLRDBAND  = 0x00000080;  // Priority data may be read
const uint EPOLLWRNORM  = 0x00000100;  // Writing now will not block
const uint EPOLLWRBAND  = 0x00000200;  // Priority data may be written
const uint EPOLLMSG     = 0x00000400;  // Message available (unused)
const uint EPOLLRDHUP   = 0x00002000;  // Stream socket peer closed connection or half-closed write end

// Flags (upper bits)
const uint EPOLLEXCLUSIVE = 0x10000000;  // Exclusive wakeup (since Linux 4.5)
const uint EPOLLWAKEUP    = 0x20000000;  // Prevent system suspend while event is pending (since Linux 3.5)
const uint EPOLLONESHOT   = 0x40000000;  // One-shot behavior: disable after event fires
const uint EPOLLET        = 0x80000000;  // Edge-triggered behavior (default is level-triggered)

