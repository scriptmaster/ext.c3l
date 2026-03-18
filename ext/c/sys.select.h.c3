// sys.select.h.c3

module c::sys::select;

// ========== Linux ==========

module c::sys::select @if(env::LINUX);

// fd_set size constant
const int FD_SETSIZE = 1024;  // Maximum number of file descriptors in fd_set

// fd_set structure
// Internally a bitmask array; use FD_* macros (implemented as helper functions below)
struct FdSet {
    ulong[16] fds_bits;  // 1024 bits (16 * 64)
}

// TimeVal for select()
struct TimeVal {
    long tv_sec;   // Seconds
    long tv_usec;  // Microseconds
}

// TimeSpec for pselect()
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Function Declarations
extern fn int select(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeVal* timeout);
extern fn int pselect(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeSpec* timeout, void* sigmask);

// FD_* helper functions (inline equivalents)
fn void fd_zero(FdSet* set) {
    for (int i = 0; i < 16; i++) set.fds_bits[i] = 0;
}

fn void fd_set(int fd, FdSet* set) {
    set.fds_bits[fd / 64] |= (1UL << (fd % 64));
}

fn void fd_clr(int fd, FdSet* set) {
    set.fds_bits[fd / 64] &= ~(1UL << (fd % 64));
}

fn bool fd_isset(int fd, FdSet* set) {
    return (set.fds_bits[fd / 64] & (1UL << (fd % 64))) != 0;
}

fn void fd_copy(FdSet* dst, FdSet* src) {
    for (int i = 0; i < 16; i++) dst.fds_bits[i] = src.fds_bits[i];
}

// ========== Darwin (macOS) ==========

module c::sys::select @if(env::DARWIN);

// fd_set size constant
const int FD_SETSIZE = 1024;

// fd_set structure
struct FdSet {
    int[32] fds_bits;  // 1024 bits (32 * 32)
}

// TimeVal for select()
struct TimeVal {
    long tv_sec;
    int  tv_usec;  // Darwin uses int for tv_usec
}

// TimeSpec for pselect()
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Function Declarations
extern fn int select(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeVal* timeout);
extern fn int pselect(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeSpec* timeout, void* sigmask);

// FD_* helper functions
fn void fd_zero(FdSet* set) {
    for (int i = 0; i < 32; i++) set.fds_bits[i] = 0;
}

fn void fd_set(int fd, FdSet* set) {
    set.fds_bits[fd / 32] |= (1 << (fd % 32));
}

fn void fd_clr(int fd, FdSet* set) {
    set.fds_bits[fd / 32] &= ~(1 << (fd % 32));
}

fn bool fd_isset(int fd, FdSet* set) {
    return (set.fds_bits[fd / 32] & (1 << (fd % 32))) != 0;
}

fn void fd_copy(FdSet* dst, FdSet* src) {
    for (int i = 0; i < 32; i++) dst.fds_bits[i] = src.fds_bits[i];
}

// ========== FreeBSD ==========

module c::sys::select @if(env::FREEBSD);

// fd_set size constant
const int FD_SETSIZE = 1024;

// fd_set structure
struct FdSet {
    ulong[16] fds_bits;  // 1024 bits (16 * 64)
}

// TimeVal for select()
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

// TimeSpec for pselect()
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Function Declarations
extern fn int select(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeVal* timeout);
extern fn int pselect(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeSpec* timeout, void* sigmask);

// FD_* helper functions
fn void fd_zero(FdSet* set) {
    for (int i = 0; i < 16; i++) set.fds_bits[i] = 0;
}

fn void fd_set(int fd, FdSet* set) {
    set.fds_bits[fd / 64] |= (1UL << (fd % 64));
}

fn void fd_clr(int fd, FdSet* set) {
    set.fds_bits[fd / 64] &= ~(1UL << (fd % 64));
}

fn bool fd_isset(int fd, FdSet* set) {
    return (set.fds_bits[fd / 64] & (1UL << (fd % 64))) != 0;
}

fn void fd_copy(FdSet* dst, FdSet* src) {
    for (int i = 0; i < 16; i++) dst.fds_bits[i] = src.fds_bits[i];
}

// ========== NetBSD ==========

module c::sys::select @if(env::NETBSD);

// fd_set size constant
const int FD_SETSIZE = 256;  // NetBSD default is 256

// fd_set structure
struct FdSet {
    uint[8] fds_bits;  // 256 bits (8 * 32)
}

// TimeVal for select()
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

// TimeSpec for pselect()
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Function Declarations
extern fn int select(uint nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeVal* timeout);
extern fn int pselect(uint nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeSpec* timeout, void* sigmask);

// FD_* helper functions
fn void fd_zero(FdSet* set) {
    for (int i = 0; i < 8; i++) set.fds_bits[i] = 0;
}

fn void fd_set(int fd, FdSet* set) {
    set.fds_bits[fd / 32] |= (1u << (fd % 32));
}

fn void fd_clr(int fd, FdSet* set) {
    set.fds_bits[fd / 32] &= ~(1u << (fd % 32));
}

fn bool fd_isset(int fd, FdSet* set) {
    return (set.fds_bits[fd / 32] & (1u << (fd % 32))) != 0;
}

fn void fd_copy(FdSet* dst, FdSet* src) {
    for (int i = 0; i < 8; i++) dst.fds_bits[i] = src.fds_bits[i];
}

// ========== OpenBSD ==========

module c::sys::select @if(env::OPENBSD);

// fd_set size constant
const int FD_SETSIZE = 1024;

// fd_set structure
struct FdSet {
    uint[32] fds_bits;  // 1024 bits (32 * 32)
}

// TimeVal for select()
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

// TimeSpec for pselect()
struct TimeSpec {
    long tv_sec;
    long tv_nsec;
}

// Function Declarations
extern fn int select(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeVal* timeout);
extern fn int pselect(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeSpec* timeout, void* sigmask);

// FD_* helper functions
fn void fd_zero(FdSet* set) {
    for (int i = 0; i < 32; i++) set.fds_bits[i] = 0;
}

fn void fd_set(int fd, FdSet* set) {
    set.fds_bits[fd / 32] |= (1u << (fd % 32));
}

fn void fd_clr(int fd, FdSet* set) {
    set.fds_bits[fd / 32] &= ~(1u << (fd % 32));
}

fn bool fd_isset(int fd, FdSet* set) {
    return (set.fds_bits[fd / 32] & (1u << (fd % 32))) != 0;
}

fn void fd_copy(FdSet* dst, FdSet* src) {
    for (int i = 0; i < 32; i++) dst.fds_bits[i] = src.fds_bits[i];
}

// ========== Windows ==========

module c::sys::select @if(env::WIN32);

// Windows select() is provided by Winsock2 (ws2_32.dll)
// fd_set on Windows stores an array of SOCKETs, NOT a bitmask

const uint FD_SETSIZE = 64;  // Default maximum sockets in fd_set (can be redefined before including winsock2.h)

// Windows fd_set structure (SOCKET-array based, not bitmask)
struct FdSet {
    uint      fd_count;              // Number of sockets in the set
    ulong[64] fd_array;              // Array of socket handles (SOCKET = ulong on Win64)
}

// TimeVal for select()
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

// Function Declaration
// Note: On Windows, select() takes (int, fd_set*, fd_set*, fd_set*, timeval*) but
// the first argument (nfds) is ignored; it exists only for POSIX compatibility.
extern fn int select(int nfds, FdSet* readfds, FdSet* writefds, FdSet* exceptfds, TimeVal* timeout);

// FD_* helper functions (Windows SOCKET-array style)
fn void fd_zero(FdSet* set) {
    set.fd_count = 0;
}

fn void fd_set(ulong sock, FdSet* set) {
    for (uint i = 0; i < set.fd_count; i++) {
        if (set.fd_array[i] == sock) return;  // Already in set
    }
    if (set.fd_count < FD_SETSIZE) {
        set.fd_array[set.fd_count] = sock;
        set.fd_count++;
    }
}

fn void fd_clr(ulong sock, FdSet* set) {
    for (uint i = 0; i < set.fd_count; i++) {
        if (set.fd_array[i] == sock) {
            // Shift remaining elements left
            for (uint j = i; j < set.fd_count - 1; j++) {
                set.fd_array[j] = set.fd_array[j + 1];
            }
            set.fd_count--;
            return;
        }
    }
}

fn bool fd_isset(ulong sock, FdSet* set) {
    for (uint i = 0; i < set.fd_count; i++) {
        if (set.fd_array[i] == sock) return true;
    }
    return false;
}

// Note: Windows does not have pselect().
// For signal-aware waiting, use WaitForMultipleObjectsEx() or
// WSAWaitForMultipleEvents() with alertable wait.
