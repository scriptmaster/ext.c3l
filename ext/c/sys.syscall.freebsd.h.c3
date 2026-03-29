// sys.syscall.freebsd.h.c3
//
// FreeBSD syscall numbers — x86_64 and AArch64.
// Source: sys/kern/syscalls.master  (FreeBSD 14.1)
//         /usr/include/sys/syscall.h
//
// NOTES:
//   - FreeBSD syscall numbers are ARCHITECTURE-INDEPENDENT — the same table is
//     shared across x86_64 and AArch64. Only the calling convention differs.
//   - FreeBSD retains legacy BSD syscalls (open, fork, stat, dup2, pipe, select …).
//   - Threads via rfork(2) + thr_*(2) syscalls; no clone/futex.
//   - umtx_op(2) is the FreeBSD equivalent of Linux futex.
//   - No epoll, io_uring, inotify, or BPF sockets — use kqueue(2) / kevent(2).
//   - capsicum(4) provides capability-based sandboxing (cap_enter, cap_rights_limit).
//   - Compat syscalls (COMPAT_FREEBSD4 … COMPAT_FREEBSD12) remain in the table
//     for binary compat; do NOT use them in new code.

// ========== x86_64 ==========
//
// Calling convention:
//   instruction : syscall
//   number      : %rax
//   arguments   : %rdi  %rsi  %rdx  %r10  %r8  %r9
//   return      : %rax  (%rcx and %r11 are clobbered)
//   error flag  : carry flag set; errno = (int)%rax

module c::sys::syscall @if(env::FREEBSD && env::X86_64);

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
const int SYS_GETSID           = 310;
const int SYS_KILL             = 37;
const int SYS_REBOOT           = 55;
const int SYS_RFORK            = 251;   // FreeBSD thread/process creation primitive
const int SYS_EXECVEAT         = 578;   // FreeBSD 14.0+
const int SYS_POSIX_SPAWN      = 474;
const int SYS_WAIT6            = 532;
const int SYS_PDFORK           = 518;   // Capsicum: fork returning a process descriptor
const int SYS_PDGETPID         = 520;   // Capsicum: get pid from process descriptor
const int SYS_PDKILL           = 519;   // Capsicum: kill via process descriptor
const int SYS_PDWAIT4          = 0;     // Not yet in stable (use wait6 with P_PID)
const int SYS_PROCCTL          = 544;   // Process control (PROC_REAP_*, PROC_TRACE_CTL …)

// ---- FreeBSD Threads (thr_*) ----
// FreeBSD uses rfork + thr_* instead of clone/futex.
const int SYS_THR_CREATE       = 430;
const int SYS_THR_EXIT         = 431;
const int SYS_THR_SELF         = 432;
const int SYS_THR_KILL         = 433;
const int SYS_THR_KILL2        = 481;
const int SYS_THR_SUSPEND      = 442;
const int SYS_THR_WAKE         = 443;
const int SYS_THR_SET_NAME     = 464;
const int SYS_THR_NEW          = 455;

// ---- umtx_op (FreeBSD futex equivalent) ----
const int SYS__UMTX_OP         = 454;
// Sub-operations passed as first argument to _umtx_op:
const int UMTX_OP_LOCK         = 0;
const int UMTX_OP_UNLOCK       = 1;
const int UMTX_OP_WAIT         = 2;
const int UMTX_OP_WAKE         = 3;
const int UMTX_OP_MUTEX_TRYLOCK = 4;
const int UMTX_OP_MUTEX_LOCK   = 5;
const int UMTX_OP_MUTEX_UNLOCK = 6;
const int UMTX_OP_SET_CEILING  = 7;
const int UMTX_OP_CV_WAIT      = 8;
const int UMTX_OP_CV_SIGNAL    = 9;
const int UMTX_OP_CV_BROADCAST = 10;
const int UMTX_OP_WAIT_UINT    = 11;
const int UMTX_OP_RW_RDLOCK    = 12;
const int UMTX_OP_RW_WRLOCK    = 13;
const int UMTX_OP_RW_UNLOCK    = 14;
const int UMTX_OP_WAIT_UINT_PRIVATE = 15;
const int UMTX_OP_WAKE_PRIVATE = 16;
const int UMTX_OP_MUTEX_WAIT   = 17;
const int UMTX_OP_SEM_WAIT     = 18;  // POSIX sem_wait kernel path
const int UMTX_OP_SEM_WAKE     = 19;
const int UMTX_OP_SEM2_WAIT    = 22;
const int UMTX_OP_SEM2_WAKE    = 23;
const int UMTX_OP_NWAKE_PRIVATE = 31;
const int UMTX_OP_MUTEX_WAKE2  = 32;
const int UMTX_OP_ROBUST_LISTS  = 33;

// ---- User / Group IDs ----
const int SYS_SETREUID         = 126;
const int SYS_SETREGID         = 127;
const int SYS_GETGROUPS        = 79;
const int SYS_SETGROUPS        = 80;
const int SYS_SETRESUID        = 311;
const int SYS_GETRESUID        = 312;
const int SYS_SETRESGID        = 313;
const int SYS_GETRESGID        = 314;
const int SYS_ISSETUGID        = 253;

// ---- File I/O ----
const int SYS_READ             = 3;
const int SYS_WRITE            = 4;
const int SYS_OPEN             = 5;
const int SYS_CLOSE            = 6;
const int SYS_PREAD            = 475;   // pread (current; replaces compat_pread)
const int SYS_PWRITE           = 476;
const int SYS_READV            = 120;
const int SYS_WRITEV           = 121;
const int SYS_PREADV           = 289;
const int SYS_PWRITEV          = 290;
const int SYS_LSEEK            = 478;
const int SYS_DUP              = 41;
const int SYS_DUP2             = 90;
const int SYS_DUP3             = 530;
const int SYS_PIPE             = 42;
const int SYS_PIPE2            = 542;
const int SYS_FCNTL            = 92;
const int SYS_IOCTL            = 54;
const int SYS_FLOCK            = 131;
const int SYS_FSYNC            = 95;
const int SYS_FDATASYNC        = 550;   // FreeBSD 12.0+
const int SYS_SELECT           = 93;
const int SYS_PSELECT          = 522;
const int SYS_POLL             = 252;
const int SYS_PPOLL            = 545;   // FreeBSD 11.3+
const int SYS_READLINK         = 58;
const int SYS_SENDFILE         = 473;
const int SYS_COPY_FILE_RANGE  = 569;   // FreeBSD 13.0+

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
const int SYS_CHFLAGSAT        = 553;
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
const int SYS_TRUNCATE         = 479;
const int SYS_FTRUNCATE        = 480;
const int SYS_LCHOWN           = 254;
const int SYS_LCHFLAGS         = 391;
const int SYS_UNDELETE         = 205;

// ---- Filesystem — "at"-variants ----
const int SYS_OPENAT           = 499;
const int SYS_FACCESSAT        = 489;
const int SYS_FCHMODAT         = 490;
const int SYS_FCHOWNAT         = 491;
const int SYS_FSTATAT          = 493;
const int SYS_FUTIMESAT        = 494;
const int SYS_LINKAT           = 495;
const int SYS_MKDIRAT          = 496;
const int SYS_MKFIFOAT         = 497;
const int SYS_MKNODAT          = 498;
const int SYS_READLINKAT       = 500;
const int SYS_RENAMEAT         = 501;
const int SYS_SYMLINKAT        = 502;
const int SYS_UNLINKAT         = 503;
const int SYS_UTIMENSAT        = 547;
const int SYS_FUTIMENS         = 546;
const int SYS_RENAMEAT2        = 572;   // FreeBSD 14.0+

// ---- Stat / Filesystem Info ----
const int SYS_FSTAT            = 551;   // fstat (current; replaces compat versions)
const int SYS_LSTAT            = 552;
const int SYS_STAT             = 554;
const int SYS_STATFS           = 555;
const int SYS_FSTATFS          = 556;
const int SYS_GETFSSTAT        = 557;
const int SYS_FHSTATFS         = 397;
const int SYS_GETFH            = 161;
const int SYS_FHOPEN           = 298;
const int SYS_STATX            = 564;   // FreeBSD 13.1+
// Note: FreeBSD uses versioned compat wrappers internally (freebsd11_stat etc.)
// Always use the unversioned libc wrappers; they resolve to the current version.

// ---- Directory Entries ----
const int SYS_GETDENTS         = 272;   // COMPAT_FREEBSD (returns old dirent)
const int SYS_GETDIRENTRIES    = 554;   // current getdirentries with basep

// ---- Extended Attributes (FreeBSD extattr) ----
// FreeBSD uses extattr_* with namespaces (EXTATTR_NAMESPACE_USER / SYSTEM).
const int SYS_EXTATTR_SET_FILE     = 339;
const int SYS_EXTATTR_GET_FILE     = 340;
const int SYS_EXTATTR_DELETE_FILE  = 341;
const int SYS_EXTATTR_SET_FD       = 371;
const int SYS_EXTATTR_GET_FD       = 372;
const int SYS_EXTATTR_DELETE_FD    = 373;
const int SYS_EXTATTR_SET_LINK     = 374;
const int SYS_EXTATTR_GET_LINK     = 375;
const int SYS_EXTATTR_DELETE_LINK  = 376;
const int SYS_EXTATTR_LIST_FD      = 377;
const int SYS_EXTATTR_LIST_FILE    = 378;
const int SYS_EXTATTR_LIST_LINK    = 379;

// ---- Mount / Unmount ----
const int SYS_MOUNT            = 21;
const int SYS_UNMOUNT          = 22;
const int SYS_SWAPON           = 85;
const int SYS_SWAPOFF          = 424;
const int SYS_QUOTACTL         = 148;
const int SYS_NFSSVC           = 155;
const int SYS_PIVOT_ROOT       = 0;    // Not available on FreeBSD

// ---- Memory Management ----
const int SYS_MMAP             = 477;
const int SYS_MUNMAP           = 73;
const int SYS_MPROTECT         = 74;
const int SYS_MADVISE          = 75;
const int SYS_MSYNC            = 65;
const int SYS_MINCORE          = 78;
const int SYS_MLOCK            = 203;
const int SYS_MUNLOCK          = 204;
const int SYS_MLOCKALL         = 324;
const int SYS_MUNLOCKALL       = 325;
const int SYS_MINHERIT         = 250;
const int SYS_MCONTROL         = 0;    // Not available
const int SYS_SHM_OPEN         = 295;
const int SYS_SHM_UNLINK       = 296;
const int SYS_SHM_OPEN2        = 571;  // FreeBSD 13.0+: with flags
const int SYS_SHM_RENAME       = 566;  // FreeBSD 13.0+
const int SYS_MEMFD_CREATE     = 570;  // FreeBSD 13.0+

// ---- Networking / Sockets ----
const int SYS_SOCKET           = 97;
const int SYS_BIND             = 104;
const int SYS_LISTEN           = 106;
const int SYS_ACCEPT           = 30;
const int SYS_ACCEPT4          = 541;
const int SYS_CONNECT          = 98;
const int SYS_CONNECTAT        = 516;   // Capsicum: connect relative to fd
const int SYS_BINDAT           = 515;   // Capsicum: bind relative to fd
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
const int SYS_SENDMMSG         = 560;   // FreeBSD 11.0+
const int SYS_RECVMMSG         = 559;   // FreeBSD 11.0+
const int SYS_SCTP_PEELOFF     = 471;
const int SYS_SCTP_GENERIC_SENDMSG    = 472;
const int SYS_SCTP_GENERIC_RECVMSG   = 470;

// ---- kqueue / kevent ----
const int SYS_KQUEUE           = 362;
const int SYS_KEVENT           = 363;
const int SYS_KQUEUE1          = 521;   // FreeBSD 12.0+: with O_CLOEXEC
const int SYS_KEVENT_QOS       = 0;    // Not available (Darwin-only concept)

// ---- Signals ----
const int SYS_SIGACTION        = 416;   // current __sigaction
const int SYS_SIGPROCMASK      = 340;
const int SYS_SIGPENDING       = 343;
const int SYS_SIGALTSTACK      = 53;
const int SYS_SIGSUSPEND       = 111;
const int SYS_SIGTIMEDWAIT     = 345;
const int SYS_SIGWAIT          = 429;
const int SYS_SIGWAITINFO      = 346;
const int SYS_SIGQUEUE         = 417;
const int SYS_SIGRETURN        = 417;   // internal; use sigaction(2)
const int SYS_KILL             = 37;
const int SYS_PDKILL           = 519;   // Capsicum: send signal via process descriptor
const int SYS_TGKILL           = 0;    // Not available; use thr_kill2

// ---- Time ----
const int SYS_GETTIMEOFDAY     = 116;
const int SYS_SETTIMEOFDAY     = 122;
const int SYS_ADJTIME          = 140;
const int SYS_CLOCK_GETTIME    = 232;
const int SYS_CLOCK_SETTIME    = 233;
const int SYS_CLOCK_GETRES     = 234;
const int SYS_CLOCK_NANOSLEEP  = 235;
const int SYS_NANOSLEEP        = 240;
const int SYS_GETITIMER        = 86;
const int SYS_SETITIMER        = 83;
const int SYS_TIMER_CREATE     = 235;
const int SYS_TIMER_DELETE     = 236;
const int SYS_TIMER_SETTIME    = 237;
const int SYS_TIMER_GETTIME    = 238;
const int SYS_TIMER_GETOVERRUN = 239;
const int SYS_CLOCK_GETCPUCLOCKID2 = 558;  // FreeBSD 12.0+
const int SYS_NTP_ADJTIME      = 176;
const int SYS_NTP_GETTIME      = 248;

// ---- Scheduling / Priority ----
const int SYS_GETPRIORITY      = 100;
const int SYS_SETPRIORITY      = 96;
const int SYS_SCHED_YIELD      = 331;
const int SYS_SCHED_SETPARAM   = 327;
const int SYS_SCHED_GETPARAM   = 328;
const int SYS_SCHED_SETSCHEDULER  = 329;
const int SYS_SCHED_GETSCHEDULER  = 330;
const int SYS_SCHED_GET_PRIORITY_MAX = 332;
const int SYS_SCHED_GET_PRIORITY_MIN = 333;
const int SYS_SCHED_RR_GET_INTERVAL  = 334;
const int SYS_SCHED_SETAFFINITY   = 487;
const int SYS_SCHED_GETAFFINITY   = 488;
const int SYS_CPUSET             = 484;
const int SYS_CPUSET_SETID       = 485;
const int SYS_CPUSET_GETID       = 486;
const int SYS_CPUSET_SETAFFINITY = 487;
const int SYS_CPUSET_GETAFFINITY = 488;

// ---- Resource Limits ----
const int SYS_GETRLIMIT        = 194;
const int SYS_SETRLIMIT        = 195;
const int SYS_GETRUSAGE        = 117;
const int SYS_PRLIMIT          = 563;   // FreeBSD 13.1+

// ---- System Info / sysctl ----
const int SYS___SYSCTL         = 202;
const int SYS_UNAME            = 0;    // Not a raw syscall; use uname(3) via __sysctl

// ---- Module Control ----
const int SYS_MODFNEXT         = 303;
const int SYS_MODFIND          = 304;
const int SYS_KLDLOAD          = 304;
const int SYS_KLDUNLOAD        = 305;
const int SYS_KLDFIND          = 306;
const int SYS_KLDNEXT          = 307;
const int SYS_KLDSTAT          = 308;
const int SYS_KLDFIRSTMOD      = 309;
const int SYS_KLDUNLOADF       = 444;

// ---- IPC: SysV Message Queues ----
const int SYS_MSGGET           = 225;
const int SYS_MSGSND           = 226;
const int SYS_MSGRCV           = 227;
const int SYS_MSGCTL           = 224;

// ---- IPC: SysV Semaphores ----
const int SYS_SEMGET           = 221;
const int SYS_SEMOP            = 222;
const int SYS_SEMCTL           = 220;

// ---- IPC: SysV Shared Memory ----
const int SYS_SHMGET           = 228;
const int SYS_SHMAT            = 229;
const int SYS_SHMDT            = 230;
const int SYS_SHMCTL           = 231;

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
const int SYS_MQ_OPEN          = 457;
const int SYS_MQ_SETATTR       = 458;
const int SYS_MQ_TIMEDRECEIVE  = 459;
const int SYS_MQ_TIMEDSEND     = 460;
const int SYS_MQ_NOTIFY        = 461;
const int SYS_MQ_UNLINK        = 462;

// ---- POSIX AIO ----
const int SYS_AIO_CANCEL       = 316;
const int SYS_AIO_ERROR        = 317;
const int SYS_AIO_FSYNC        = 318;
const int SYS_AIO_READ         = 319;
const int SYS_AIO_RETURN       = 320;
const int SYS_AIO_SUSPEND      = 322;
const int SYS_AIO_WAITCOMPLETE = 449;
const int SYS_AIO_WRITE        = 323;
const int SYS_LIO_LISTIO       = 324;
const int SYS_AIO_MLOCK        = 543;   // FreeBSD 10.0+

// ---- Capsicum (capability sandboxing) ----
const int SYS_CAP_ENTER        = 516;
const int SYS_CAP_GETMODE      = 517;
const int SYS_CAP_RIGHTS_LIMIT = 533;
const int SYS_CAP_RIGHTS_GET   = 515;
const int SYS_CAP_IOCTLS_LIMIT = 534;
const int SYS_CAP_IOCTLS_GET   = 535;
const int SYS_CAP_FCNTLS_LIMIT = 536;
const int SYS_CAP_FCNTLS_GET   = 537;

// ---- MAC (TrustedBSD Mandatory Access Control) ----
const int SYS___MAC_GET_PROC   = 449;
const int SYS___MAC_SET_PROC   = 450;
const int SYS___MAC_GET_FD     = 451;
const int SYS___MAC_GET_FILE   = 452;
const int SYS___MAC_SET_FD     = 453;
const int SYS___MAC_SET_FILE   = 454;
const int SYS___MAC_GET_PID    = 489;
const int SYS___MAC_GET_LINK   = 469;
const int SYS___MAC_SET_LINK   = 470;
const int SYS___MAC_EXECVE     = 468;
const int SYS___MAC_SYSCALL    = 438;

// ---- ktrace ----
const int SYS_KTRACE           = 45;
const int SYS_UTRACE           = 335;   // user-level ktrace annotation

// ---- Misc ----
const int SYS_GETCWD           = 326;
const int SYS_REVOKE           = 56;
const int SYS_SYSARCH          = 165;   // x86_64: set FS/GS base, get/set CPU id, I/O ports
const int SYS_LCHFLAGS         = 391;
const int SYS_ISSETUGID        = 253;
const int SYS_GETPEEREID       = 353;
const int SYS_SETCONTEXT       = 421;
const int SYS_GETCONTEXT       = 420;
const int SYS_SWAPCONTEXT      = 422;
const int SYS_PROFIL           = 44;
const int SYS_GETRANDOM        = 563;   // FreeBSD 12.0+

// ---- x86_64-specific sysarch sub-operations ----
// Passed as first arg to SYS_SYSARCH.
const int AMD64_GET_FSBASE     = 128;   // get FS segment base (TLS)
const int AMD64_SET_FSBASE     = 129;   // set FS segment base (TLS)
const int AMD64_GET_GSBASE     = 130;   // get GS segment base
const int AMD64_SET_GSBASE     = 131;   // set GS segment base






// ========== AArch64 ==========
//
// Syscall numbers are identical to x86_64 above (architecture-independent table).
// Calling convention:
//   instruction : svc #0
//   number      : x8
//   arguments   : x0  x1  x2  x3  x4  x5
//   return      : x0  (negative errno on error)
//
// Differences from x86_64:
//   - SYS_SYSARCH sub-operations are AArch64-specific (TLS via TPIDR_EL0).
//   - No LDT, FS/GS base, iopl, ioperm concepts.

module c::sys::syscall @if(env::FREEBSD && env::AARCH64);

extern fn long syscall(int number, ...);

// All BSD syscall numbers are shared with x86_64 — see module above.
// Only the sysarch sub-operations differ; they are listed below.
// Rather than duplicating ~300 constants, import or reference the x86_64 set.
// The constants below are the ONLY AArch64-specific values.

// ---- Syscall 0 ----
const int SYS_SYSCALL          = 0;

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
const int SYS_GETSID           = 310;
const int SYS_KILL             = 37;
const int SYS_REBOOT           = 55;
const int SYS_RFORK            = 251;
const int SYS_EXECVEAT         = 578;
const int SYS_POSIX_SPAWN      = 474;
const int SYS_WAIT6            = 532;
const int SYS_PDFORK           = 518;
const int SYS_PDGETPID         = 520;
const int SYS_PDKILL           = 519;
const int SYS_PROCCTL          = 544;

// ---- FreeBSD Threads (thr_*) ----
const int SYS_THR_CREATE       = 430;
const int SYS_THR_EXIT         = 431;
const int SYS_THR_SELF         = 432;
const int SYS_THR_KILL         = 433;
const int SYS_THR_KILL2        = 481;
const int SYS_THR_SUSPEND      = 442;
const int SYS_THR_WAKE         = 443;
const int SYS_THR_SET_NAME     = 464;
const int SYS_THR_NEW          = 455;

// ---- umtx_op ----
const int SYS__UMTX_OP         = 454;
const int UMTX_OP_LOCK         = 0;
const int UMTX_OP_UNLOCK       = 1;
const int UMTX_OP_WAIT         = 2;
const int UMTX_OP_WAKE         = 3;
const int UMTX_OP_MUTEX_TRYLOCK = 4;
const int UMTX_OP_MUTEX_LOCK   = 5;
const int UMTX_OP_MUTEX_UNLOCK = 6;
const int UMTX_OP_SET_CEILING  = 7;
const int UMTX_OP_CV_WAIT      = 8;
const int UMTX_OP_CV_SIGNAL    = 9;
const int UMTX_OP_CV_BROADCAST = 10;
const int UMTX_OP_WAIT_UINT    = 11;
const int UMTX_OP_RW_RDLOCK    = 12;
const int UMTX_OP_RW_WRLOCK    = 13;
const int UMTX_OP_RW_UNLOCK    = 14;
const int UMTX_OP_WAIT_UINT_PRIVATE = 15;
const int UMTX_OP_WAKE_PRIVATE = 16;
const int UMTX_OP_MUTEX_WAIT   = 17;
const int UMTX_OP_SEM_WAIT     = 18;
const int UMTX_OP_SEM_WAKE     = 19;
const int UMTX_OP_SEM2_WAIT    = 22;
const int UMTX_OP_SEM2_WAKE    = 23;
const int UMTX_OP_NWAKE_PRIVATE = 31;
const int UMTX_OP_MUTEX_WAKE2  = 32;
const int UMTX_OP_ROBUST_LISTS  = 33;

// ---- User / Group IDs ----
const int SYS_SETREUID         = 126;
const int SYS_SETREGID         = 127;
const int SYS_GETGROUPS        = 79;
const int SYS_SETGROUPS        = 80;
const int SYS_SETRESUID        = 311;
const int SYS_GETRESUID        = 312;
const int SYS_SETRESGID        = 313;
const int SYS_GETRESGID        = 314;
const int SYS_ISSETUGID        = 253;

// ---- File I/O ----
const int SYS_READ             = 3;
const int SYS_WRITE            = 4;
const int SYS_OPEN             = 5;
const int SYS_CLOSE            = 6;
const int SYS_PREAD            = 475;
const int SYS_PWRITE           = 476;
const int SYS_READV            = 120;
const int SYS_WRITEV           = 121;
const int SYS_PREADV           = 289;
const int SYS_PWRITEV          = 290;
const int SYS_LSEEK            = 478;
const int SYS_DUP              = 41;
const int SYS_DUP2             = 90;
const int SYS_DUP3             = 530;
const int SYS_PIPE             = 42;
const int SYS_PIPE2            = 542;
const int SYS_FCNTL            = 92;
const int SYS_IOCTL            = 54;
const int SYS_FLOCK            = 131;
const int SYS_FSYNC            = 95;
const int SYS_FDATASYNC        = 550;
const int SYS_SELECT           = 93;
const int SYS_PSELECT          = 522;
const int SYS_POLL             = 252;
const int SYS_PPOLL            = 545;
const int SYS_READLINK         = 58;
const int SYS_SENDFILE         = 473;
const int SYS_COPY_FILE_RANGE  = 569;

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
const int SYS_CHFLAGSAT        = 553;
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
const int SYS_TRUNCATE         = 479;
const int SYS_FTRUNCATE        = 480;
const int SYS_LCHOWN           = 254;
const int SYS_LCHFLAGS         = 391;
const int SYS_UNDELETE         = 205;

// ---- Filesystem — "at"-variants ----
const int SYS_OPENAT           = 499;
const int SYS_FACCESSAT        = 489;
const int SYS_FCHMODAT         = 490;
const int SYS_FCHOWNAT         = 491;
const int SYS_FSTATAT          = 493;
const int SYS_FUTIMESAT        = 494;
const int SYS_LINKAT           = 495;
const int SYS_MKDIRAT          = 496;
const int SYS_MKFIFOAT         = 497;
const int SYS_MKNODAT          = 498;
const int SYS_READLINKAT       = 500;
const int SYS_RENAMEAT         = 501;
const int SYS_SYMLINKAT        = 502;
const int SYS_UNLINKAT         = 503;
const int SYS_UTIMENSAT        = 547;
const int SYS_FUTIMENS         = 546;
const int SYS_RENAMEAT2        = 572;

// ---- Stat / Filesystem Info ----
const int SYS_FSTAT            = 551;
const int SYS_LSTAT            = 552;
const int SYS_STAT             = 554;
const int SYS_STATFS           = 555;
const int SYS_FSTATFS          = 556;
const int SYS_GETFSSTAT        = 557;
const int SYS_FHSTATFS         = 397;
const int SYS_GETFH            = 161;
const int SYS_FHOPEN           = 298;
const int SYS_STATX            = 564;

// ---- Directory Entries ----
const int SYS_GETDENTS         = 272;
const int SYS_GETDIRENTRIES    = 554;

// ---- Extended Attributes ----
const int SYS_EXTATTR_SET_FILE     = 339;
const int SYS_EXTATTR_GET_FILE     = 340;
const int SYS_EXTATTR_DELETE_FILE  = 341;
const int SYS_EXTATTR_SET_FD       = 371;
const int SYS_EXTATTR_GET_FD       = 372;
const int SYS_EXTATTR_DELETE_FD    = 373;
const int SYS_EXTATTR_SET_LINK     = 374;
const int SYS_EXTATTR_GET_LINK     = 375;
const int SYS_EXTATTR_DELETE_LINK  = 376;
const int SYS_EXTATTR_LIST_FD      = 377;
const int SYS_EXTATTR_LIST_FILE    = 378;
const int SYS_EXTATTR_LIST_LINK    = 379;

// ---- Mount / Unmount ----
const int SYS_MOUNT            = 21;
const int SYS_UNMOUNT          = 22;
const int SYS_SWAPON           = 85;
const int SYS_SWAPOFF          = 424;
const int SYS_QUOTACTL         = 148;
const int SYS_NFSSVC           = 155;

// ---- Memory Management ----
const int SYS_MMAP             = 477;
const int SYS_MUNMAP           = 73;
const int SYS_MPROTECT         = 74;
const int SYS_MADVISE          = 75;
const int SYS_MSYNC            = 65;
const int SYS_MINCORE          = 78;
const int SYS_MLOCK            = 203;
const int SYS_MUNLOCK          = 204;
const int SYS_MLOCKALL         = 324;
const int SYS_MUNLOCKALL       = 325;
const int SYS_MINHERIT         = 250;
const int SYS_SHM_OPEN         = 295;
const int SYS_SHM_UNLINK       = 296;
const int SYS_SHM_OPEN2        = 571;
const int SYS_SHM_RENAME       = 566;
const int SYS_MEMFD_CREATE     = 570;

// ---- Networking / Sockets ----
const int SYS_SOCKET           = 97;
const int SYS_BIND             = 104;
const int SYS_LISTEN           = 106;
const int SYS_ACCEPT           = 30;
const int SYS_ACCEPT4          = 541;
const int SYS_CONNECT          = 98;
const int SYS_CONNECTAT        = 516;
const int SYS_BINDAT           = 515;
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
const int SYS_SENDMMSG         = 560;
const int SYS_RECVMMSG         = 559;
const int SYS_SCTP_PEELOFF     = 471;
const int SYS_SCTP_GENERIC_SENDMSG   = 472;
const int SYS_SCTP_GENERIC_RECVMSG  = 470;

// ---- kqueue / kevent ----
const int SYS_KQUEUE           = 362;
const int SYS_KEVENT           = 363;
const int SYS_KQUEUE1          = 521;

// ---- Signals ----
const int SYS_SIGACTION        = 416;
const int SYS_SIGPROCMASK      = 340;
const int SYS_SIGPENDING       = 343;
const int SYS_SIGALTSTACK      = 53;
const int SYS_SIGSUSPEND       = 111;
const int SYS_SIGTIMEDWAIT     = 345;
const int SYS_SIGWAIT          = 429;
const int SYS_SIGWAITINFO      = 346;
const int SYS_SIGQUEUE         = 417;
const int SYS_KILL             = 37;
const int SYS_PDKILL           = 519;

// ---- Time ----
const int SYS_GETTIMEOFDAY     = 116;
const int SYS_SETTIMEOFDAY     = 122;
const int SYS_ADJTIME          = 140;
const int SYS_CLOCK_GETTIME    = 232;
const int SYS_CLOCK_SETTIME    = 233;
const int SYS_CLOCK_GETRES     = 234;
const int SYS_CLOCK_NANOSLEEP  = 235;
const int SYS_NANOSLEEP        = 240;
const int SYS_GETITIMER        = 86;
const int SYS_SETITIMER        = 83;
const int SYS_TIMER_CREATE     = 235;
const int SYS_TIMER_DELETE     = 236;
const int SYS_TIMER_SETTIME    = 237;
const int SYS_TIMER_GETTIME    = 238;
const int SYS_TIMER_GETOVERRUN = 239;
const int SYS_CLOCK_GETCPUCLOCKID2 = 558;
const int SYS_NTP_ADJTIME      = 176;
const int SYS_NTP_GETTIME      = 248;

// ---- Scheduling / Priority ----
const int SYS_GETPRIORITY      = 100;
const int SYS_SETPRIORITY      = 96;
const int SYS_SCHED_YIELD      = 331;
const int SYS_SCHED_SETPARAM   = 327;
const int SYS_SCHED_GETPARAM   = 328;
const int SYS_SCHED_SETSCHEDULER  = 329;
const int SYS_SCHED_GETSCHEDULER  = 330;
const int SYS_SCHED_GET_PRIORITY_MAX = 332;
const int SYS_SCHED_GET_PRIORITY_MIN = 333;
const int SYS_SCHED_RR_GET_INTERVAL  = 334;
const int SYS_SCHED_SETAFFINITY   = 487;
const int SYS_SCHED_GETAFFINITY   = 488;
const int SYS_CPUSET             = 484;
const int SYS_CPUSET_SETID       = 485;
const int SYS_CPUSET_GETID       = 486;
const int SYS_CPUSET_SETAFFINITY = 487;
const int SYS_CPUSET_GETAFFINITY = 488;

// ---- Resource Limits ----
const int SYS_GETRLIMIT        = 194;
const int SYS_SETRLIMIT        = 195;
const int SYS_GETRUSAGE        = 117;
const int SYS_PRLIMIT          = 563;

// ---- System Info / sysctl ----
const int SYS___SYSCTL         = 202;

// ---- Module Control ----
const int SYS_KLDLOAD          = 304;
const int SYS_KLDUNLOAD        = 305;
const int SYS_KLDFIND          = 306;
const int SYS_KLDNEXT          = 307;
const int SYS_KLDSTAT          = 308;
const int SYS_KLDFIRSTMOD      = 309;
const int SYS_KLDUNLOADF       = 444;

// ---- IPC ----
const int SYS_MSGGET           = 225;
const int SYS_MSGSND           = 226;
const int SYS_MSGRCV           = 227;
const int SYS_MSGCTL           = 224;
const int SYS_SEMGET           = 221;
const int SYS_SEMOP            = 222;
const int SYS_SEMCTL           = 220;
const int SYS_SHMGET           = 228;
const int SYS_SHMAT            = 229;
const int SYS_SHMDT            = 230;
const int SYS_SHMCTL           = 231;

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
const int SYS_MQ_OPEN          = 457;
const int SYS_MQ_SETATTR       = 458;
const int SYS_MQ_TIMEDRECEIVE  = 459;
const int SYS_MQ_TIMEDSEND     = 460;
const int SYS_MQ_NOTIFY        = 461;
const int SYS_MQ_UNLINK        = 462;

// ---- POSIX AIO ----
const int SYS_AIO_CANCEL       = 316;
const int SYS_AIO_ERROR        = 317;
const int SYS_AIO_FSYNC        = 318;
const int SYS_AIO_READ         = 319;
const int SYS_AIO_RETURN       = 320;
const int SYS_AIO_SUSPEND      = 322;
const int SYS_AIO_WAITCOMPLETE = 449;
const int SYS_AIO_WRITE        = 323;
const int SYS_LIO_LISTIO       = 324;
const int SYS_AIO_MLOCK        = 543;

// ---- Capsicum ----
const int SYS_CAP_ENTER        = 516;
const int SYS_CAP_GETMODE      = 517;
const int SYS_CAP_RIGHTS_LIMIT = 533;
const int SYS_CAP_RIGHTS_GET   = 515;
const int SYS_CAP_IOCTLS_LIMIT = 534;
const int SYS_CAP_IOCTLS_GET   = 535;
const int SYS_CAP_FCNTLS_LIMIT = 536;
const int SYS_CAP_FCNTLS_GET   = 537;

// ---- MAC ----
const int SYS___MAC_GET_PROC   = 449;
const int SYS___MAC_SET_PROC   = 450;
const int SYS___MAC_GET_FD     = 451;
const int SYS___MAC_GET_FILE   = 452;
const int SYS___MAC_SET_FD     = 453;
const int SYS___MAC_SET_FILE   = 454;
const int SYS___MAC_GET_PID    = 489;
const int SYS___MAC_GET_LINK   = 469;
const int SYS___MAC_SET_LINK   = 470;
const int SYS___MAC_EXECVE     = 468;
const int SYS___MAC_SYSCALL    = 438;

// ---- ktrace ----
const int SYS_KTRACE           = 45;
const int SYS_UTRACE           = 335;

// ---- Misc ----
const int SYS_GETCWD           = 326;
const int SYS_REVOKE           = 56;
const int SYS_SYSARCH          = 165;   // AArch64-specific sub-ops listed below
const int SYS_LCHFLAGS         = 391;
const int SYS_ISSETUGID        = 253;
const int SYS_GETPEEREID       = 353;
const int SYS_SETCONTEXT       = 421;
const int SYS_GETCONTEXT       = 420;
const int SYS_SWAPCONTEXT      = 422;
const int SYS_PROFIL           = 44;
const int SYS_GETRANDOM        = 563;

// ---- AArch64-specific sysarch sub-operations ----
// Passed as first arg to SYS_SYSARCH.
// No x86-specific ops (LDT, FS/GS base, iopl, ioperm) on AArch64.
const int AARCH64_GET_FSBASE   = 0;    // get TPIDR_EL0 (TLS base pointer)
const int AARCH64_SET_FSBASE   = 1;    // set TPIDR_EL0
const int AARCH64_SYNC_ICACHE  = 2;    // flush instruction cache range
