// sys.syscall.openbsd.h.c3

// OpenBSD AArch64 BSD syscall numbers.
// Source: sys/kern/syscalls.master  (OpenBSD 7.5)
//         /usr/include/sys/syscall.h
//
// NOTES:
//   - OpenBSD syscall numbers are ARCHITECTURE-INDEPENDENT — the same table is
//     shared across x86_64 and AArch64. Only the calling convention differs.
//   - Calling convention (AArch64):
//       instruction : svc #0
//       number      : w8  (low 32 bits of x8)
//       arguments   : x0–x5  (up to 6 args)
//       return      : x0  (negative = errno negated)
//   - OpenBSD aggressively removes obsolete/dangerous syscalls.
//     Entries marked "// Obsolete" are gaps in the table (return ENOSYS).
//   - OpenBSD-specific security primitives: pledge(2), unveil(2), getentropy(2), kbind(2).
//   - No epoll, io_uring, BPF, futex, or inotify — use kqueue(2) instead.
//   - W^X is strictly enforced; mmap(PROT_WRITE|PROT_EXEC) is rejected by default.
//   - AArch64-specific: SYS_SYSARCH is used for CPU feature queries and TLS base
//     (e.g. ARM_SYNC_ICACHE, ARM_DRAIN_WRITEBUF, ARM64_SET_TCB).
//   - No SYS_MODIFY_LDT or SYS_SET_THREAD_AREA (x86-only concepts).

module c::sys::syscall @if(env::OPENBSD && env::AARCH64);

// Standard BSD syscall wrapper.
// libc issues svc #0 with the number in w8 on AArch64.
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
const int SYS_GETPPID          = 39;
const int SYS_GETEGID          = 43;
const int SYS_GETGID           = 47;
const int SYS_GETLOGIN         = 49;
const int SYS_SETLOGIN         = 50;
const int SYS_ACCT             = 51;
const int SYS_VFORK            = 66;
const int SYS_EXECVE           = 59;
const int SYS_GETPGRP          = 81;
const int SYS_SETPGID          = 82;
const int SYS_GETDTABLECOUNT   = 89;    // OpenBSD-specific: open fd count
const int SYS_GETPGID          = 151;
const int SYS_SETSID           = 147;
const int SYS_GETSID           = 310;
const int SYS_KILL             = 37;
const int SYS_GETLOGIN_R       = 303;
const int SYS_PTRACE           = 26;
const int SYS_REBOOT           = 55;
const int SYS_ISSETUGID        = 253;
const int SYS_GETTHRID         = 299;   // OpenBSD thread ID
const int SYS_TFORK            = 8;     // OpenBSD thread fork
const int SYS___TFORK          = 8;     // alias
const int SYS___THREXIT        = 302;   // OpenBSD thread exit
const int SYS___THRSIGDIVERT   = 307;
const int SYS___THRSLEEP       = 300;
const int SYS___THRWAKEUP      = 301;
const int SYS___SET_TCB        = 329;
const int SYS___GET_TCB        = 330;
const int SYS_FORK2            = 251;   // internal
const int SYS_WAIT6            = 393;

// ---- User / Group IDs ----
const int SYS_SETREUID         = 126;
const int SYS_SETREGID         = 127;
const int SYS_GETGROUPS        = 79;
const int SYS_SETGROUPS        = 80;
const int SYS_SETRESUID        = 317;
const int SYS_GETRESUID        = 318;
const int SYS_SETRESGID        = 322;
const int SYS_GETRESGID        = 323;

// ---- File I/O ----
const int SYS_READ             = 3;
const int SYS_WRITE            = 4;
const int SYS_OPEN             = 5;
const int SYS_CLOSE            = 6;
const int SYS_PREAD            = 173;
const int SYS_PWRITE           = 174;
const int SYS_READV            = 120;
const int SYS_WRITEV           = 121;
const int SYS_PREADV           = 358;
const int SYS_PWRITEV          = 359;
const int SYS_LSEEK            = 199;
const int SYS_DUP              = 41;
const int SYS_DUP2             = 90;
const int SYS_DUP3             = 352;
const int SYS_PIPE             = 42;
const int SYS_PIPE2            = 354;
const int SYS_FCNTL            = 92;
const int SYS_IOCTL            = 54;
const int SYS_FLOCK            = 131;
const int SYS_FSYNC            = 95;
const int SYS_FDATASYNC        = 241;
const int SYS_SELECT           = 93;
const int SYS_PSELECT          = 271;
const int SYS_POLL             = 252;
const int SYS_PPOLL            = 346;
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
const int SYS_MKFIFO           = 132;
const int SYS_RENAME           = 128;
const int SYS_MKDIR            = 136;
const int SYS_RMDIR            = 137;
const int SYS_UTIMES           = 138;
const int SYS_FUTIMES          = 206;
const int SYS_TRUNCATE         = 200;
const int SYS_FTRUNCATE        = 201;
const int SYS_LCHOWN           = 254;
const int SYS_LCHFLAGS         = 391;
const int SYS_LUTIMES          = 335;
const int SYS_UNDELETE         = 205;
const int SYS_REVOKE_CPATH     = 0;    // Not available on OpenBSD

// ---- Filesystem — "at"-variants ----
const int SYS_OPENAT           = 342;
const int SYS_FSTATAT          = 42;    // Note: at slot 42 in OpenBSD 7.x table
const int SYS_RENAMEAT         = 360;
const int SYS_FACCESSAT        = 363;
const int SYS_FCHMODAT         = 364;
const int SYS_FCHOWNAT         = 365;
const int SYS_LINKAT           = 357;
const int SYS_UNLINKAT         = 353;
const int SYS_READLINKAT       = 355;
const int SYS_SYMLINKAT        = 356;
const int SYS_MKDIRAT          = 361;
const int SYS_MKFIFOAT         = 362;
const int SYS_MKNODAT          = 392;
const int SYS_UTIMENSAT        = 348;
const int SYS_FUTIMENS         = 349;

// ---- Stat / Filesystem Info ----
const int SYS_STAT             = 188;   // obsoleted; use fstatat or statx
const int SYS_LSTAT            = 190;   // obsoleted; use fstatat
const int SYS_FSTAT            = 189;
const int SYS_STATFS           = 256;
const int SYS_FSTATFS          = 257;
const int SYS_GETFSSTAT        = 63;

// ---- Directory Entries ----
const int SYS_GETDENTS         = 272;   // OpenBSD uses getdents, not getdents64

// ---- Extended Attributes (OpenBSD does NOT support xattr) ----
// OpenBSD intentionally omits POSIX extended attributes.
// Use chflags(2) for BSD file flags instead.

// ---- Mount / Unmount ----
const int SYS_MOUNT            = 21;
const int SYS_UNMOUNT          = 22;
const int SYS_PIVOT_ROOT       = 0;    // Not available on OpenBSD
const int SYS_SWAPON           = 85;
const int SYS_SWAPCTL          = 198;
const int SYS_QUOTACTL         = 148;
const int SYS_NFSSVC           = 155;

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
const int SYS_MQUERY           = 347;   // OpenBSD: find address range for mmap
const int SYS_SHM_OPEN         = 295;
const int SYS_SHM_UNLINK       = 296;
const int SYS_SHM_OPEN2        = 425;   // OpenBSD 6.x+

// ---- Networking / Sockets ----
const int SYS_SOCKET           = 97;
const int SYS_BIND             = 104;
const int SYS_LISTEN           = 106;
const int SYS_ACCEPT           = 30;
const int SYS_ACCEPT4          = 93;    // Note: OpenBSD puts accept4 at 93, select moved to pselect
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
const int SYS_RECVMMSG         = 383;
const int SYS_SENDMMSG         = 382;

// ---- kqueue / kevent ----
const int SYS_KQUEUE           = 269;
const int SYS_KEVENT           = 270;
const int SYS_KQUEUE1          = 394;   // OpenBSD 6.x: kqueue with flags

// ---- Signals ----
const int SYS_SIGACTION        = 46;
const int SYS_SIGPROCMASK      = 48;
const int SYS_SIGPENDING       = 52;
const int SYS_SIGALTSTACK      = 53;
const int SYS_SIGSUSPEND       = 111;
const int SYS_KILL             = 37;
const int SYS_TKILL            = 0;    // Not available; use kill(pid, sig) on OpenBSD
const int SYS_SIGRETURN        = 103;
const int SYS___SIGACTION_SIGTRAMP = 340;
const int SYS_SIGWAIT          = 311;

// ---- POSIX Threads (via rfork/tfork — no clone on OpenBSD) ----
// OpenBSD uses __tfork() for thread creation, not clone().
// All pthreads are implemented in userspace via libpthread + __tfork.
// No SYS_CLONE, SYS_FUTEX, or SYS_SET_THREAD_AREA.

// ---- Time ----
const int SYS_GETTIMEOFDAY     = 116;
const int SYS_SETTIMEOFDAY     = 122;
const int SYS_ADJTIME          = 140;
const int SYS_CLOCK_GETTIME    = 232;
const int SYS_CLOCK_SETTIME    = 233;
const int SYS_CLOCK_GETRES     = 234;
const int SYS_NANOSLEEP        = 240;
const int SYS_CLOCK_NANOSLEEP  = 392;
const int SYS_GETITIMER        = 86;
const int SYS_SETITIMER        = 83;
const int SYS_TIMER_CREATE     = 0;    // Not available; use setitimer or kqueue EVFILT_TIMER
const int SYS_TIMES            = 0;    // Not available on OpenBSD

// ---- Scheduling / Priority ----
const int SYS_GETPRIORITY      = 100;
const int SYS_SETPRIORITY      = 96;
const int SYS_SCHED_YIELD      = 298;
const int SYS_SCHED_SETPARAM   = 0;    // Not available; OpenBSD uses a simple scheduler
const int SYS_SCHED_GETPARAM   = 0;
const int SYS_IOPOLICYSYS      = 0;    // Not available on OpenBSD

// ---- Resource Limits ----
const int SYS_GETRLIMIT        = 194;
const int SYS_SETRLIMIT        = 195;
const int SYS_GETRUSAGE        = 117;
const int SYS_PROFIL           = 44;

// ---- System Info / sysctl ----
const int SYS_SYSCTL           = 202;
const int SYS_UNAME            = 0;    // Not a syscall; use sysctl(CTL_KERN, KERN_OSTYPE)
const int SYS_SYSLOG           = 116;  // via syslogd; no direct kernel syscall

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

// ---- POSIX Message Queues ----
// Not available on OpenBSD.

// ---- POSIX AIO ----
const int SYS_AIO_READ         = 375;
const int SYS_AIO_WRITE        = 376;
const int SYS_LIO_LISTIO       = 377;
const int SYS_AIO_ERROR        = 378;
const int SYS_AIO_RETURN       = 379;
const int SYS_AIO_SUSPEND      = 380;
const int SYS_AIO_CANCEL       = 381;
const int SYS_AIO_FSYNC        = 384;

// ---- ktrace / ktrace security ----
const int SYS_KTRACE           = 45;
const int SYS_FKTRACE          = 396;

// ---- Debug / Core ----
const int SYS_PTRACE           = 26;

// ---- Misc ----
const int SYS_GETCWD           = 304;
const int SYS_GETDTABLESIZE    = 89;   // alias of getdtablecount
const int SYS_SYNC             = 36;
const int SYS_SYSARCH          = 165;  // AArch64 arch-specific (ARM64_SET_TCB, ARM_SYNC_ICACHE, ARM_DRAIN_WRITEBUF)
const int SYS_CHFLAGS          = 34;
const int SYS_FCHFLAGS         = 35;

// ---- OpenBSD Security Extensions ----

// pledge(2): restrict process capabilities to declared set (OpenBSD 5.9+)
const int SYS_PLEDGE           = 335;

// unveil(2): limit filesystem visibility (OpenBSD 6.4+)
const int SYS_UNVEIL           = 340;

// getentropy(2): cryptographically secure random bytes (OpenBSD 5.6+)
// NOTE: getentropy is exposed as a libc call backed by a sysctl on OpenBSD.
// The actual kernel entry point is via sysctl(KERN_ARND); no direct syscall number.
// On OpenBSD, always use getentropy(3) from libc.

// kbind(2): W^X kernel binding for PLT/GOT entries (OpenBSD 6.0+, internal)
const int SYS_KBIND            = 339;

// sendsyslog(2): send message to kernel log without /dev/log (OpenBSD 5.7+)
const int SYS_SENDSYSLOG       = 332;

// closefrom(2): close all fds >= lowfd (OpenBSD 3.7+)
const int SYS_CLOSEFROM        = 328;

// execveat is not available on OpenBSD.
// clone, futex, BPF, io_uring, landlock are not available on OpenBSD.
// Use kqueue(2) / kevent(2) for all event notification.

// ---- AArch64-specific: sysarch(2) sub-operations ----
// Passed as the first argument to SYS_SYSARCH; not separate syscall numbers.
const int ARM64_SET_TCB        = 256;  // set thread control block (TLS) pointer in TPIDR_EL0
const int ARM64_GET_TCB        = 257;  // get thread control block pointer
const int ARM_SYNC_ICACHE      = 0;    // flush instruction cache range (also works on AArch64)
const int ARM_DRAIN_WRITEBUF   = 1;    // drain write buffer / DSB
