// sys.syscall.netbsd.h.c3

// NetBSD x86_64 syscall numbers.
// Source: sys/kern/syscalls.master  (NetBSD 10.0)
//         /usr/include/sys/syscall.h
//
// NOTES:
//   - Calling convention: number in %rax, args in %rdi %rsi %rdx %r10 %r8 %r9.
//   - NetBSD has both a native syscall ABI and a Linux compat ABI (COMPAT_LINUX).
//     This file covers the NATIVE NetBSD ABI only.
//   - NetBSD retains many legacy BSD syscalls (open, fork, stat, dup2, pipe, select …).
//   - NetBSD has LWP (lightweight process) syscalls instead of clone/futex.
//   - Compat syscalls (COMPAT_43, COMPAT_09, COMPAT_12, COMPAT_13, COMPAT_14,
//     COMPAT_16, COMPAT_20, COMPAT_30, COMPAT_40, COMPAT_50, COMPAT_60, COMPAT_70,
//     COMPAT_80, COMPAT_90) are listed but marked; do NOT use them in new code.
//   - No epoll, io_uring, BPF sockets, futex, or inotify.
//   - Use kqueue(2) / kevent(2) for event notification.
//   - pset_* syscalls provide processor set management.
//   - modctl(2) replaces init_module/delete_module.
//   - NetBSD 9.0+ adds mremapd(2) and __clone(2).

module c::sys::syscall @if(env::NETBSD && env::X86_64);

// Standard BSD syscall wrapper.
extern fn long syscall(int number, ...);

// ---- Syscall 0 ----
const int SYS_SYSCALL          = 0;    // indirect syscall

// ---- Process ----
const int SYS_EXIT             = 1;
const int SYS_FORK             = 2;
const int SYS_WAIT4            = 7;
const int SYS_GETPID           = 20;
const int SYS_SETUID           = 23;
const int SYS_GETUID           = 24;
const int SYS_GETEUID          = 25;
const int SYS_PTRACE           = 26;
const int SYS_GETPPID          = 39;
const int SYS_GETEGID          = 43;
const int SYS_GETLOGIN         = 49;
const int SYS_SETLOGIN         = 50;
const int SYS_ACCT             = 51;
const int SYS_GETGID           = 47;
const int SYS_VFORK            = 66;
const int SYS_EXECVE           = 59;
const int SYS_GETPGRP          = 81;
const int SYS_SETPGID          = 82;
const int SYS_GETPGID          = 207;
const int SYS_SETSID           = 147;
const int SYS_GETSID           = 286;
const int SYS_KILL             = 37;
const int SYS_REBOOT           = 55;
const int SYS_ISSETUGID        = 305;
const int SYS_POSIX_SPAWN      = 474;

// ---- LWP (NetBSD native thread API, replaces clone/futex) ----
const int SYS__LWP_CREATE      = 309;
const int SYS__LWP_EXIT        = 310;
const int SYS__LWP_SELF        = 311;
const int SYS__LWP_WAIT        = 312;
const int SYS__LWP_SUSPEND     = 313;
const int SYS__LWP_CONTINUE    = 314;
const int SYS__LWP_WAKEUP      = 315;
const int SYS__LWP_GETPRIVATE  = 316;
const int SYS__LWP_SETPRIVATE  = 317;
const int SYS__LWP_KILL        = 318;
const int SYS__LWP_DETACH      = 478;
const int SYS__LWP_UNPARK      = 321;
const int SYS__LWP_UNPARK_ALL  = 322;
const int SYS__LWP_SETNAME     = 323;
const int SYS__LWP_GETNAME     = 324;
const int SYS__LWP_CTL         = 325;
const int SYS__LWP_PARK        = 478;  // overlaps in some versions; check SDK

// ---- User / Group IDs ----
const int SYS_SETREUID         = 126;
const int SYS_SETREGID         = 127;
const int SYS_GETGROUPS        = 79;
const int SYS_SETGROUPS        = 80;
const int SYS_SETRESUID        = 309;  // via compat path on some versions
const int SYS_GETRESUID        = 310;
const int SYS_SETRESGID        = 311;
const int SYS_GETRESGID        = 312;
const int SYS_SETFSUID         = 0;    // Not available; no setfsuid on NetBSD

// ---- File I/O ----
const int SYS_READ             = 3;
const int SYS_WRITE            = 4;
const int SYS_OPEN             = 5;
const int SYS_CLOSE            = 6;
const int SYS_PREAD            = 173;
const int SYS_PWRITE           = 174;
const int SYS_READV            = 120;
const int SYS_WRITEV           = 121;
const int SYS_PREADV           = 289;
const int SYS_PWRITEV          = 290;
const int SYS_LSEEK            = 199;
const int SYS_DUP              = 41;
const int SYS_DUP2             = 90;
const int SYS_DUP3             = 454;
const int SYS_PIPE             = 42;
const int SYS_PIPE2            = 453;
const int SYS_FCNTL            = 92;
const int SYS_IOCTL            = 54;
const int SYS_FLOCK            = 131;
const int SYS_FSYNC            = 95;
const int SYS_FSYNC_RANGE      = 354;  // NetBSD extension: sync byte range
const int SYS_FDATASYNC        = 0;    // Not available; use fsync_range
const int SYS_SELECT           = 93;
const int SYS_PSELECT          = 394;
const int SYS_POLL             = 252;
const int SYS_PPOLL            = 484;
const int SYS_READLINK         = 58;
const int SYS_SENDFILE         = 336;

// ---- Filesystem ----
const int SYS_LINK             = 9;
const int SYS_UNLINK           = 10;
const int SYS_CHDIR            = 12;
const int SYS_FCHDIR           = 13;
const int SYS_MKNOD            = 14;
const int SYS_CHMOD            = 15;
const int SYS_CHOWN            = 16;
const int SYS_ACCESS           = 33;
const int SYS_CHFLAGS          = 34;
const int SYS_FCHFLAGS         = 35;
const int SYS_SYNC             = 36;
const int SYS_REVOKE           = 56;
const int SYS_SYMLINK          = 57;
const int SYS_UMASK            = 60;
const int SYS_CHROOT           = 61;
const int SYS_RENAME           = 128;
const int SYS_MKFIFO           = 132;
const int SYS_MKDIR            = 136;
const int SYS_RMDIR            = 137;
const int SYS_UTIMES           = 138;
const int SYS_FUTIMES          = 206;
const int SYS_LUTIMES          = 423;
const int SYS_TRUNCATE         = 200;
const int SYS_FTRUNCATE        = 201;
const int SYS_LCHOWN           = 254;
const int SYS_LCHFLAGS         = 391;  // Not in all versions; check SDK

// ---- Filesystem — "at"-variants ----
const int SYS_OPENAT           = 468;
const int SYS_FACCESSAT        = 458;
const int SYS_FCHMODAT         = 459;
const int SYS_FCHOWNAT         = 460;
const int SYS_FSTATAT          = 461;
const int SYS_LINKAT           = 462;
const int SYS_MKDIRAT          = 463;
const int SYS_MKFIFOAT         = 464;
const int SYS_MKNODAT          = 465;
const int SYS_READLINKAT       = 466;
const int SYS_RENAMEAT         = 467;
const int SYS_SYMLINKAT        = 469;
const int SYS_UNLINKAT         = 470;
const int SYS_UTIMENSAT        = 471;
const int SYS_FUTIMENS         = 472;

// ---- Stat / Filesystem Info ----
// NetBSD uses __stat30 / __stat50 style versioned structs internally.
// The unversioned names below resolve to the current version via libc.
const int SYS___STAT50         = 439;
const int SYS___LSTAT50        = 440;
const int SYS___FSTAT50        = 441;
const int SYS___FHSTAT50       = 443;
const int SYS_STATFS           = 256;  // Not all versions; use statvfs
const int SYS_FSTATFS          = 257;
const int SYS_STATVFS1         = 356;  // NetBSD statvfs with flags
const int SYS_FSTATVFS1        = 357;
const int SYS_GETVFSSTAT       = 360;
const int SYS_GETFSSTAT        = 358;
const int SYS___GETFH30        = 349;  // get file handle
const int SYS___FHOPEN40       = 353;  // open by file handle
const int SYS___FHSTATVFS140   = 351;
const int SYS___FHSTAT60       = 450;

// ---- Directory Entries ----
const int SYS___GETDENTS30     = 272;  // NetBSD versioned getdents

// ---- Extended Attributes (NetBSD extattr) ----
// NetBSD uses extattr_* (not Linux-style getxattr/setxattr).
const int SYS_EXTATTR_SET_FILE     = 360;  // versions vary; check SDK
const int SYS_EXTATTR_GET_FILE     = 361;
const int SYS_EXTATTR_DELETE_FILE  = 362;
const int SYS_EXTATTR_SET_FD       = 363;
const int SYS_EXTATTR_GET_FD       = 364;
const int SYS_EXTATTR_DELETE_FD    = 365;
const int SYS_EXTATTR_SET_LINK     = 366;
const int SYS_EXTATTR_GET_LINK     = 367;
const int SYS_EXTATTR_DELETE_LINK  = 368;
const int SYS_EXTATTR_LIST_FD      = 369;
const int SYS_EXTATTR_LIST_FILE    = 370;
const int SYS_EXTATTR_LIST_LINK    = 371;

// ---- Mount / Unmount ----
const int SYS_MOUNT            = 410;  // __mount50
const int SYS_UNMOUNT          = 22;
const int SYS_PIVOT_ROOT       = 0;    // Not available on NetBSD
const int SYS_SWAPON           = 85;
const int SYS_SWAPCTL          = 198;
const int SYS_QUOTACTL         = 148;
const int SYS_NFSSVC           = 155;
const int SYS_FHOPEN           = 298;
const int SYS_GETFH            = 161;

// ---- Memory Management ----
const int SYS_MMAP             = 197;
const int SYS_MUNMAP           = 73;
const int SYS_MPROTECT         = 74;
const int SYS_MADVISE          = 75;
const int SYS_MSYNC            = 65;
const int SYS_MINCORE          = 78;
const int SYS_MLOCK            = 203;
const int SYS_MUNLOCK          = 204;
const int SYS_MLOCKALL         = 324;
const int SYS_MUNLOCKALL       = 325;
const int SYS_MREMAPD          = 481;  // NetBSD 9.0+: mremap with destination
const int SYS_MREMAP           = 0;    // Not the Linux mremap; use mremapd
const int SYS_SHM_OPEN         = 295;
const int SYS_SHM_UNLINK       = 296;
const int SYS_SHM_OPEN2        = 485;  // NetBSD 10.0+: O_CLOEXEC and flags
const int SYS_SHM_RENAME       = 486;  // NetBSD 10.0+

// ---- Networking / Sockets ----
const int SYS_SOCKET           = 97;
const int SYS_BIND             = 104;
const int SYS_LISTEN           = 106;
const int SYS_ACCEPT           = 30;
const int SYS_ACCEPT4          = 456;
const int SYS_CONNECT          = 98;
const int SYS_GETPEERNAME      = 31;
const int SYS_GETSOCKNAME      = 32;
const int SYS_SHUTDOWN         = 134;
const int SYS_SOCKETPAIR       = 135;
const int SYS_SETSOCKOPT       = 105;
const int SYS_GETSOCKOPT       = 118;
const int SYS_SENDTO           = 133;
const int SYS_RECVFROM         = 29;
const int SYS_SENDMSG          = 28;
const int SYS_RECVMSG          = 27;
const int SYS_RECVMMSG         = 475;
const int SYS_SENDMMSG         = 476;
const int SYS_SENDFILE         = 336;

// ---- kqueue / kevent ----
const int SYS_KQUEUE           = 344;
const int SYS_KEVENT           = 345;
const int SYS_KQUEUE1          = 457;  // NetBSD: kqueue with O_CLOEXEC flag

// ---- Signals ----
const int SYS_SIGACTION        = 340;  // __sigaction_sigtramp; use sigaction(3)
const int SYS_SIGPROCMASK      = 48;
const int SYS_SIGPENDING       = 52;
const int SYS_SIGALTSTACK      = 281;  // __sigaltstack14
const int SYS_SIGSUSPEND       = 111;
const int SYS_KILL             = 37;
const int SYS_TKILL            = 0;    // Not available; use _lwp_kill
const int SYS___SIGRETURN14    = 308;
const int SYS_SIGTIMEDWAIT     = 431;  // __sigtimedwait50

// ---- Time ----
const int SYS___GETTIMEOFDAY50 = 418;
const int SYS___SETTIMEOFDAY50 = 419;
const int SYS___ADJTIME50      = 421;
const int SYS___CLOCK_GETTIME50  = 427;
const int SYS___CLOCK_SETTIME50  = 428;
const int SYS___CLOCK_GETRES50   = 429;
const int SYS___CLOCK_NANOSLEEP50 = 430;
const int SYS___NANOSLEEP50    = 430;  // alias; check SDK
const int SYS___GETITIMER50    = 425;
const int SYS___SETITIMER50    = 426;
const int SYS___TIMER_CREATE50 = 434;
const int SYS___TIMER_DELETE   = 435;
const int SYS___TIMER_SETTIME50 = 436;
const int SYS___TIMER_GETTIME50 = 437;
const int SYS___TIMER_GETOVERRUN = 438;
const int SYS_CLOCK_GETCPUCLOCKID2 = 479;  // NetBSD 9.0+

// ---- Scheduling / Priority ----
const int SYS_GETPRIORITY      = 100;
const int SYS_SETPRIORITY      = 96;
const int SYS_SCHED_YIELD      = 350;
const int SYS_SCHED_SETPARAM   = 331;
const int SYS_SCHED_GETPARAM   = 332;
const int SYS_SCHED_SETSCHEDULER  = 333;
const int SYS_SCHED_GETSCHEDULER  = 334;
const int SYS_SCHED_GET_PRIORITY_MAX = 335;
const int SYS_SCHED_GET_PRIORITY_MIN = 336;
const int SYS_SCHED_RR_GET_INTERVAL = 337;
const int SYS_SCHED_SETAFFINITY   = 347;
const int SYS_SCHED_GETAFFINITY   = 348;

// ---- Processor Sets (pset) — NetBSD specific ----
const int SYS_PSET_CREATE      = 373;
const int SYS_PSET_DESTROY     = 374;
const int SYS_PSET_ASSIGN      = 375;
const int SYS__PSET_BIND       = 376;

// ---- Resource Limits ----
const int SYS_GETRLIMIT        = 194;
const int SYS_SETRLIMIT        = 195;
const int SYS___GETRUSAGE50    = 422;
const int SYS_PROFIL           = 44;

// ---- System Info / sysctl ----
const int SYS___SYSCTL         = 202;
const int SYS_SYSARCH          = 165;  // x86_64 arch-specific (set FS/GS base, etc.)

// ---- IPC: SysV Message Queues ----
const int SYS_MSGGET           = 225;
const int SYS_MSGSND           = 226;
const int SYS_MSGRCV           = 227;
const int SYS___MSGCTL50       = 224;

// ---- IPC: SysV Semaphores ----
const int SYS_SEMGET           = 221;
const int SYS_SEMOP            = 222;
const int SYS___SEMCTL50       = 220;

// ---- IPC: SysV Shared Memory ----
const int SYS_SHMGET           = 228;
const int SYS_SHMAT            = 229;
const int SYS_SHMDT            = 230;
const int SYS___SHMCTL50       = 231;

// ---- POSIX Semaphores ----
const int SYS_SEM_OPEN         = 280;
const int SYS_SEM_CLOSE        = 281;
const int SYS_SEM_UNLINK       = 282;
const int SYS_SEM_WAIT         = 283;
const int SYS_SEM_TRYWAIT      = 284;
const int SYS_SEM_POST         = 285;
const int SYS_SEM_GETVALUE     = 286;
const int SYS_SEM_INIT         = 287;
const int SYS_SEM_DESTROY      = 288;

// ---- POSIX Message Queues ----
const int SYS_MQ_OPEN          = 406;
const int SYS_MQ_CLOSE         = 407;
const int SYS_MQ_UNLINK        = 408;
const int SYS_MQ_GETATTR       = 409;
const int SYS_MQ_SETATTR       = 410;
const int SYS_MQ_NOTIFY        = 411;
const int SYS_MQ_SEND          = 412;
const int SYS_MQ_RECEIVE       = 413;
const int SYS___MQ_TIMEDSEND50   = 415;
const int SYS___MQ_TIMEDRECEIVE50 = 416;

// ---- POSIX AIO ----
const int SYS_AIO_CANCEL       = 316;
const int SYS_AIO_ERROR        = 317;
const int SYS_AIO_FSYNC        = 318;
const int SYS_AIO_READ         = 319;
const int SYS_AIO_RETURN       = 320;
const int SYS___AIO_SUSPEND50  = 421;
const int SYS_AIO_WRITE        = 322;
const int SYS_LIO_LISTIO       = 323;

// ---- Module Control (replaces init_module / delete_module) ----
const int SYS_MODCTL           = 246;  // NetBSD kernel module management

// ---- ktrace ----
const int SYS_KTRACE           = 45;
const int SYS_FKTRACE          = 396;

// ---- Misc ----
const int SYS_GETCWD           = 304;
const int SYS___GETCWD         = 304;  // alias
const int SYS_REVOKE           = 56;
const int SYS_CHFLAGS          = 34;
const int SYS_FCHFLAGS         = 35;
const int SYS_LCHFLAGS         = 391;
const int SYS_ISSETUGID        = 305;
const int SYS_GETCONTEXT       = 307;
const int SYS_SETCONTEXT       = 308;
const int SYS___CLONE          = 487;  // NetBSD 9.0+: clone with flags (Linux compat helper)
const int SYS_RASCTL           = 376;  // Restartable Atomic Sequences (NetBSD)
const int SYS_FDISCARD         = 488;  // NetBSD 10.0+: discard file region (like fallocate PUNCH_HOLE)
const int SYS_POSIX_FALLOCATE  = 490;  // NetBSD 10.0+

// ---- Getrandom (NetBSD 10.0+) ----
const int SYS_GETRANDOM        = 491;

// ---- Misc process info ----
const int SYS_GETPEEREID       = 353;
const int SYS_EXTATTRCTL       = 360;
const int SYS_NTP_ADJTIME      = 176;  // __ntp_adjtime50
const int SYS___NTP_GETTIME50  = 448;

// ---- Deprecated / Compat (do NOT use in new code) ----
// These remain in the table for binary compatibility but are obsolete.
const int SYS_COMPAT_OCREAT    = 8;    // Obsolete creat(2)
const int SYS_COMPAT_OLSEEK    = 19;   // Obsolete lseek
const int SYS_COMPAT_OSTAT     = 38;   // Obsolete stat (4.3BSD)
const int SYS_COMPAT_ONICE     = 34;   // Obsolete nice
const int SYS_COMPAT_OSETHOSTNAME = 229; // Obsolete
const int SYS_COMPAT_OSEND     = 11;   // Obsolete send
const int SYS_COMPAT_ORECV     = 12;   // Obsolete recv





// sys.syscall.netbsd_aarch64.h.c3
//
// NetBSD AArch64 syscall numbers.
// Source: sys/kern/syscalls.master  (NetBSD 10.0)
//         /usr/include/sys/syscall.h
//
// NOTES:
//   - NetBSD syscall numbers are ARCHITECTURE-INDEPENDENT — the same table is
//     shared across x86_64 and AArch64. Only the calling convention differs:
//       instruction : svc #0
//       number      : x8
//       arguments   : x0–x5  (up to 6 args; 64-bit args passed as single register)
//       return      : x0     (negative errno on error)
//   - NetBSD has both a native syscall ABI and a Linux compat ABI (COMPAT_LINUX).
//     This file covers the NATIVE NetBSD ABI only.
//   - NetBSD retains many legacy BSD syscalls (open, fork, stat, dup2, pipe, select …).
//   - NetBSD has LWP (lightweight process) syscalls instead of clone/futex.
//   - Compat syscalls (COMPAT_43, COMPAT_09 … COMPAT_90) are listed but marked;
//     do NOT use them in new code.
//   - No epoll, io_uring, BPF sockets, futex, or inotify.
//   - Use kqueue(2) / kevent(2) for event notification.
//   - pset_* syscalls provide processor set management.
//   - modctl(2) replaces init_module/delete_module.
//   - NetBSD 9.0+ adds mremapd(2) and __clone(2).
//   - AArch64-specific: SYS_SYSARCH sub-operations differ from x86_64.
//     Use AARCH64_GETMCONTEXT / AARCH64_SETMCONTEXT for signal context access.
//   - No SYS_MODIFY_LDT, SYS_SET_THREAD_AREA, or FS/GS base operations.

module c::sys::syscall @if(env::NETBSD && env::AARCH64);

// Standard BSD syscall wrapper.
// libc issues svc #0 with the number in x8 on AArch64.
extern fn long syscall(int number, ...);

// ---- Syscall 0 ----
const int SYS_SYSCALL          = 0;    // indirect syscall

// ---- Process ----
const int SYS_EXIT             = 1;
const int SYS_FORK             = 2;
const int SYS_WAIT4            = 7;
const int SYS_GETPID           = 20;
const int SYS_SETUID           = 23;
const int SYS_GETUID           = 24;
const int SYS_GETEUID          = 25;
const int SYS_PTRACE           = 26;
const int SYS_GETPPID          = 39;
const int SYS_GETEGID          = 43;
const int SYS_GETLOGIN         = 49;
const int SYS_SETLOGIN         = 50;
const int SYS_ACCT             = 51;
const int SYS_GETGID           = 47;
const int SYS_VFORK            = 66;
const int SYS_EXECVE           = 59;
const int SYS_GETPGRP          = 81;
const int SYS_SETPGID          = 82;
const int SYS_GETPGID          = 207;
const int SYS_SETSID           = 147;
const int SYS_GETSID           = 286;
const int SYS_KILL             = 37;
const int SYS_REBOOT           = 55;
const int SYS_ISSETUGID        = 305;
const int SYS_POSIX_SPAWN      = 474;

// ---- LWP (NetBSD native thread API, replaces clone/futex) ----
const int SYS__LWP_CREATE      = 309;
const int SYS__LWP_EXIT        = 310;
const int SYS__LWP_SELF        = 311;
const int SYS__LWP_WAIT        = 312;
const int SYS__LWP_SUSPEND     = 313;
const int SYS__LWP_CONTINUE    = 314;
const int SYS__LWP_WAKEUP      = 315;
const int SYS__LWP_GETPRIVATE  = 316;
const int SYS__LWP_SETPRIVATE  = 317;
const int SYS__LWP_KILL        = 318;
const int SYS__LWP_DETACH      = 478;
const int SYS__LWP_UNPARK      = 321;
const int SYS__LWP_UNPARK_ALL  = 322;
const int SYS__LWP_SETNAME     = 323;
const int SYS__LWP_GETNAME     = 324;
const int SYS__LWP_CTL         = 325;
const int SYS__LWP_PARK        = 478;  // overlaps in some versions; check SDK

// ---- User / Group IDs ----
const int SYS_SETREUID         = 126;
const int SYS_SETREGID         = 127;
const int SYS_GETGROUPS        = 79;
const int SYS_SETGROUPS        = 80;
const int SYS_SETRESUID        = 309;  // via compat path on some versions
const int SYS_GETRESUID        = 310;
const int SYS_SETRESGID        = 311;
const int SYS_GETRESGID        = 312;
const int SYS_SETFSUID         = 0;    // Not available; no setfsuid on NetBSD

// ---- File I/O ----
const int SYS_READ             = 3;
const int SYS_WRITE            = 4;
const int SYS_OPEN             = 5;
const int SYS_CLOSE            = 6;
const int SYS_PREAD            = 173;
const int SYS_PWRITE           = 174;
const int SYS_READV            = 120;
const int SYS_WRITEV           = 121;
const int SYS_PREADV           = 289;
const int SYS_PWRITEV          = 290;
const int SYS_LSEEK            = 199;
const int SYS_DUP              = 41;
const int SYS_DUP2             = 90;
const int SYS_DUP3             = 454;
const int SYS_PIPE             = 42;
const int SYS_PIPE2            = 453;
const int SYS_FCNTL            = 92;
const int SYS_IOCTL            = 54;
const int SYS_FLOCK            = 131;
const int SYS_FSYNC            = 95;
const int SYS_FSYNC_RANGE      = 354;  // NetBSD extension: sync byte range
const int SYS_FDATASYNC        = 0;    // Not available; use fsync_range
const int SYS_SELECT           = 93;
const int SYS_PSELECT          = 394;
const int SYS_POLL             = 252;
const int SYS_PPOLL            = 484;
const int SYS_READLINK         = 58;
const int SYS_SENDFILE         = 336;

// ---- Filesystem ----
const int SYS_LINK             = 9;
const int SYS_UNLINK           = 10;
const int SYS_CHDIR            = 12;
const int SYS_FCHDIR           = 13;
const int SYS_MKNOD            = 14;
const int SYS_CHMOD            = 15;
const int SYS_CHOWN            = 16;
const int SYS_ACCESS           = 33;
const int SYS_CHFLAGS          = 34;
const int SYS_FCHFLAGS         = 35;
const int SYS_SYNC             = 36;
const int SYS_REVOKE           = 56;
const int SYS_SYMLINK          = 57;
const int SYS_UMASK            = 60;
const int SYS_CHROOT           = 61;
const int SYS_RENAME           = 128;
const int SYS_MKFIFO           = 132;
const int SYS_MKDIR            = 136;
const int SYS_RMDIR            = 137;
const int SYS_UTIMES           = 138;
const int SYS_FUTIMES          = 206;
const int SYS_LUTIMES          = 423;
const int SYS_TRUNCATE         = 200;
const int SYS_FTRUNCATE        = 201;
const int SYS_LCHOWN           = 254;
const int SYS_LCHFLAGS         = 391;  // Not in all versions; check SDK

// ---- Filesystem — "at"-variants ----
const int SYS_OPENAT           = 468;
const int SYS_FACCESSAT        = 458;
const int SYS_FCHMODAT         = 459;
const int SYS_FCHOWNAT         = 460;
const int SYS_FSTATAT          = 461;
const int SYS_LINKAT           = 462;
const int SYS_MKDIRAT          = 463;
const int SYS_MKFIFOAT         = 464;
const int SYS_MKNODAT          = 465;
const int SYS_READLINKAT       = 466;
const int SYS_RENAMEAT         = 467;
const int SYS_SYMLINKAT        = 469;
const int SYS_UNLINKAT         = 470;
const int SYS_UTIMENSAT        = 471;
const int SYS_FUTIMENS         = 472;

// ---- Stat / Filesystem Info ----
// NetBSD uses __stat30 / __stat50 style versioned structs internally.
// The unversioned names below resolve to the current version via libc.
const int SYS___STAT50         = 439;
const int SYS___LSTAT50        = 440;
const int SYS___FSTAT50        = 441;
const int SYS___FHSTAT50       = 443;
const int SYS_STATFS           = 256;  // Not all versions; use statvfs
const int SYS_FSTATFS          = 257;
const int SYS_STATVFS1         = 356;  // NetBSD statvfs with flags
const int SYS_FSTATVFS1        = 357;
const int SYS_GETVFSSTAT       = 360;
const int SYS_GETFSSTAT        = 358;
const int SYS___GETFH30        = 349;  // get file handle
const int SYS___FHOPEN40       = 353;  // open by file handle
const int SYS___FHSTATVFS140   = 351;
const int SYS___FHSTAT60       = 450;

// ---- Directory Entries ----
const int SYS___GETDENTS30     = 272;  // NetBSD versioned getdents

// ---- Extended Attributes (NetBSD extattr) ----
// NetBSD uses extattr_* (not Linux-style getxattr/setxattr).
const int SYS_EXTATTR_SET_FILE     = 360;  // versions vary; check SDK
const int SYS_EXTATTR_GET_FILE     = 361;
const int SYS_EXTATTR_DELETE_FILE  = 362;
const int SYS_EXTATTR_SET_FD       = 363;
const int SYS_EXTATTR_GET_FD       = 364;
const int SYS_EXTATTR_DELETE_FD    = 365;
const int SYS_EXTATTR_SET_LINK     = 366;
const int SYS_EXTATTR_GET_LINK     = 367;
const int SYS_EXTATTR_DELETE_LINK  = 368;
const int SYS_EXTATTR_LIST_FD      = 369;
const int SYS_EXTATTR_LIST_FILE    = 370;
const int SYS_EXTATTR_LIST_LINK    = 371;

// ---- Mount / Unmount ----
const int SYS_MOUNT            = 410;  // __mount50
const int SYS_UNMOUNT          = 22;
const int SYS_PIVOT_ROOT       = 0;    // Not available on NetBSD
const int SYS_SWAPON           = 85;
const int SYS_SWAPCTL          = 198;
const int SYS_QUOTACTL         = 148;
const int SYS_NFSSVC           = 155;
const int SYS_FHOPEN           = 298;
const int SYS_GETFH            = 161;

// ---- Memory Management ----
const int SYS_MMAP             = 197;
const int SYS_MUNMAP           = 73;
const int SYS_MPROTECT         = 74;
const int SYS_MADVISE          = 75;
const int SYS_MSYNC            = 65;
const int SYS_MINCORE          = 78;
const int SYS_MLOCK            = 203;
const int SYS_MUNLOCK          = 204;
const int SYS_MLOCKALL         = 324;
const int SYS_MUNLOCKALL       = 325;
const int SYS_MREMAPD          = 481;  // NetBSD 9.0+: mremap with destination
const int SYS_MREMAP           = 0;    // Not the Linux mremap; use mremapd
const int SYS_SHM_OPEN         = 295;
const int SYS_SHM_UNLINK       = 296;
const int SYS_SHM_OPEN2        = 485;  // NetBSD 10.0+: O_CLOEXEC and flags
const int SYS_SHM_RENAME       = 486;  // NetBSD 10.0+

// ---- Networking / Sockets ----
const int SYS_SOCKET           = 97;
const int SYS_BIND             = 104;
const int SYS_LISTEN           = 106;
const int SYS_ACCEPT           = 30;
const int SYS_ACCEPT4          = 456;
const int SYS_CONNECT          = 98;
const int SYS_GETPEERNAME      = 31;
const int SYS_GETSOCKNAME      = 32;
const int SYS_SHUTDOWN         = 134;
const int SYS_SOCKETPAIR       = 135;
const int SYS_SETSOCKOPT       = 105;
const int SYS_GETSOCKOPT       = 118;
const int SYS_SENDTO           = 133;
const int SYS_RECVFROM         = 29;
const int SYS_SENDMSG          = 28;
const int SYS_RECVMSG          = 27;
const int SYS_RECVMMSG         = 475;
const int SYS_SENDMMSG         = 476;
const int SYS_SENDFILE         = 336;

// ---- kqueue / kevent ----
const int SYS_KQUEUE           = 344;
const int SYS_KEVENT           = 345;
const int SYS_KQUEUE1          = 457;  // NetBSD: kqueue with O_CLOEXEC flag

// ---- Signals ----
const int SYS_SIGACTION        = 340;  // __sigaction_sigtramp; use sigaction(3)
const int SYS_SIGPROCMASK      = 48;
const int SYS_SIGPENDING       = 52;
const int SYS_SIGALTSTACK      = 281;  // __sigaltstack14
const int SYS_SIGSUSPEND       = 111;
const int SYS_KILL             = 37;
const int SYS_TKILL            = 0;    // Not available; use _lwp_kill
const int SYS___SIGRETURN14    = 308;
const int SYS_SIGTIMEDWAIT     = 431;  // __sigtimedwait50

// ---- Time ----
const int SYS___GETTIMEOFDAY50 = 418;
const int SYS___SETTIMEOFDAY50 = 419;
const int SYS___ADJTIME50      = 421;
const int SYS___CLOCK_GETTIME50  = 427;
const int SYS___CLOCK_SETTIME50  = 428;
const int SYS___CLOCK_GETRES50   = 429;
const int SYS___CLOCK_NANOSLEEP50 = 430;
const int SYS___NANOSLEEP50    = 430;  // alias; check SDK
const int SYS___GETITIMER50    = 425;
const int SYS___SETITIMER50    = 426;
const int SYS___TIMER_CREATE50 = 434;
const int SYS___TIMER_DELETE   = 435;
const int SYS___TIMER_SETTIME50 = 436;
const int SYS___TIMER_GETTIME50 = 437;
const int SYS___TIMER_GETOVERRUN = 438;
const int SYS_CLOCK_GETCPUCLOCKID2 = 479;  // NetBSD 9.0+

// ---- Scheduling / Priority ----
const int SYS_GETPRIORITY      = 100;
const int SYS_SETPRIORITY      = 96;
const int SYS_SCHED_YIELD      = 350;
const int SYS_SCHED_SETPARAM   = 331;
const int SYS_SCHED_GETPARAM   = 332;
const int SYS_SCHED_SETSCHEDULER  = 333;
const int SYS_SCHED_GETSCHEDULER  = 334;
const int SYS_SCHED_GET_PRIORITY_MAX = 335;
const int SYS_SCHED_GET_PRIORITY_MIN = 336;
const int SYS_SCHED_RR_GET_INTERVAL = 337;
const int SYS_SCHED_SETAFFINITY   = 347;
const int SYS_SCHED_GETAFFINITY   = 348;

// ---- Processor Sets (pset) — NetBSD specific ----
const int SYS_PSET_CREATE      = 373;
const int SYS_PSET_DESTROY     = 374;
const int SYS_PSET_ASSIGN      = 375;
const int SYS__PSET_BIND       = 376;

// ---- Resource Limits ----
const int SYS_GETRLIMIT        = 194;
const int SYS_SETRLIMIT        = 195;
const int SYS___GETRUSAGE50    = 422;
const int SYS_PROFIL           = 44;

// ---- System Info / sysctl ----
const int SYS___SYSCTL         = 202;
const int SYS_SYSARCH          = 165;  // AArch64 arch-specific: AARCH64_GETMCONTEXT, AARCH64_SETMCONTEXT, AARCH64_GET_TCBPTR

// ---- IPC: SysV Message Queues ----
const int SYS_MSGGET           = 225;
const int SYS_MSGSND           = 226;
const int SYS_MSGRCV           = 227;
const int SYS___MSGCTL50       = 224;

// ---- IPC: SysV Semaphores ----
const int SYS_SEMGET           = 221;
const int SYS_SEMOP            = 222;
const int SYS___SEMCTL50       = 220;

// ---- IPC: SysV Shared Memory ----
const int SYS_SHMGET           = 228;
const int SYS_SHMAT            = 229;
const int SYS_SHMDT            = 230;
const int SYS___SHMCTL50       = 231;

// ---- POSIX Semaphores ----
const int SYS_SEM_OPEN         = 280;
const int SYS_SEM_CLOSE        = 281;
const int SYS_SEM_UNLINK       = 282;
const int SYS_SEM_WAIT         = 283;
const int SYS_SEM_TRYWAIT      = 284;
const int SYS_SEM_POST         = 285;
const int SYS_SEM_GETVALUE     = 286;
const int SYS_SEM_INIT         = 287;
const int SYS_SEM_DESTROY      = 288;

// ---- POSIX Message Queues ----
const int SYS_MQ_OPEN          = 406;
const int SYS_MQ_CLOSE         = 407;
const int SYS_MQ_UNLINK        = 408;
const int SYS_MQ_GETATTR       = 409;
const int SYS_MQ_SETATTR       = 410;
const int SYS_MQ_NOTIFY        = 411;
const int SYS_MQ_SEND          = 412;
const int SYS_MQ_RECEIVE       = 413;
const int SYS___MQ_TIMEDSEND50   = 415;
const int SYS___MQ_TIMEDRECEIVE50 = 416;

// ---- POSIX AIO ----
const int SYS_AIO_CANCEL       = 316;
const int SYS_AIO_ERROR        = 317;
const int SYS_AIO_FSYNC        = 318;
const int SYS_AIO_READ         = 319;
const int SYS_AIO_RETURN       = 320;
const int SYS___AIO_SUSPEND50  = 421;
const int SYS_AIO_WRITE        = 322;
const int SYS_LIO_LISTIO       = 323;

// ---- Module Control (replaces init_module / delete_module) ----
const int SYS_MODCTL           = 246;  // NetBSD kernel module management

// ---- ktrace ----
const int SYS_KTRACE           = 45;
const int SYS_FKTRACE          = 396;

// ---- Misc ----
const int SYS_GETCWD           = 304;
const int SYS___GETCWD         = 304;  // alias
const int SYS_REVOKE           = 56;
const int SYS_CHFLAGS          = 34;
const int SYS_FCHFLAGS         = 35;
const int SYS_LCHFLAGS         = 391;
const int SYS_ISSETUGID        = 305;
const int SYS_GETCONTEXT       = 307;
const int SYS_SETCONTEXT       = 308;
const int SYS___CLONE          = 487;  // NetBSD 9.0+: clone with flags (Linux compat helper)
const int SYS_RASCTL           = 376;  // Restartable Atomic Sequences (NetBSD)
const int SYS_FDISCARD         = 488;  // NetBSD 10.0+: discard file region (like fallocate PUNCH_HOLE)
const int SYS_POSIX_FALLOCATE  = 490;  // NetBSD 10.0+

// ---- Getrandom (NetBSD 10.0+) ----
const int SYS_GETRANDOM        = 491;

// ---- Misc process info ----
const int SYS_GETPEEREID       = 353;
const int SYS_EXTATTRCTL       = 360;
const int SYS_NTP_ADJTIME      = 176;  // __ntp_adjtime50
const int SYS___NTP_GETTIME50  = 448;

// ---- AArch64-specific: sysarch(2) sub-operations ----
// Passed as the first argument to SYS_SYSARCH; not separate syscall numbers.
// No x86-specific ops (LDT, FS/GS base, I/O port permissions) on AArch64.
const int AARCH64_GETMCONTEXT  = 0;   // get machine context (mcontext_t) for signal frame
const int AARCH64_SETMCONTEXT  = 1;   // set machine context
const int AARCH64_GET_TCBPTR   = 2;   // get TLS base pointer (TPIDR_EL0)
const int AARCH64_SET_TCBPTR   = 3;   // set TLS base pointer

// ---- Deprecated / Compat (do NOT use in new code) ----
// These remain in the table for binary compatibility but are obsolete.
const int SYS_COMPAT_OCREAT    = 8;    // Obsolete creat(2)
const int SYS_COMPAT_OLSEEK    = 19;   // Obsolete lseek
const int SYS_COMPAT_OSTAT     = 38;   // Obsolete stat (4.3BSD)
const int SYS_COMPAT_ONICE     = 34;   // Obsolete nice
const int SYS_COMPAT_OSETHOSTNAME = 229; // Obsolete
const int SYS_COMPAT_OSEND     = 11;   // Obsolete send
const int SYS_COMPAT_ORECV     = 12;   // Obsolete recv
