// sys.event.h.c3

module c::sys::event;

// ========== Linux ==========

module c::sys::event @if(env::LINUX);

// kqueue is not available on Linux.
// Use epoll(7) instead for equivalent event notification.
// See: sys/epoll.h

// ========== Darwin (macOS) ==========

module c::sys::event @if(env::DARWIN);

// Filter identifiers (for kevent.filter)
const short EVFILT_READ     = -1;   // Descriptor ready for read
const short EVFILT_WRITE    = -2;   // Descriptor ready for write
const short EVFILT_AIO      = -3;   // Attached aio requests completed
const short EVFILT_VNODE    = -4;   // File system events
const short EVFILT_PROC     = -5;   // Process state changes
const short EVFILT_SIGNAL   = -6;   // Signals delivered to process
const short EVFILT_TIMER    = -7;   // Timers
const short EVFILT_MACHPORT = -8;   // Mach port events (Darwin-specific)
const short EVFILT_FS       = -9;   // File system events (Darwin-specific)
const short EVFILT_USER     = -10;  // User-defined filter (Darwin-specific)
const short EVFILT_VM       = -12;  // Virtual memory events (Darwin-specific)
const short EVFILT_EXCEPT   = -15;  // Exceptional conditions (Darwin-specific)
const short EVFILT_SYSCOUNT = 17;   // Number of filters

// Actions (for kevent.flags)
const ushort EV_ADD      = 0x0001;  // Add event to kqueue
const ushort EV_DELETE   = 0x0002;  // Remove event from kqueue
const ushort EV_ENABLE   = 0x0004;  // Enable event
const ushort EV_DISABLE  = 0x0008;  // Disable event (not removed)

// Flags (for kevent.flags)
const ushort EV_ONESHOT  = 0x0010;  // Fire only once, then remove
const ushort EV_CLEAR    = 0x0020;  // Clear event state after delivery
const ushort EV_RECEIPT  = 0x0040;  // Force EV_ERROR on success (batch changes)
const ushort EV_DISPATCH = 0x0080;  // Disable event after delivery
const ushort EV_UDATA_SPECIFIC = 0x0100; // Only match if udata matches (Darwin-specific)

// Return flags (set by kernel in kevent.flags)
const ushort EV_EOF      = 0x8000;  // EOF detected
const ushort EV_ERROR    = 0x4000;  // Error: data contains errno

// EVFILT_VNODE fflags
const uint NOTE_DELETE   = 0x00000001;  // File was deleted
const uint NOTE_WRITE    = 0x00000002;  // File was written to
const uint NOTE_EXTEND   = 0x00000004;  // File was extended in size
const uint NOTE_ATTRIB   = 0x00000008;  // File attributes changed
const uint NOTE_LINK     = 0x00000010;  // File link count changed
const uint NOTE_RENAME   = 0x00000020;  // File was renamed
const uint NOTE_REVOKE   = 0x00000040;  // File access was revoked
const uint NOTE_NONE     = 0x00000080;  // No note (Darwin-specific)
const uint NOTE_FUNLOCK  = 0x00000100;  // File was unlocked (Darwin-specific)

// EVFILT_PROC fflags
const uint NOTE_EXIT     = 0x80000000;  // Process exited
const uint NOTE_FORK     = 0x40000000;  // Process forked
const uint NOTE_EXEC     = 0x20000000;  // Process exec'd new image
const uint NOTE_SIGNAL   = 0x08000000;  // Signal was delivered to child
const uint NOTE_EXITSTATUS = 0x04000000; // Exit status included in data (Darwin-specific)
const uint NOTE_EXIT_DETAIL = 0x02000000; // Exit detail flags in data (Darwin-specific)

// EVFILT_TIMER fflags (time unit)
const uint NOTE_SECONDS    = 0x00000001;  // data is in seconds
const uint NOTE_USECONDS   = 0x00000002;  // data is in microseconds
const uint NOTE_NSECONDS   = 0x00000004;  // data is in nanoseconds
const uint NOTE_MACHTIME   = 0x00000008;  // data is in Mach absolute time units (Darwin-specific)
const uint NOTE_ABSOLUTE   = 0x00000008;  // data is absolute timeout (Darwin-specific, alias)
const uint NOTE_LEEWAY     = 0x00000010;  // ext[1] holds leeway for timer coalescing (Darwin-specific)
const uint NOTE_CRITICAL   = 0x00000020;  // system will not defer this timer (Darwin-specific)
const uint NOTE_BACKGROUND = 0x00000040;  // system may defer this timer aggressively (Darwin-specific)

// EVFILT_USER fflags
const uint NOTE_FFNOP      = 0x00000000;  // No operation
const uint NOTE_FFAND      = 0x40000000;  // AND fflags
const uint NOTE_FFOR       = 0x80000000;  // OR fflags
const uint NOTE_FFCOPY     = 0xc0000000;  // Copy fflags
const uint NOTE_FFCTRLMASK = 0xc0000000;  // Control mask for fflags
const uint NOTE_FFLAGSMASK = 0x00ffffff;  // User-defined flags mask
const uint NOTE_TRIGGER    = 0x01000000;  // Activate the event

// kevent structure
struct Kevent {
    ulong  ident;   // Identifier for this event (fd, pid, signal, etc.)
    short  filter;  // Filter type (EVFILT_*)
    ushort flags;   // Action / return flags (EV_*)
    uint   fflags;  // Filter-specific flags (NOTE_*)
    long   data;    // Filter-specific data
    void*  udata;   // Opaque user data
}

// kevent64 structure (Darwin-specific, 64-bit extended)
struct Kevent64 {
    ulong  ident;
    short  filter;
    ushort flags;
    uint   fflags;
    long   data;
    ulong  udata;
    ulong[2] ext;
}

macro ev_set(kevp, a, b, c, d, e, f) {
    Kevent *__kevp__ = (kevp);
    __kevp__.ident = (a);
    __kevp__.filter = (b);
    __kevp__.flags = (c);
    __kevp__.fflags = (d);
    __kevp__.data = (e);
    __kevp__.udata = (f);
}

// Function Declarations
extern fn int kqueue();
extern fn int kevent(int kq, Kevent* changelist, int nchanges, Kevent* eventlist, int nevents, TimeSpec* timeout);
extern fn int kevent64(int kq, Kevent64* changelist, int nchanges, Kevent64* eventlist, int nevents, uint flags, TimeSpec* timeout);

// TimeSpec
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// ========== FreeBSD ==========

module c::sys::event @if(env::FREEBSD);

// Filter identifiers
const short EVFILT_READ     = -1;
const short EVFILT_WRITE    = -2;
const short EVFILT_AIO      = -3;
const short EVFILT_VNODE    = -4;
const short EVFILT_PROC     = -5;
const short EVFILT_SIGNAL   = -6;
const short EVFILT_TIMER    = -7;
const short EVFILT_PROCDESC = -8;   // Process descriptor events (FreeBSD-specific)
const short EVFILT_FS       = -9;
const short EVFILT_LIO      = -10;  // Listio completion (FreeBSD-specific)
const short EVFILT_USER     = -11;
const short EVFILT_SENDFILE = -12;  // sendfile() completion (FreeBSD-specific)
const short EVFILT_EMPTY    = -13;  // Empty send buffer (FreeBSD-specific)
const short EVFILT_SYSCOUNT = 13;

// Actions
const ushort EV_ADD      = 0x0001;
const ushort EV_DELETE   = 0x0002;
const ushort EV_ENABLE   = 0x0004;
const ushort EV_DISABLE  = 0x0008;

// Flags
const ushort EV_ONESHOT  = 0x0010;
const ushort EV_CLEAR    = 0x0020;
const ushort EV_RECEIPT  = 0x0040;
const ushort EV_DISPATCH = 0x0080;
const ushort EV_DROP     = 0x1000;  // FreeBSD-specific: drop event if queue full
const ushort EV_FLAG1    = 0x2000;  // FreeBSD-specific: filter flag

// Return flags
const ushort EV_EOF      = 0x8000;
const ushort EV_ERROR    = 0x4000;

// EVFILT_VNODE fflags
const uint NOTE_DELETE   = 0x00000001;
const uint NOTE_WRITE    = 0x00000002;
const uint NOTE_EXTEND   = 0x00000004;
const uint NOTE_ATTRIB   = 0x00000008;
const uint NOTE_LINK     = 0x00000010;
const uint NOTE_RENAME   = 0x00000020;
const uint NOTE_REVOKE   = 0x00000040;
const uint NOTE_OPEN     = 0x00000080;  // File was opened (FreeBSD-specific)
const uint NOTE_CLOSE    = 0x00000100;  // File was closed (not write) (FreeBSD-specific)
const uint NOTE_CLOSE_WRITE = 0x00000200; // File was closed after write (FreeBSD-specific)
const uint NOTE_READ     = 0x00000400;  // File was read (FreeBSD-specific)

// EVFILT_PROC fflags
const uint NOTE_EXIT     = 0x80000000;
const uint NOTE_FORK     = 0x40000000;
const uint NOTE_EXEC     = 0x20000000;
const uint NOTE_PCTRLMASK = 0xf0000000;
const uint NOTE_PDATAMASK = 0x000fffff;
const uint NOTE_TRACK    = 0x00000001;  // Follow child across fork (FreeBSD-specific)
const uint NOTE_TRACKERR = 0x00000002;  // Track failed (FreeBSD-specific)
const uint NOTE_CHILD    = 0x00000004;  // Returned on child process (FreeBSD-specific)

// EVFILT_TIMER fflags
const uint NOTE_SECONDS  = 0x00000001;
const uint NOTE_MSECONDS = 0x00000002;  // data is in milliseconds (FreeBSD-specific)
const uint NOTE_USECONDS = 0x00000004;
const uint NOTE_NSECONDS = 0x00000008;
const uint NOTE_ABSTIME  = 0x00000010;  // data is absolute timeout (FreeBSD-specific)

// EVFILT_USER fflags
const uint NOTE_FFNOP      = 0x00000000;
const uint NOTE_FFAND      = 0x40000000;
const uint NOTE_FFOR       = 0x80000000;
const uint NOTE_FFCOPY     = 0xc0000000;
const uint NOTE_FFCTRLMASK = 0xc0000000;
const uint NOTE_FFLAGSMASK = 0x00ffffff;
const uint NOTE_TRIGGER    = 0x01000000;

// kevent structure
struct Kevent {
    ulong  ident;
    short  filter;
    ushort flags;
    uint   fflags;
    long   data;
    void*  udata;
}

macro ev_set(kevp, a, b, c, d, e, f) {
    Kevent *__kevp__ = (kevp);
    __kevp__.ident = (a);
    __kevp__.filter = (b);
    __kevp__.flags = (c);
    __kevp__.fflags = (d);
    __kevp__.data = (e);
    __kevp__.udata = (f);
}

// Function Declarations
extern fn int kqueue();
extern fn int kevent(int kq, Kevent* changelist, int nchanges, Kevent* eventlist, int nevents, TimeSpec* timeout);

// TimeSpec
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// ========== NetBSD ==========

module c::sys::event @if(env::NETBSD);

// Filter identifiers
const short EVFILT_READ     = 0;
const short EVFILT_WRITE    = 1;
const short EVFILT_AIO      = 2;
const short EVFILT_VNODE    = 3;
const short EVFILT_PROC     = 4;
const short EVFILT_SIGNAL   = 5;
const short EVFILT_TIMER    = 6;
const short EVFILT_SYSCOUNT = 7;

// Actions
const ushort EV_ADD      = 0x0001;
const ushort EV_DELETE   = 0x0002;
const ushort EV_ENABLE   = 0x0004;
const ushort EV_DISABLE  = 0x0008;

// Flags
const ushort EV_ONESHOT  = 0x0010;
const ushort EV_CLEAR    = 0x0020;
const ushort EV_RECEIPT  = 0x0040;
const ushort EV_DISPATCH = 0x0080;
const ushort EV_SYSFLAGS = 0xf000;
const ushort EV_FLAG1    = 0x2000;

// Return flags
const ushort EV_EOF      = 0x8000;
const ushort EV_ERROR    = 0x4000;

// EVFILT_VNODE fflags
const uint NOTE_DELETE   = 0x00000001;
const uint NOTE_WRITE    = 0x00000002;
const uint NOTE_EXTEND   = 0x00000004;
const uint NOTE_ATTRIB   = 0x00000008;
const uint NOTE_LINK     = 0x00000010;
const uint NOTE_RENAME   = 0x00000020;
const uint NOTE_REVOKE   = 0x00000040;

// EVFILT_PROC fflags
const uint NOTE_EXIT     = 0x80000000;
const uint NOTE_FORK     = 0x40000000;
const uint NOTE_EXEC     = 0x20000000;
const uint NOTE_PCTRLMASK = 0xf0000000;
const uint NOTE_PDATAMASK = 0x000fffff;
const uint NOTE_TRACK    = 0x00000001;
const uint NOTE_TRACKERR = 0x00000002;
const uint NOTE_CHILD    = 0x00000004;

// EVFILT_TIMER fflags
const uint NOTE_SECONDS  = 0x00000001;
const uint NOTE_USECONDS = 0x00000002;
const uint NOTE_NSECONDS = 0x00000004;
const uint NOTE_ABSTIME  = 0x00000008;

// kevent structure
struct Kevent {
    ulong  ident;
    uint   filter;   // NetBSD uses uint for filter
    uint   flags;    // NetBSD uses uint for flags
    uint   fflags;
    long   data;
    void*  udata;
}

macro ev_set(kevp, a, b, c, d, e, f) {
    Kevent *__kevp__ = (kevp);
    __kevp__.ident = (a);
    __kevp__.filter = (b);
    __kevp__.flags = (c);
    __kevp__.fflags = (d);
    __kevp__.data = (e);
    __kevp__.udata = (f);
}


// Function Declarations
extern fn int kqueue();
extern fn int kevent(int kq, Kevent* changelist, int nchanges, Kevent* eventlist, int nevents, TimeSpec* timeout);

// TimeSpec
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// ========== OpenBSD ==========

module c::sys::event @if(env::OPENBSD);

// Filter identifiers
const short EVFILT_READ     = -1;
const short EVFILT_WRITE    = -2;
const short EVFILT_AIO      = -3;
const short EVFILT_VNODE    = -4;
const short EVFILT_PROC     = -5;
const short EVFILT_SIGNAL   = -6;
const short EVFILT_TIMER    = -7;
const short EVFILT_DEVICE   = -8;   // Device events (OpenBSD-specific)
const short EVFILT_EXCEPT   = -9;   // Exceptional conditions (OpenBSD-specific)
const short EVFILT_SYSCOUNT = 9;

// Actions
const ushort EV_ADD      = 0x0001;
const ushort EV_DELETE   = 0x0002;
const ushort EV_ENABLE   = 0x0004;
const ushort EV_DISABLE  = 0x0008;

// Flags
const ushort EV_ONESHOT  = 0x0010;
const ushort EV_CLEAR    = 0x0020;
const ushort EV_RECEIPT  = 0x0040;
const ushort EV_DISPATCH = 0x0080;
const ushort EV_SYSFLAGS = 0xf000;
const ushort EV_FLAG1    = 0x2000;

// Return flags
const ushort EV_EOF      = 0x8000;
const ushort EV_ERROR    = 0x4000;

// EVFILT_VNODE fflags
const uint NOTE_DELETE   = 0x00000001;
const uint NOTE_WRITE    = 0x00000002;
const uint NOTE_EXTEND   = 0x00000004;
const uint NOTE_ATTRIB   = 0x00000008;
const uint NOTE_LINK     = 0x00000010;
const uint NOTE_RENAME   = 0x00000020;
const uint NOTE_REVOKE   = 0x00000040;
const uint NOTE_TRUNCATE = 0x00000080;  // File was truncated (OpenBSD-specific)

// EVFILT_PROC fflags
const uint NOTE_EXIT     = 0x80000000;
const uint NOTE_FORK     = 0x40000000;
const uint NOTE_EXEC     = 0x20000000;
const uint NOTE_PCTRLMASK = 0xf0000000;
const uint NOTE_PDATAMASK = 0x000fffff;
const uint NOTE_TRACK    = 0x00000001;
const uint NOTE_TRACKERR = 0x00000002;
const uint NOTE_CHILD    = 0x00000004;

// EVFILT_TIMER fflags
const uint NOTE_SECONDS  = 0x00000001;
const uint NOTE_USECONDS = 0x00000002;
const uint NOTE_NSECONDS = 0x00000004;
const uint NOTE_ABSTIME  = 0x00000010;

// EVFILT_DEVICE fflags (OpenBSD-specific)
const uint NOTE_CHANGE   = 0x00000001;  // Device change event

// kevent structure
struct Kevent {
    ulong  ident;
    short  filter;
    ushort flags;
    uint   fflags;
    long   data;
    void*  udata;
}

macro ev_set(kevp, a, b, c, d, e, f) {
    Kevent *__kevp__ = (kevp);
    __kevp__.ident = (a);
    __kevp__.filter = (b);
    __kevp__.flags = (c);
    __kevp__.fflags = (d);
    __kevp__.data = (e);
    __kevp__.udata = (f);
}

// Function Declarations
extern fn int kqueue();
extern fn int kevent(int kq, Kevent* changelist, int nchanges, Kevent* eventlist, int nevents, TimeSpec* timeout);

// TimeSpec
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// ========== Windows ==========

module c::sys::event @if(env::WIN32);

// kqueue is not available on Windows.
// For equivalent functionality, consider:
// 1. IOCP (I/O Completion Ports) - high-performance async I/O
// 2. WaitForMultipleObjects() / WaitForMultipleObjectsEx() - for general handles
// 3. WSAEventSelect() + WSAWaitForMultipleEvents() - for sockets
// 4. RegisterWaitForSingleObject() - for callback-based waiting
