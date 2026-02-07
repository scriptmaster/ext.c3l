// sys.time.h.c3

module sys::time;

// ========== Linux ==========

module sys::time @if(env::LINUX);

// Structures
struct TimeVal {
    long tv_sec;   // Seconds
    long tv_usec;  // Microseconds
}

struct TimeZone {
    int tz_minuteswest;  // Minutes west of Greenwich
    int tz_dsttime;      // Type of DST correction
}

struct ITimerVal {
    TimeVal it_interval;  // Timer interval
    TimeVal it_value;     // Current value
}

// Function Declarations
extern fn int gettimeofday(TimeVal* tv, TimeZone* tz);
extern fn int settimeofday(TimeVal* tv, TimeZone* tz);
extern fn int adjtime(TimeVal* delta, TimeVal* olddelta);

extern fn int getitimer(int which, ITimerVal* curr_value);
extern fn int setitimer(int which, ITimerVal* new_value, ITimerVal* old_value);

extern fn int utimes(char* filename, TimeVal[2] times);
extern fn int lutimes(char* filename, TimeVal[2] times);
extern fn int futimes(int fd, TimeVal[2] times);
extern fn int futimesat(int dirfd, char* pathname, TimeVal[2] times);

// Timer types for setitimer/getitimer
const int ITIMER_REAL = 0;     // Real time
const int ITIMER_VIRTUAL = 1;  // Process virtual time
const int ITIMER_PROF = 2;     // Process and system time

// Macros for timeval operations
macro void timerclear(TimeVal* tvp) {
    tvp.tv_sec = 0;
    tvp.tv_usec = 0;
}

macro bool timerisset(TimeVal* tvp) => (tvp.tv_sec || tvp.tv_usec);

macro void timeradd(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec + b.tv_sec;
    result.tv_usec = a.tv_usec + b.tv_usec;
    if (result.tv_usec >= 1000000) {
        result.tv_sec++;
        result.tv_usec -= 1000000;
    }
}

macro void timersub(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec - b.tv_sec;
    result.tv_usec = a.tv_usec - b.tv_usec;
    if (result.tv_usec < 0) {
        result.tv_sec--;
        result.tv_usec += 1000000;
    }
}

// ========== Darwin (macOS) ==========

module sys::time @if(env::DARWIN);

// Structures
struct TimeVal {
    long tv_sec;   // Seconds
    int tv_usec;   // Microseconds (note: int on macOS, not long)
}

struct TimeZone {
    int tz_minuteswest;
    int tz_dsttime;
}

struct ITimerVal {
    TimeVal it_interval;
    TimeVal it_value;
}

// Function Declarations
extern fn int gettimeofday(TimeVal* tv, TimeZone* tz);
extern fn int settimeofday(TimeVal* tv, TimeZone* tz);
extern fn int adjtime(TimeVal* delta, TimeVal* olddelta);

extern fn int getitimer(int which, ITimerVal* curr_value);
extern fn int setitimer(int which, ITimerVal* new_value, ITimerVal* old_value);

extern fn int utimes(char* filename, TimeVal[2] times);
extern fn int lutimes(char* filename, TimeVal[2] times);
extern fn int futimes(int fd, TimeVal[2] times);

// Timer types
const int ITIMER_REAL = 0;
const int ITIMER_VIRTUAL = 1;
const int ITIMER_PROF = 2;

// Macros for timeval operations
macro void timerclear(TimeVal* tvp) {
    tvp.tv_sec = 0;
    tvp.tv_usec = 0;
}

macro bool timerisset(TimeVal* tvp) => (tvp.tv_sec || tvp.tv_usec);


macro void timeradd(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec + b.tv_sec;
    result.tv_usec = a.tv_usec + b.tv_usec;
    if (result.tv_usec >= 1000000) {
        result.tv_sec++;
        result.tv_usec -= 1000000;
    }
}

macro void timersub(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec - b.tv_sec;
    result.tv_usec = a.tv_usec - b.tv_usec;
    if (result.tv_usec < 0) {
        result.tv_sec--;
        result.tv_usec += 1000000;
    }
}

// Darwin-specific: clock selection for gettimeofday
const int CLOCK_REALTIME = 0;
const int CLOCK_MONOTONIC = 6;

// ========== FreeBSD ==========

module sys::time @if(env::FREEBSD);

// Structures
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

struct TimeZone {
    int tz_minuteswest;
    int tz_dsttime;
}

struct ITimerVal {
    TimeVal it_interval;
    TimeVal it_value;
}

// Function Declarations
extern fn int gettimeofday(TimeVal* tv, TimeZone* tz);
extern fn int settimeofday(TimeVal* tv, TimeZone* tz);
extern fn int adjtime(TimeVal* delta, TimeVal* olddelta);

extern fn int getitimer(int which, ITimerVal* curr_value);
extern fn int setitimer(int which, ITimerVal* new_value, ITimerVal* old_value);

extern fn int utimes(char* filename, TimeVal[2] times);
extern fn int lutimes(char* filename, TimeVal[2] times);
extern fn int futimes(int fd, TimeVal[2] times);
extern fn int futimesat(int dirfd, char* pathname, TimeVal[2] times);

// Timer types
const int ITIMER_REAL = 0;
const int ITIMER_VIRTUAL = 1;
const int ITIMER_PROF = 2;

// Macros for timeval operations
macro void timerclear(TimeVal* tvp) {
    tvp.tv_sec = 0;
    tvp.tv_usec = 0;
}

macro bool timerisset(TimeVal* tvp) => (tvp.tv_sec || tvp.tv_usec);


macro void timeradd(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec + b.tv_sec;
    result.tv_usec = a.tv_usec + b.tv_usec;
    if (result.tv_usec >= 1000000) {
        result.tv_sec++;
        result.tv_usec -= 1000000;
    }
}

macro void timersub(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec - b.tv_sec;
    result.tv_usec = a.tv_usec - b.tv_usec;
    if (result.tv_usec < 0) {
        result.tv_sec--;
        result.tv_usec += 1000000;
    }
}

// FreeBSD-specific
extern fn int bintime(BinTime* bt);
extern fn int nanotime(TimeSpec* ts);
extern fn int microtime(TimeVal* tv);

struct BinTime {
    long sec;
    ulong frac;
}

struct TimeSpec {
    long tv_sec;   // Seconds
    long tv_nsec;  // Nanoseconds
}



// ========== NetBSD ==========

module sys::time @if(env::NETBSD);

// Structures
struct TimeVal {
    long tv_sec;
    int tv_usec;
}

struct TimeZone {
    int tz_minuteswest;
    int tz_dsttime;
}

struct ITimerVal {
    TimeVal it_interval;
    TimeVal it_value;
}

// Function Declarations
extern fn int gettimeofday(TimeVal* tv, TimeZone* tz);
extern fn int settimeofday(TimeVal* tv, TimeZone* tz);
extern fn int adjtime(TimeVal* delta, TimeVal* olddelta);

extern fn int getitimer(int which, ITimerVal* curr_value);
extern fn int setitimer(int which, ITimerVal* new_value, ITimerVal* old_value);

extern fn int utimes(char* filename, TimeVal[2] times);
extern fn int lutimes(char* filename, TimeVal[2] times);
extern fn int futimes(int fd, TimeVal[2] times);

// Timer types
const int ITIMER_REAL = 0;
const int ITIMER_VIRTUAL = 1;
const int ITIMER_PROF = 2;

// Macros for timeval operations
macro void timerclear(TimeVal* tvp) {
    tvp.tv_sec = 0;
    tvp.tv_usec = 0;
}

macro bool timerisset(TimeVal* tvp) => (tvp.tv_sec || tvp.tv_usec);


macro void timeradd(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec + b.tv_sec;
    result.tv_usec = a.tv_usec + b.tv_usec;
    if (result.tv_usec >= 1000000) {
        result.tv_sec++;
        result.tv_usec -= 1000000;
    }
}

macro void timersub(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec - b.tv_sec;
    result.tv_usec = a.tv_usec - b.tv_usec;
    if (result.tv_usec < 0) {
        result.tv_sec--;
        result.tv_usec += 1000000;
    }
}

// ========== OpenBSD ==========

module sys::time @if(env::OPENBSD);

// Structures
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

struct TimeZone {
    int tz_minuteswest;
    int tz_dsttime;
}

struct ITimerVal {
    TimeVal it_interval;
    TimeVal it_value;
}

// Function Declarations
extern fn int gettimeofday(TimeVal* tv, TimeZone* tz);
extern fn int settimeofday(TimeVal* tv, TimeZone* tz);
extern fn int adjtime(TimeVal* delta, TimeVal* olddelta);

extern fn int getitimer(int which, ITimerVal* curr_value);
extern fn int setitimer(int which, ITimerVal* new_value, ITimerVal* old_value);

extern fn int utimes(char* filename, TimeVal[2] times);
extern fn int lutimes(char* filename, TimeVal[2] times);
extern fn int futimes(int fd, TimeVal[2] times);

// Timer types
const int ITIMER_REAL = 0;
const int ITIMER_VIRTUAL = 1;
const int ITIMER_PROF = 2;

// Macros for timeval operations
macro void timerclear(TimeVal* tvp) {
    tvp.tv_sec = 0;
    tvp.tv_usec = 0;
}

macro bool timerisset(TimeVal* tvp) => (tvp.tv_sec || tvp.tv_usec);


macro void timeradd(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec + b.tv_sec;
    result.tv_usec = a.tv_usec + b.tv_usec;
    if (result.tv_usec >= 1000000) {
        result.tv_sec++;
        result.tv_usec -= 1000000;
    }
}

macro void timersub(TimeVal* a, TimeVal* b, TimeVal* result) {
    result.tv_sec = a.tv_sec - b.tv_sec;
    result.tv_usec = a.tv_usec - b.tv_usec;
    if (result.tv_usec < 0) {
        result.tv_sec--;
        result.tv_usec += 1000000;
    }
}

// ========== Windows ==========

// Note: Windows does not have sys/time.h
// For Windows, use the following alternatives:
// - GetSystemTime() / GetLocalTime() for current time
// - QueryPerformanceCounter() for high-resolution timing
// - _ftime() / _ftime64() for timeval-like functionality (in sys/timeb.h)
// - SetTimer() / timeSetEvent() for timers

module sys::time @if(env::WIN32);

// Windows does not have native sys/time.h
// However, some compatibility layers (like MinGW) may provide it
// Here we define minimal compatibility structures
