// sys.wait.h.c3

module sys::wait @if(!env::WIN32);

// Main wait functions
extern fn int wait(int* wstatus);
extern fn int waitpid(int pid, int* wstatus, int options);
extern fn int waitid(IdType idtype, uint id, SigInfo* infop, int options);
extern fn int wait3(int* wstatus, int options, Rusage* rusage);
extern fn int wait4(int pid, int* wstatus, int options, Rusage* rusage);




module sys::wait @if(env::LINUX);

// Options for waitpid/waitid
const int WNOHANG = 1;
const int WUNTRACED = 2;
const int WSTOPPED = 2;
const int WEXITED = 4;
const int WCONTINUED = 8;
const int WNOWAIT = 0x01000000;

// Linux-specific options
const int __WNOTHREAD = 0x20000000;
const int __WALL = 0x40000000;
const uint __WCLONE = 0x80000000;

// Status examination macros
macro bool wifexited(int status) => ((status & 0x7f) == 0);
macro int wexitstatus(int status) => ((status & 0xff00) >> 8);
macro bool wifsignaled(int status) => (((char)((status & 0x7f) + 1) >> 1) > 0);
macro int wtermsig(int status) => (status & 0x7f);
macro bool wcoredump(int status) => ((status) & 0x80) != 0;
macro bool wifstopped(int status) => ((status & 0xff) == 0x7f);
macro int wstopsig(int status) => ((status & 0xff00) >> 8);
macro bool wifcontinued(int status) => (status == 0xffff);

// idtype for waitid
enum IdType : int {
    P_ALL,
    P_PID,
    P_PGID,
    P_PIDFD,
}

// Signal info structure for waitid
struct SigInfo {
    int si_signo;
    int si_errno;
    int si_code;
    union {
        int[28] _pad;
        struct {
            int si_pid;
            uint si_uid;
        }
        struct {
            int si_pid2;
            uint si_uid2;
            int si_status;
            long si_utime;
            long si_stime;
        }
    }
}

// Resource usage
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

struct Rusage {
    TimeVal ru_utime;
    TimeVal ru_stime;
    long ru_maxrss;
    long ru_ixrss;
    long ru_idrss;
    long ru_isrss;
    long ru_minflt;
    long ru_majflt;
    long ru_nswap;
    long ru_inblock;
    long ru_oublock;
    long ru_msgsnd;
    long ru_msgrcv;
    long ru_nsignals;
    long ru_nvcsw;
    long ru_nivcsw;
}




module sys::wait @if(env::DARWIN);

// Options for waitpid/waitid
const int WNOHANG = 0x00000001;
const int WUNTRACED = 0x00000002;
const int WSTOPPED = WUNTRACED;
const int WEXITED = 0x00000004;
const int WCONTINUED = 0x00000010;
const int WNOWAIT = 0x00000020;

// Status examination macros (Darwin)
macro int _wstatus(int status) => (status & 0x7f);
macro bool wifexited(int status) => (_wstatus(status) == 0);
macro int wexitstatus(int status) => ((status >> 8) & 0xff);
macro bool wifsignaled(int status) => (_wstatus(status) != 0x7f && _wstatus(status) != 0);
macro int wtermsig(int status) => _wstatus(status);
macro bool wcoredump(int status) => ((status & 0x80) != 0);
macro bool wifstopped(int status) => (_wstatus(status) == 0x7f);
macro int wstopsig(int status) => ((status >> 8) & 0xff);
macro bool wifcontinued(int status) => (status == 0x13);

// idtype for waitid
enum IdType : uint {
    P_ALL ,
    P_PID ,
    P_PGID ,
}

// Union for sigval
union SigVal {
    int sival_int;
    void* sival_ptr;
}

// Signal info structure
struct SigInfo {
    int si_signo;
    int si_errno;
    int si_code;
    int si_pid;
    uint si_uid;
    int si_status;
    void* si_addr;
    SigVal si_value;
    long si_band;
    ulong[7] __pad;
}

// Resource usage
struct TimeVal {
    long tv_sec;
    int tv_usec;
}

struct Rusage {
    TimeVal ru_utime;
    TimeVal ru_stime;
    long ru_maxrss;
    long ru_ixrss;
    long ru_idrss;
    long ru_isrss;
    long ru_minflt;
    long ru_majflt;
    long ru_nswap;
    long ru_inblock;
    long ru_oublock;
    long ru_msgsnd;
    long ru_msgrcv;
    long ru_nsignals;
    long ru_nvcsw;
    long ru_nivcsw;
}



module sys::wait @if(env::FREEBSD);

// Options for waitpid/waitid
const int WNOHANG = 1;
const int WUNTRACED = 2;
const int WSTOPPED = WUNTRACED;
const int WCONTINUED = 4;
const int WNOWAIT = 8;
const int WEXITED = 16;
const int WTRAPPED = 32;

// FreeBSD specific
const uint WLINUXCLONE = 0x80000000;

// Status examination macros
macro int _wstatus(int status) => (status & 0x7f);
macro bool wifexited(int status) => (_wstatus(status) == 0);
macro int wexitstatus(int status) => ((status >> 8) & 0xff);
macro bool wifsignaled(int status) => (_wstatus(status) != 0 && _wstatus(status) != 0x7f);
macro int wtermsig(int status) => _wstatus(status);
macro bool wcoredump(int status) => ((status & 0x80) != 0);
macro bool wifstopped(int status) => (_wstatus(status) == 0x7f);
macro int wstopsig(int status) => ((status >> 8) & 0xff);
macro bool wifcontinued(int status) => (status == 0x13);

// idtype for waitid
enum IdType : int {
    P_PID ,
    P_PPID ,
    P_PGID ,
    P_SID ,
    P_CID ,
    P_UID ,
    P_GID ,
    P_ALL ,
    P_LWPID ,
    P_TASKID ,
    P_PROJID ,
    P_POOLID ,
    P_JAILID ,
    P_CTID ,
    P_CPUID ,
    P_PSETID,
}

// Union for sigval
union SigVal {
    int sival_int;
    void* sival_ptr;
}

// Signal info structure
struct SigInfo {
    int si_signo;
    int si_errno;
    int si_code;
    int si_pid;
    uint si_uid;
    int si_status;
    void* si_addr;
    SigVal si_value;
    union {
        struct {
            int _trapno;
        }
        struct {
            int _timerid;
            int _overrun;
        }
        struct {
            int _mqd;
        }
        struct {
            long _band;
        }
        struct {
            int _syscall;
        }
        int[7] __spare__;
    }
}

// Resource usage
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

struct Rusage {
    TimeVal ru_utime;
    TimeVal ru_stime;
    long ru_maxrss;
    long ru_ixrss;
    long ru_idrss;
    long ru_isrss;
    long ru_minflt;
    long ru_majflt;
    long ru_nswap;
    long ru_inblock;
    long ru_oublock;
    long ru_msgsnd;
    long ru_msgrcv;
    long ru_nsignals;
    long ru_nvcsw;
    long ru_nivcsw;
}



module sys::wait @if(env::NETBSD);

// Options for waitpid/waitid
const int WNOHANG = 0x00000001;
const int WUNTRACED = 0x00000002;
const int WSTOPPED = WUNTRACED;
const int WCONTINUED = 0x00000010;
const int WNOWAIT = 0x00010000;
const int WEXITED = 0x00000020;
const int WTRAPPED = 0x00000040;

// NetBSD specific
const int WALLSIG = 0x00000008;
const int WALTSIG = 0x00000004;

// Status examination macros
macro int _wstatus(int status) => (status & 0x7f);
macro bool wifexited(int status) => (_wstatus(status) == 0);
macro int wexitstatus(int status) => ((status >> 8) & 0xff);
macro bool wifsignaled(int status) => (_wstatus(status) != 0x7f && _wstatus(status) != 0);
macro int wtermsig(int status) => _wstatus(status);
macro bool wcoredump(int status) => ((status & 0x80) != 0);
macro bool wifstopped(int status) => (_wstatus(status) == 0x7f);
macro int wstopsig(int status) => ((status >> 8) & 0xff);
macro bool wifcontinued(int status) => (status == 0xffff);

// idtype for waitid
enum IdType : int {
    P_ALL,
    P_PID,
    P_PGID,
}

// Union for sigval
union SigVal {
    int sival_int;
    void* sival_ptr;
}

// Signal info structure
struct SigInfo {
    int si_signo;
    int si_code;
    int si_errno;
    union {
        int[24] _pad;
        struct {
            int _pid;
            uint _uid;
            SigVal _value;
        }
        struct {
            int _pid2;
            uint _uid2;
            int _status;
            long _utime;
            long _stime;
        }
        struct {
            void* _addr;
            int _trap;
        }
        struct {
            long _band;
            int _fd;
        }
    }
}

// Resource usage
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

struct Rusage {
    TimeVal ru_utime;
    TimeVal ru_stime;
    long ru_maxrss;
    long ru_ixrss;
    long ru_idrss;
    long ru_isrss;
    long ru_minflt;
    long ru_majflt;
    long ru_nswap;
    long ru_inblock;
    long ru_oublock;
    long ru_msgsnd;
    long ru_msgrcv;
    long ru_nsignals;
    long ru_nvcsw;
    long ru_nivcsw;
}



module sys::wait @if(env::OPENBSD);

// Options for waitpid/waitid
const int WNOHANG = 0x0001;
const int WUNTRACED = 0x0002;
const int WSTOPPED = WUNTRACED;
const int WCONTINUED = 0x0008;

// Status examination macros
macro int _wstatus(int status) => (status & 0x7f);
macro bool wifexited(int status) => (_wstatus(status) == 0);
macro int wexitstatus(int status) => ((status >> 8) & 0xff);
macro bool wifsignaled(int status) => (_wstatus(status) != 0x7f && _wstatus(status) != 0);
macro int wtermsig(int status) => _wstatus(status);
macro bool wcoredump(int status) => ((status & 0x80) != 0);
macro bool wifstopped(int status) => (_wstatus(status) == 0x7f);
macro int wstopsig(int status) => ((status >> 8) & 0xff);
macro bool wifcontinued(int status) => (status == 0x13);

// idtype for waitid (OpenBSD doesn't have waitid in base system)
enum IdType : int {
    P_ALL ,
    P_PID ,
    P_PGID ,
}

// Union for sigval
union SigVal {
    int sival_int;
    void* sival_ptr;
}

// Signal info structure
struct SigInfo {
    int si_signo;
    int si_code;
    int si_errno;
    union {
        int[29] _pad;
        struct {
            int _pid;
            union {
                struct {
                    uint _uid;
                    SigVal _value;
                }
                struct {
                    long _utime;
                    int _status;
                    long _stime;
                }
            }
        }
        struct {
            void* _addr;
            int _trapno;
        }
        struct {
            long _band;
            int _fd;
        }
    }
}

// Resource usage
struct TimeVal {
    long tv_sec;
    long tv_usec;
}

struct Rusage {
    TimeVal ru_utime;
    TimeVal ru_stime;
    long ru_maxrss;
    long ru_ixrss;
    long ru_idrss;
    long ru_isrss;
    long ru_minflt;
    long ru_majflt;
    long ru_nswap;
    long ru_inblock;
    long ru_oublock;
    long ru_msgsnd;
    long ru_msgrcv;
    long ru_nsignals;
    long ru_nvcsw;
    long ru_nivcsw;
}
