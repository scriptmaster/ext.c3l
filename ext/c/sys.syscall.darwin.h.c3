// sys.syscall.darwin.h.c3

module c::sys::syscall @if(env::DARWIN && env::X86_64);

// BSD syscall wrapper — libc adds the 0x2000000 class prefix automatically.
extern fn long syscall(int number, ...);

// ---- Syscall 0 ----
const int SYS_SYSCALL          = 0;   // indirect syscall (internal use)

// ---- Process ----
const int SYS_EXIT             = 1;
const int SYS_FORK             = 2;
const int SYS_VFORK            = 66;
const int SYS_EXECVE           = 59;
const int SYS_GETPID           = 20;
const int SYS_GETPPID          = 39;
const int SYS_GETPGRP          = 81;
const int SYS_SETPGID          = 82;
const int SYS_GETPGID          = 151;
const int SYS_SETSID           = 147;
const int SYS_GETSID           = 310;
const int SYS_WAIT4            = 7;
const int SYS_WAITID           = 173;
const int SYS_KILL             = 37;
const int SYS_GETLOGIN         = 49;
const int SYS_SETLOGIN         = 50;
const int SYS_PTRACE           = 26;
const int SYS_REBOOT           = 55;
const int SYS_ISSETUGID        = 327;
const int SYS_PROC_INFO        = 336;
const int SYS_PROC_RLIMIT_CONTROL = 446;
const int SYS_PERSONA          = 494;
const int SYS_POSIX_SPAWN      = 244;
const int SYS_BSDTHREAD_CREATE    = 360;
const int SYS_BSDTHREAD_TERMINATE = 361;
const int SYS_BSDTHREAD_REGISTER  = 366;
const int SYS_BSDTHREAD_CTL      = 478;
const int SYS_THREAD_SELFID      = 372;
const int SYS_THREAD_SELFUSAGE   = 482;
const int SYS_SETTID             = 285;
const int SYS_GETTID             = 286;
const int SYS_SETTID_WITH_PID    = 311;
const int SYS_LEDGER             = 373;
const int SYS_PID_SUSPEND        = 433;
const int SYS_PID_RESUME         = 434;
const int SYS_PID_HIBERNATE      = 435;
const int SYS_PID_SHUTDOWN_SOCKETS = 436;

// ---- User / Group IDs ----
const int SYS_GETUID           = 24;
const int SYS_GETEUID          = 25;
const int SYS_GETGID           = 47;
const int SYS_GETEGID          = 43;
const int SYS_SETUID           = 23;
const int SYS_SETGID           = 181;  // via setgid(2)
const int SYS_SETREUID         = 126;
const int SYS_SETREGID         = 127;
const int SYS_SETRESUID        = 208;
const int SYS_GETRESUID        = 209;
const int SYS_SETRESGID        = 210;
const int SYS_GETRESGID        = 211;
const int SYS_GETGROUPS        = 79;
const int SYS_SETGROUPS        = 80;
const int SYS_SETFSUID         = 138;  // no-op on Darwin; kept for compat
const int SYS_SETPRIVEXEC      = 152;
const int SYS_SETSGROUPS       = 287;
const int SYS_GETSGROUPS       = 288;
const int SYS_SETWGROUPS       = 289;
const int SYS_GETWGROUPS       = 290;
const int SYS_INITGROUPS       = 243;
const int SYS_IDENTITYSVC      = 293;

// ---- Signals ----
const int SYS_SIGACTION        = 46;
const int SYS_SIGPROCMASK      = 48;
const int SYS_SIGPENDING       = 52;
const int SYS_SIGALTSTACK      = 53;
const int SYS_SIGSUSPEND       = 111;
const int SYS___PTHREAD_KILL   = 328;
const int SYS___PTHREAD_SIGMASK = 329;
const int SYS___SIGWAIT        = 330;
const int SYS___DISABLE_THREADSIGNAL = 331;
const int SYS___PTHREAD_MARKCANCEL  = 332;
const int SYS___PTHREAD_CANCELED    = 333;
const int SYS___SEMWAIT_SIGNAL      = 334;
const int SYS___OLD_SEMWAIT_SIGNAL  = 370;  // Obsolete
const int SYS___OLD_SEMWAIT_SIGNAL_NOCANCEL = 371;  // Obsolete

// ---- File I/O ----
const int SYS_READ             = 3;
const int SYS_WRITE            = 4;
const int SYS_OPEN             = 5;
const int SYS_CLOSE            = 6;
const int SYS_PREAD            = 153;
const int SYS_PWRITE           = 154;
const int SYS_READV            = 120;
const int SYS_WRITEV           = 121;
const int SYS_LSEEK            = 199;
const int SYS_DUP              = 41;
const int SYS_DUP2             = 90;
const int SYS_PIPE             = 42;
const int SYS_FCNTL            = 92;
const int SYS_IOCTL            = 54;
const int SYS_FLOCK            = 131;
const int SYS_FSYNC            = 95;
const int SYS_FDATASYNC        = 169;
const int SYS_SELECT           = 93;

// ---- File I/O — nocancel variants ----
const int SYS_READ_NOCANCEL    = 396;
const int SYS_WRITE_NOCANCEL   = 397;
const int SYS_OPEN_NOCANCEL    = 398;
const int SYS_CLOSE_NOCANCEL   = 399;
const int SYS_WAIT4_NOCANCEL   = 400;
const int SYS_RECVMSG_NOCANCEL = 401;
const int SYS_SENDMSG_NOCANCEL = 402;
const int SYS_RECVFROM_NOCANCEL = 403;
const int SYS_ACCEPT_NOCANCEL  = 404;
const int SYS_MSYNC_NOCANCEL   = 405;
const int SYS_FCNTL_NOCANCEL   = 406;
const int SYS_SELECT_NOCANCEL  = 407;
const int SYS_FSYNC_NOCANCEL   = 408;
const int SYS_CONNECT_NOCANCEL = 409;
const int SYS_SIGSUSPEND_NOCANCEL = 410;
const int SYS_READV_NOCANCEL   = 411;
const int SYS_WRITEV_NOCANCEL  = 412;
const int SYS_SENDTO_NOCANCEL  = 413;
const int SYS_PREAD_NOCANCEL   = 414;
const int SYS_PWRITE_NOCANCEL  = 415;
const int SYS_WAITID_NOCANCEL  = 416;
const int SYS_POLL_NOCANCEL    = 417;
const int SYS_MSGSND_NOCANCEL  = 418;
const int SYS_MSGRCV_NOCANCEL  = 419;
const int SYS_SEM_WAIT_NOCANCEL = 420;
const int SYS_AIO_SUSPEND_NOCANCEL = 421;
const int SYS___SIGWAIT_NOCANCEL = 422;
const int SYS___SEMWAIT_SIGNAL_NOCANCEL = 423;
const int SYS_PSELECT_NOCANCEL = 395;
const int SYS_OPENAT_NOCANCEL  = 464;

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
const int SYS_READLINK         = 58;
const int SYS_UMASK            = 60;
const int SYS_CHROOT           = 61;
const int SYS_RENAME           = 128;
const int SYS_MKFIFO           = 132;
const int SYS_MKDIR            = 136;
const int SYS_RMDIR            = 137;
const int SYS_UTIMES           = 138;
const int SYS_FUTIMES          = 139;
const int SYS_TRUNCATE         = 200;
const int SYS_FTRUNCATE        = 201;
const int SYS_LCHOWN           = 364;
const int SYS_UNDELETE         = 205;
const int SYS_DELETE           = 226;  // HFS-specific delete
const int SYS_EXCHANGEDATA     = 223;  // HFS-specific atomic swap
const int SYS_COPYFILE         = 227;
const int SYS_CLONEFILEAT      = 462;

// ---- Filesystem — "at"-variants ----
const int SYS_OPENAT           = 463;
const int SYS_RENAMEAT         = 465;
const int SYS_FACCESSAT        = 466;
const int SYS_FCHMODAT         = 467;
const int SYS_FCHOWNAT         = 468;
const int SYS_LINKAT           = 471;
const int SYS_UNLINKAT         = 472;
const int SYS_READLINKAT       = 473;
const int SYS_SYMLINKAT        = 474;
const int SYS_MKDIRAT          = 475;
const int SYS_RENAMEATX_NP    = 488;  // Darwin extension (RENAME_SWAP etc.)

// ---- Stat / Filesystem Info ----
const int SYS_STAT             = 188;  // stat64 on Darwin; kernel-internal only (use stat(2))
const int SYS_LSTAT            = 190;
const int SYS_FSTAT            = 189;
const int SYS_STAT64           = 338;
const int SYS_FSTAT64          = 339;
const int SYS_LSTAT64          = 340;
const int SYS_STAT64_EXTENDED  = 341;
const int SYS_LSTAT64_EXTENDED = 342;
const int SYS_FSTAT64_EXTENDED = 343;
const int SYS_STATFS           = 157;
const int SYS_FSTATFS          = 158;
const int SYS_STATFS64         = 345;
const int SYS_FSTATFS64        = 346;
const int SYS_FSTATAT          = 469;
const int SYS_FSTATAT64        = 470;
const int SYS_GETFSSTAT        = 18;
const int SYS_GETFSSTAT64      = 347;
const int SYS_SEARCHFS         = 225;

// ---- Directory Entries ----
const int SYS_GETDIRENTRIES64  = 344;

// ---- Extended Attributes ----
const int SYS_GETXATTR         = 234;
const int SYS_FGETXATTR        = 235;
const int SYS_SETXATTR         = 236;
const int SYS_FSETXATTR        = 237;
const int SYS_REMOVEXATTR      = 238;
const int SYS_FREMOVEXATTR     = 239;
const int SYS_LISTXATTR        = 240;
const int SYS_FLISTXATTR       = 241;

// ---- Attribute Lists (Darwin HFS+/APFS) ----
const int SYS_GETATTRLIST      = 220;
const int SYS_SETATTRLIST      = 221;
const int SYS_FGETATTRLIST     = 228;
const int SYS_FSETATTRLIST     = 229;
const int SYS_GETATTRLISTAT    = 476;
const int SYS_GETATTRLISTBULK  = 461;
const int SYS_GETDIRENTRIESATTR = 222;
const int SYS_FSCTL            = 242;
const int SYS_FFSCTL           = 245;

// ---- Permissions (ACL / extended) ----
const int SYS_OPEN_EXTENDED    = 277;
const int SYS_UMASK_EXTENDED   = 278;
const int SYS_STAT_EXTENDED    = 279;
const int SYS_LSTAT_EXTENDED   = 280;
const int SYS_FSTAT_EXTENDED   = 281;
const int SYS_CHMOD_EXTENDED   = 282;
const int SYS_FCHMOD_EXTENDED  = 283;
const int SYS_ACCESS_EXTENDED  = 284;
const int SYS_MKFIFO_EXTENDED  = 291;
const int SYS_MKDIR_EXTENDED   = 292;

// ---- Mount / Unmount ----
const int SYS_MOUNT            = 167;
const int SYS_UNMOUNT          = 159;
const int SYS_PIVOT_ROOT       = 0;   // not supported on Darwin
const int SYS_SWAPON           = 85;
const int SYS_NFSCLNT          = 247;
const int SYS_FHOPEN           = 248;

// ---- Memory Management ----
const int SYS_MMAP             = 197;
const int SYS_MUNMAP           = 73;
const int SYS_MPROTECT         = 74;
const int SYS_MADVISE          = 75;
const int SYS_MINCORE          = 78;
const int SYS_MSYNC            = 65;
const int SYS_MLOCK            = 203;
const int SYS_MUNLOCK          = 204;
const int SYS_MLOCKALL         = 324;
const int SYS_MUNLOCKALL       = 325;
const int SYS_MINHERIT         = 250;
const int SYS_MREMAP_ENCRYPTED = 489;
const int SYS_SHARED_REGION_CHECK_NP      = 294;
const int SYS_SHARED_REGION_MAP_AND_SLIDE_NP = 438;
const int SYS_VM_PRESSURE_MONITOR = 296;
const int SYS_MEMORYSTATUS_CONTROL = 440;
const int SYS_MEMORYSTATUS_GET_LEVEL = 453;
const int SYS_PROCESS_MADVISE = 493;  // macOS 12+

// ---- Networking / Sockets ----
const int SYS_SOCKET           = 97;
const int SYS_BIND             = 104;
const int SYS_LISTEN           = 106;
const int SYS_ACCEPT           = 30;
const int SYS_ACCEPT4          = 0;   // Darwin uses SOCK_NONBLOCK flag on accept() instead
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
const int SYS_RECVMSG_X        = 480;  // Darwin extension: scatter recvmsg
const int SYS_SENDMSG_X        = 481;  // Darwin extension: gather sendmsg
const int SYS_SENDFILE         = 337;
const int SYS_POLL             = 230;
const int SYS_PSELECT          = 394;
const int SYS_CONNECTX         = 447;  // Darwin multipath extension
const int SYS_DISCONNECTX      = 448;
const int SYS_PEELOFF          = 449;
const int SYS_SOCKET_DELEGATE  = 450;

// ---- kqueue / kevent ----
const int SYS_KQUEUE           = 362;
const int SYS_KEVENT           = 363;
const int SYS_KEVENT64         = 369;
const int SYS_KEVENT_QOS       = 374;
const int SYS_KEVENT_ID        = 375;
const int SYS_GUARDED_KQUEUE_NP = 443;

// ---- POSIX Async I/O ----
const int SYS_AIO_FSYNC        = 313;
const int SYS_AIO_RETURN       = 314;
const int SYS_AIO_SUSPEND      = 315;
const int SYS_AIO_CANCEL       = 316;
const int SYS_AIO_ERROR        = 317;
const int SYS_AIO_READ         = 318;
const int SYS_AIO_WRITE        = 319;
const int SYS_LIO_LISTIO       = 320;

// ---- IPC: POSIX Semaphores ----
const int SYS_SEM_OPEN         = 268;
const int SYS_SEM_CLOSE        = 269;
const int SYS_SEM_UNLINK       = 270;
const int SYS_SEM_WAIT         = 271;
const int SYS_SEM_TRYWAIT      = 272;
const int SYS_SEM_POST         = 273;
const int SYS_SEM_GETVALUE     = 274;

// ---- IPC: SysV Semaphores ----
const int SYS_SEMGET           = 255;
const int SYS_SEMCTL           = 254;
const int SYS_SEMOP            = 256;
const int SYS_SEMSYS           = 251;  // Obsolete

// ---- IPC: SysV Message Queues ----
const int SYS_MSGGET           = 259;
const int SYS_MSGCTL           = 258;
const int SYS_MSGSND           = 260;
const int SYS_MSGRCV           = 261;
const int SYS_MSGSYS           = 252;  // Obsolete

// ---- IPC: SysV Shared Memory ----
const int SYS_SHMGET           = 265;
const int SYS_SHMCTL           = 263;
const int SYS_SHMAT            = 262;
const int SYS_SHMDT            = 264;
const int SYS_SHMSYS           = 253;  // Obsolete
const int SYS_SHM_OPEN         = 266;
const int SYS_SHM_UNLINK       = 267;

// ---- POSIX psynch (pthread kernel support) ----
const int SYS_PSYNCH_MUTEXWAIT     = 301;
const int SYS_PSYNCH_MUTEXDROP     = 302;
const int SYS_PSYNCH_CVBROAD       = 303;
const int SYS_PSYNCH_CVSIGNAL      = 304;
const int SYS_PSYNCH_CVWAIT        = 305;
const int SYS_PSYNCH_RW_RDLOCK     = 306;
const int SYS_PSYNCH_RW_WRLOCK     = 307;
const int SYS_PSYNCH_RW_UNLOCK     = 308;
const int SYS_PSYNCH_RW_UNLOCK2    = 309;
const int SYS_PSYNCH_CVCLRPREPOST  = 312;
const int SYS_PSYNCH_RW_LONGRDLOCK = 297;
const int SYS_PSYNCH_RW_YIELDWRLOCK = 298;
const int SYS_PSYNCH_RW_DOWNGRADE  = 299;
const int SYS_PSYNCH_RW_UPGRADE    = 300;

// ---- ulock (Darwin futex-like, private) ----
const int SYS_ULOCK_WAIT       = 515;
const int SYS_ULOCK_WAKE       = 516;

// ---- Time ----
const int SYS_GETTIMEOFDAY     = 116;
const int SYS_SETTIMEOFDAY     = 122;
const int SYS_ADJTIME          = 140;
const int SYS_ADJTIMEX        = 202;  // via sysctl on Darwin; no direct syscall number
const int SYS_NANOSLEEP        = 240; // available via __SYS_NANOSLEEP; use nanosleep(2)
const int SYS_GETITIMER        = 86;
const int SYS_SETITIMER        = 83;

// ---- Scheduling / Priority ----
const int SYS_GETPRIORITY      = 100;
const int SYS_SETPRIORITY      = 96;
const int SYS_SCHED_YIELD      = 0;   // No direct syscall; use pthread_yield_np()
const int SYS_IOPOLICYSYS      = 322;
const int SYS_PROCESS_POLICY   = 323;
const int SYS_SFI_CTL          = 456;
const int SYS_SFI_PIDCTL       = 457;
const int SYS_COALITION        = 458;
const int SYS_COALITION_INFO   = 459;

// ---- Resource Limits ----
const int SYS_GETRLIMIT        = 194;
const int SYS_SETRLIMIT        = 195;
const int SYS_GETRUSAGE        = 117;
const int SYS_TIMES            = 0;   // Not available on Darwin
const int SYS_ACCT             = 51;

// ---- System Info ----
const int SYS_UNAME            = 0;   // Not a syscall on Darwin; use uname(3)
const int SYS_SYSCTL           = 202;
const int SYS_SYSCTLBYNAME     = 274;
const int SYS_SYSINFO          = 0;   // Not available on Darwin
const int SYS_SYSLOG           = 116; // Use ASL / os_log instead

// ---- Privileges / Capabilities ----
const int SYS_GETAUDIT_ADDR    = 357;
const int SYS_SETAUDIT_ADDR    = 358;
const int SYS_GETAUID          = 353;
const int SYS_SETAUID          = 354;
const int SYS_AUDIT            = 350;
const int SYS_AUDITON          = 351;
const int SYS_AUDITCTL         = 359;
const int SYS_AUDIT_SESSION_SELF = 428;
const int SYS_AUDIT_SESSION_JOIN = 429;
const int SYS_AUDIT_SESSION_PORT = 432;

// ---- Guarded FDs (Darwin) ----
const int SYS_GUARDED_OPEN_NP           = 441;
const int SYS_GUARDED_CLOSE_NP          = 442;
const int SYS_CHANGE_FDGUARD_NP         = 444;
const int SYS_GUARDED_OPEN_DPROTECTED_NP = 484;
const int SYS_GUARDED_WRITE_NP          = 485;
const int SYS_GUARDED_PWRITE_NP         = 486;
const int SYS_GUARDED_WRITEV_NP         = 487;
const int SYS_OPEN_DPROTECTED_NP        = 216;  // Data Protection open (iOS/macOS)

// ---- File Paths ----
const int SYS_FSGETPATH        = 427;
const int SYS_OPENBYID_NP      = 479;
const int SYS_NAME_TO_HANDLE_AT = 0;  // Not available on Darwin; use getattrlist
const int SYS___PTHREAD_CHDIR  = 348;
const int SYS___PTHREAD_FCHDIR = 349;

// ---- NECP (Network Extension Control Policy) ----
const int SYS_NECP_MATCH_POLICY  = 460;
const int SYS_NECP_OPEN          = 501;
const int SYS_NECP_CLIENT_ACTION = 502;
const int SYS_NETAGENT_TRIGGER   = 490;

// ---- Security (CSR / SIP) ----
const int SYS_CSRCTL             = 483;
const int SYS_KAS_INFO           = 439;
const int SYS_SYSTEM_OVERRIDE    = 454;
const int SYS_VFS_PURGE          = 455;
const int SYS_USRCTL             = 445;

// ---- Profiling / Telemetry ----
const int SYS_TELEMETRY              = 451;
const int SYS_PROC_UUID_POLICY       = 452;
const int SYS_STACK_SNAPSHOT_WITH_CONFIG = 491;
const int SYS_MICROSTACKSHOT         = 492;
const int SYS_WORK_INTERVAL_CTL      = 499;
const int SYS_WORKQ_OPEN             = 367;
const int SYS_WORKQ_KERNRETURN       = 368;

// ---- Entropy ----
const int SYS_GETENTROPY         = 500;

// ---- MAC Framework (Mandatory Access Control) ----
const int SYS___MAC_EXECVE        = 380;
const int SYS___MAC_SYSCALL       = 381;
const int SYS___MAC_GET_FILE      = 382;
const int SYS___MAC_SET_FILE      = 383;
const int SYS___MAC_GET_LINK      = 384;
const int SYS___MAC_SET_LINK      = 385;
const int SYS___MAC_GET_PROC      = 386;
const int SYS___MAC_SET_PROC      = 387;
const int SYS___MAC_GET_FD        = 388;
const int SYS___MAC_SET_FD        = 389;
const int SYS___MAC_GET_PID       = 390;
const int SYS___MAC_MOUNT         = 424;
const int SYS___MAC_GET_MOUNT     = 425;
const int SYS___MAC_GETFSSTAT     = 426;

// ---- NFS (server side) ----
const int SYS_NFSSERVCTL         = 0;   // Removed in Darwin; use nfsd(8)

// ---- Misc / kext ----
const int SYS_FILEPORT_MAKEPORT  = 430;
const int SYS_FILEPORT_MAKEFD    = 431;
const int SYS_PROC_TRACE_LOG     = 477;
const int SYS_KEXEC_LOAD         = 0;   // Not available on Darwin



// sys.syscall.darwin_aarch64.h.c3
//
// Darwin (macOS / iOS) AArch64 (Apple Silicon) BSD syscall numbers.
// Source: XNU bsd/kern/syscalls.master
//         /usr/include/sys/syscall.h  (macOS SDK)
//
// IMPORTANT: Darwin syscall classes
//   BSD syscalls  (this file) : class 0x2000000  → syscall() adds this automatically
//   Mach traps                : class 0x1000000  → use mach_msg() etc. instead
//   Machine-dependent         : class 0x3000000
//
// Darwin BSD syscall numbers are ARCHITECTURE-INDEPENDENT — the same table is used on
// both x86_64 and AArch64 (Apple Silicon / M-series). The calling convention differs:
//   x86_64  : syscall instruction, number in rax
//   AArch64 : svc #0x80,          number in x16
// libc handles this transparently; user code calls syscall() identically on both.
//
// Unlike Linux, Darwin retains legacy BSD syscalls (open, fork, stat, dup2, pipe, poll …).
// "nocancel" variants (_nocancel suffix) are non-interruptible forms used by libpthread.
// "Obsolete" entries existed in older XNU and are kept for reference; do NOT use them.
//
// AArch64-specific notes:
//   - SYS_ARM_THREAD_STATE  is exposed via thread_get_state (Mach trap), not BSD syscall.
//   - SYS_ICACHE_INVALIDATE / SYS_DCACHE_FLUSH are machine-dependent traps (class 0x3000000).
//   - SYS_COMMPAGE_* are accessed via the commpage mapped at 0xffffffffffffb000 (no syscall).

module c::sys::syscall @if(env::DARWIN && env::AARCH64);

// BSD syscall wrapper — libc adds the 0x2000000 class prefix and uses svc #0x80
// with the number in x16 automatically.
extern fn long syscall(int number, ...);

// ---- Syscall 0 ----
const int SYS_SYSCALL          = 0;   // indirect syscall (internal use)

// ---- Process ----
const int SYS_EXIT             = 1;
const int SYS_FORK             = 2;
const int SYS_VFORK            = 66;
const int SYS_EXECVE           = 59;
const int SYS_GETPID           = 20;
const int SYS_GETPPID          = 39;
const int SYS_GETPGRP          = 81;
const int SYS_SETPGID          = 82;
const int SYS_GETPGID          = 151;
const int SYS_SETSID           = 147;
const int SYS_GETSID           = 310;
const int SYS_WAIT4            = 7;
const int SYS_WAITID           = 173;
const int SYS_KILL             = 37;
const int SYS_GETLOGIN         = 49;
const int SYS_SETLOGIN         = 50;
const int SYS_PTRACE           = 26;
const int SYS_REBOOT           = 55;
const int SYS_ISSETUGID        = 327;
const int SYS_PROC_INFO        = 336;
const int SYS_PROC_RLIMIT_CONTROL = 446;
const int SYS_PERSONA          = 494;
const int SYS_POSIX_SPAWN      = 244;
const int SYS_BSDTHREAD_CREATE    = 360;
const int SYS_BSDTHREAD_TERMINATE = 361;
const int SYS_BSDTHREAD_REGISTER  = 366;
const int SYS_BSDTHREAD_CTL      = 478;
const int SYS_THREAD_SELFID      = 372;
const int SYS_THREAD_SELFUSAGE   = 482;
const int SYS_SETTID             = 285;
const int SYS_GETTID             = 286;
const int SYS_SETTID_WITH_PID    = 311;
const int SYS_LEDGER             = 373;
const int SYS_PID_SUSPEND        = 433;
const int SYS_PID_RESUME         = 434;
const int SYS_PID_HIBERNATE      = 435;
const int SYS_PID_SHUTDOWN_SOCKETS = 436;

// ---- User / Group IDs ----
const int SYS_GETUID           = 24;
const int SYS_GETEUID          = 25;
const int SYS_GETGID           = 47;
const int SYS_GETEGID          = 43;
const int SYS_SETUID           = 23;
const int SYS_SETGID           = 181;  // via setgid(2)
const int SYS_SETREUID         = 126;
const int SYS_SETREGID         = 127;
const int SYS_SETRESUID        = 208;
const int SYS_GETRESUID        = 209;
const int SYS_SETRESGID        = 210;
const int SYS_GETRESGID        = 211;
const int SYS_GETGROUPS        = 79;
const int SYS_SETGROUPS        = 80;
const int SYS_SETFSUID         = 138;  // no-op on Darwin; kept for compat
const int SYS_SETPRIVEXEC      = 152;
const int SYS_SETSGROUPS       = 287;
const int SYS_GETSGROUPS       = 288;
const int SYS_SETWGROUPS       = 289;
const int SYS_GETWGROUPS       = 290;
const int SYS_INITGROUPS       = 243;
const int SYS_IDENTITYSVC      = 293;

// ---- Signals ----
const int SYS_SIGACTION        = 46;
const int SYS_SIGPROCMASK      = 48;
const int SYS_SIGPENDING       = 52;
const int SYS_SIGALTSTACK      = 53;
const int SYS_SIGSUSPEND       = 111;
const int SYS___PTHREAD_KILL   = 328;
const int SYS___PTHREAD_SIGMASK = 329;
const int SYS___SIGWAIT        = 330;
const int SYS___DISABLE_THREADSIGNAL = 331;
const int SYS___PTHREAD_MARKCANCEL  = 332;
const int SYS___PTHREAD_CANCELED    = 333;
const int SYS___SEMWAIT_SIGNAL      = 334;
const int SYS___OLD_SEMWAIT_SIGNAL  = 370;  // Obsolete
const int SYS___OLD_SEMWAIT_SIGNAL_NOCANCEL = 371;  // Obsolete

// ---- File I/O ----
const int SYS_READ             = 3;
const int SYS_WRITE            = 4;
const int SYS_OPEN             = 5;
const int SYS_CLOSE            = 6;
const int SYS_PREAD            = 153;
const int SYS_PWRITE           = 154;
const int SYS_READV            = 120;
const int SYS_WRITEV           = 121;
const int SYS_LSEEK            = 199;
const int SYS_DUP              = 41;
const int SYS_DUP2             = 90;
const int SYS_PIPE             = 42;
const int SYS_FCNTL            = 92;
const int SYS_IOCTL            = 54;
const int SYS_FLOCK            = 131;
const int SYS_FSYNC            = 95;
const int SYS_FDATASYNC        = 169;
const int SYS_SELECT           = 93;

// ---- File I/O — nocancel variants ----
const int SYS_READ_NOCANCEL    = 396;
const int SYS_WRITE_NOCANCEL   = 397;
const int SYS_OPEN_NOCANCEL    = 398;
const int SYS_CLOSE_NOCANCEL   = 399;
const int SYS_WAIT4_NOCANCEL   = 400;
const int SYS_RECVMSG_NOCANCEL = 401;
const int SYS_SENDMSG_NOCANCEL = 402;
const int SYS_RECVFROM_NOCANCEL = 403;
const int SYS_ACCEPT_NOCANCEL  = 404;
const int SYS_MSYNC_NOCANCEL   = 405;
const int SYS_FCNTL_NOCANCEL   = 406;
const int SYS_SELECT_NOCANCEL  = 407;
const int SYS_FSYNC_NOCANCEL   = 408;
const int SYS_CONNECT_NOCANCEL = 409;
const int SYS_SIGSUSPEND_NOCANCEL = 410;
const int SYS_READV_NOCANCEL   = 411;
const int SYS_WRITEV_NOCANCEL  = 412;
const int SYS_SENDTO_NOCANCEL  = 413;
const int SYS_PREAD_NOCANCEL   = 414;
const int SYS_PWRITE_NOCANCEL  = 415;
const int SYS_WAITID_NOCANCEL  = 416;
const int SYS_POLL_NOCANCEL    = 417;
const int SYS_MSGSND_NOCANCEL  = 418;
const int SYS_MSGRCV_NOCANCEL  = 419;
const int SYS_SEM_WAIT_NOCANCEL = 420;
const int SYS_AIO_SUSPEND_NOCANCEL = 421;
const int SYS___SIGWAIT_NOCANCEL = 422;
const int SYS___SEMWAIT_SIGNAL_NOCANCEL = 423;
const int SYS_PSELECT_NOCANCEL = 395;
const int SYS_OPENAT_NOCANCEL  = 464;

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
const int SYS_READLINK         = 58;
const int SYS_UMASK            = 60;
const int SYS_CHROOT           = 61;
const int SYS_RENAME           = 128;
const int SYS_MKFIFO           = 132;
const int SYS_MKDIR            = 136;
const int SYS_RMDIR            = 137;
const int SYS_UTIMES           = 138;
const int SYS_FUTIMES          = 139;
const int SYS_TRUNCATE         = 200;
const int SYS_FTRUNCATE        = 201;
const int SYS_LCHOWN           = 364;
const int SYS_UNDELETE         = 205;
const int SYS_DELETE           = 226;  // HFS-specific delete
const int SYS_EXCHANGEDATA     = 223;  // HFS-specific atomic swap
const int SYS_COPYFILE         = 227;
const int SYS_CLONEFILEAT      = 462;

// ---- Filesystem — "at"-variants ----
const int SYS_OPENAT           = 463;
const int SYS_RENAMEAT         = 465;
const int SYS_FACCESSAT        = 466;
const int SYS_FCHMODAT         = 467;
const int SYS_FCHOWNAT         = 468;
const int SYS_LINKAT           = 471;
const int SYS_UNLINKAT         = 472;
const int SYS_READLINKAT       = 473;
const int SYS_SYMLINKAT        = 474;
const int SYS_MKDIRAT          = 475;
const int SYS_RENAMEATX_NP    = 488;  // Darwin extension (RENAME_SWAP etc.)

// ---- Stat / Filesystem Info ----
const int SYS_STAT             = 188;  // stat64 on Darwin; kernel-internal only (use stat(2))
const int SYS_LSTAT            = 190;
const int SYS_FSTAT            = 189;
const int SYS_STAT64           = 338;
const int SYS_FSTAT64          = 339;
const int SYS_LSTAT64          = 340;
const int SYS_STAT64_EXTENDED  = 341;
const int SYS_LSTAT64_EXTENDED = 342;
const int SYS_FSTAT64_EXTENDED = 343;
const int SYS_STATFS           = 157;
const int SYS_FSTATFS          = 158;
const int SYS_STATFS64         = 345;
const int SYS_FSTATFS64        = 346;
const int SYS_FSTATAT          = 469;
const int SYS_FSTATAT64        = 470;
const int SYS_GETFSSTAT        = 18;
const int SYS_GETFSSTAT64      = 347;
const int SYS_SEARCHFS         = 225;

// ---- Directory Entries ----
const int SYS_GETDIRENTRIES64  = 344;

// ---- Extended Attributes ----
const int SYS_GETXATTR         = 234;
const int SYS_FGETXATTR        = 235;
const int SYS_SETXATTR         = 236;
const int SYS_FSETXATTR        = 237;
const int SYS_REMOVEXATTR      = 238;
const int SYS_FREMOVEXATTR     = 239;
const int SYS_LISTXATTR        = 240;
const int SYS_FLISTXATTR       = 241;

// ---- Attribute Lists (Darwin HFS+/APFS) ----
const int SYS_GETATTRLIST      = 220;
const int SYS_SETATTRLIST      = 221;
const int SYS_FGETATTRLIST     = 228;
const int SYS_FSETATTRLIST     = 229;
const int SYS_GETATTRLISTAT    = 476;
const int SYS_GETATTRLISTBULK  = 461;
const int SYS_GETDIRENTRIESATTR = 222;
const int SYS_FSCTL            = 242;
const int SYS_FFSCTL           = 245;

// ---- Permissions (ACL / extended) ----
const int SYS_OPEN_EXTENDED    = 277;
const int SYS_UMASK_EXTENDED   = 278;
const int SYS_STAT_EXTENDED    = 279;
const int SYS_LSTAT_EXTENDED   = 280;
const int SYS_FSTAT_EXTENDED   = 281;
const int SYS_CHMOD_EXTENDED   = 282;
const int SYS_FCHMOD_EXTENDED  = 283;
const int SYS_ACCESS_EXTENDED  = 284;
const int SYS_MKFIFO_EXTENDED  = 291;
const int SYS_MKDIR_EXTENDED   = 292;

// ---- Mount / Unmount ----
const int SYS_MOUNT            = 167;
const int SYS_UNMOUNT          = 159;
const int SYS_PIVOT_ROOT       = 0;   // not supported on Darwin
const int SYS_SWAPON           = 85;
const int SYS_NFSCLNT          = 247;
const int SYS_FHOPEN           = 248;

// ---- Memory Management ----
const int SYS_MMAP             = 197;
const int SYS_MUNMAP           = 73;
const int SYS_MPROTECT         = 74;
const int SYS_MADVISE          = 75;
const int SYS_MINCORE          = 78;
const int SYS_MSYNC            = 65;
const int SYS_MLOCK            = 203;
const int SYS_MUNLOCK          = 204;
const int SYS_MLOCKALL         = 324;
const int SYS_MUNLOCKALL       = 325;
const int SYS_MINHERIT         = 250;
const int SYS_MREMAP_ENCRYPTED = 489;
const int SYS_SHARED_REGION_CHECK_NP      = 294;
const int SYS_SHARED_REGION_MAP_AND_SLIDE_NP = 438;
const int SYS_VM_PRESSURE_MONITOR = 296;
const int SYS_MEMORYSTATUS_CONTROL = 440;
const int SYS_MEMORYSTATUS_GET_LEVEL = 453;
const int SYS_PROCESS_MADVISE = 493;  // macOS 12+

// ---- Networking / Sockets ----
const int SYS_SOCKET           = 97;
const int SYS_BIND             = 104;
const int SYS_LISTEN           = 106;
const int SYS_ACCEPT           = 30;
const int SYS_ACCEPT4          = 0;   // Darwin uses SOCK_NONBLOCK flag on accept() instead
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
const int SYS_RECVMSG_X        = 480;  // Darwin extension: scatter recvmsg
const int SYS_SENDMSG_X        = 481;  // Darwin extension: gather sendmsg
const int SYS_SENDFILE         = 337;
const int SYS_POLL             = 230;
const int SYS_PSELECT          = 394;
const int SYS_CONNECTX         = 447;  // Darwin multipath extension
const int SYS_DISCONNECTX      = 448;
const int SYS_PEELOFF          = 449;
const int SYS_SOCKET_DELEGATE  = 450;

// ---- kqueue / kevent ----
const int SYS_KQUEUE           = 362;
const int SYS_KEVENT           = 363;
const int SYS_KEVENT64         = 369;
const int SYS_KEVENT_QOS       = 374;
const int SYS_KEVENT_ID        = 375;
const int SYS_GUARDED_KQUEUE_NP = 443;

// ---- POSIX Async I/O ----
const int SYS_AIO_FSYNC        = 313;
const int SYS_AIO_RETURN       = 314;
const int SYS_AIO_SUSPEND      = 315;
const int SYS_AIO_CANCEL       = 316;
const int SYS_AIO_ERROR        = 317;
const int SYS_AIO_READ         = 318;
const int SYS_AIO_WRITE        = 319;
const int SYS_LIO_LISTIO       = 320;

// ---- IPC: POSIX Semaphores ----
const int SYS_SEM_OPEN         = 268;
const int SYS_SEM_CLOSE        = 269;
const int SYS_SEM_UNLINK       = 270;
const int SYS_SEM_WAIT         = 271;
const int SYS_SEM_TRYWAIT      = 272;
const int SYS_SEM_POST         = 273;
const int SYS_SEM_GETVALUE     = 274;

// ---- IPC: SysV Semaphores ----
const int SYS_SEMGET           = 255;
const int SYS_SEMCTL           = 254;
const int SYS_SEMOP            = 256;
const int SYS_SEMSYS           = 251;  // Obsolete

// ---- IPC: SysV Message Queues ----
const int SYS_MSGGET           = 259;
const int SYS_MSGCTL           = 258;
const int SYS_MSGSND           = 260;
const int SYS_MSGRCV           = 261;
const int SYS_MSGSYS           = 252;  // Obsolete

// ---- IPC: SysV Shared Memory ----
const int SYS_SHMGET           = 265;
const int SYS_SHMCTL           = 263;
const int SYS_SHMAT            = 262;
const int SYS_SHMDT            = 264;
const int SYS_SHMSYS           = 253;  // Obsolete
const int SYS_SHM_OPEN         = 266;
const int SYS_SHM_UNLINK       = 267;

// ---- POSIX psynch (pthread kernel support) ----
const int SYS_PSYNCH_MUTEXWAIT     = 301;
const int SYS_PSYNCH_MUTEXDROP     = 302;
const int SYS_PSYNCH_CVBROAD       = 303;
const int SYS_PSYNCH_CVSIGNAL      = 304;
const int SYS_PSYNCH_CVWAIT        = 305;
const int SYS_PSYNCH_RW_RDLOCK     = 306;
const int SYS_PSYNCH_RW_WRLOCK     = 307;
const int SYS_PSYNCH_RW_UNLOCK     = 308;
const int SYS_PSYNCH_RW_UNLOCK2    = 309;
const int SYS_PSYNCH_CVCLRPREPOST  = 312;
const int SYS_PSYNCH_RW_LONGRDLOCK = 297;
const int SYS_PSYNCH_RW_YIELDWRLOCK = 298;
const int SYS_PSYNCH_RW_DOWNGRADE  = 299;
const int SYS_PSYNCH_RW_UPGRADE    = 300;

// ---- ulock (Darwin futex-like, private) ----
const int SYS_ULOCK_WAIT       = 515;
const int SYS_ULOCK_WAKE       = 516;

// ---- Time ----
const int SYS_GETTIMEOFDAY     = 116;
const int SYS_SETTIMEOFDAY     = 122;
const int SYS_ADJTIME          = 140;
const int SYS_ADJTIMEX        = 202;  // via sysctl on Darwin; no direct syscall number
const int SYS_NANOSLEEP        = 240; // available via __SYS_NANOSLEEP; use nanosleep(2)
const int SYS_GETITIMER        = 86;
const int SYS_SETITIMER        = 83;

// ---- Scheduling / Priority ----
const int SYS_GETPRIORITY      = 100;
const int SYS_SETPRIORITY      = 96;
const int SYS_SCHED_YIELD      = 0;   // No direct syscall; use pthread_yield_np()
const int SYS_IOPOLICYSYS      = 322;
const int SYS_PROCESS_POLICY   = 323;
const int SYS_SFI_CTL          = 456;
const int SYS_SFI_PIDCTL       = 457;
const int SYS_COALITION        = 458;
const int SYS_COALITION_INFO   = 459;

// ---- Resource Limits ----
const int SYS_GETRLIMIT        = 194;
const int SYS_SETRLIMIT        = 195;
const int SYS_GETRUSAGE        = 117;
const int SYS_TIMES            = 0;   // Not available on Darwin
const int SYS_ACCT             = 51;

// ---- System Info ----
const int SYS_UNAME            = 0;   // Not a syscall on Darwin; use uname(3)
const int SYS_SYSCTL           = 202;
const int SYS_SYSCTLBYNAME     = 274;
const int SYS_SYSINFO          = 0;   // Not available on Darwin
const int SYS_SYSLOG           = 116; // Use ASL / os_log instead

// ---- Privileges / Capabilities ----
const int SYS_GETAUDIT_ADDR    = 357;
const int SYS_SETAUDIT_ADDR    = 358;
const int SYS_GETAUID          = 353;
const int SYS_SETAUID          = 354;
const int SYS_AUDIT            = 350;
const int SYS_AUDITON          = 351;
const int SYS_AUDITCTL         = 359;
const int SYS_AUDIT_SESSION_SELF = 428;
const int SYS_AUDIT_SESSION_JOIN = 429;
const int SYS_AUDIT_SESSION_PORT = 432;

// ---- Guarded FDs (Darwin) ----
const int SYS_GUARDED_OPEN_NP           = 441;
const int SYS_GUARDED_CLOSE_NP          = 442;
const int SYS_CHANGE_FDGUARD_NP         = 444;
const int SYS_GUARDED_OPEN_DPROTECTED_NP = 484;
const int SYS_GUARDED_WRITE_NP          = 485;
const int SYS_GUARDED_PWRITE_NP         = 486;
const int SYS_GUARDED_WRITEV_NP         = 487;
const int SYS_OPEN_DPROTECTED_NP        = 216;  // Data Protection open (iOS/macOS)

// ---- File Paths ----
const int SYS_FSGETPATH        = 427;
const int SYS_OPENBYID_NP      = 479;
const int SYS_NAME_TO_HANDLE_AT = 0;  // Not available on Darwin; use getattrlist
const int SYS___PTHREAD_CHDIR  = 348;
const int SYS___PTHREAD_FCHDIR = 349;

// ---- NECP (Network Extension Control Policy) ----
const int SYS_NECP_MATCH_POLICY  = 460;
const int SYS_NECP_OPEN          = 501;
const int SYS_NECP_CLIENT_ACTION = 502;
const int SYS_NETAGENT_TRIGGER   = 490;

// ---- Security (CSR / SIP) ----
const int SYS_CSRCTL             = 483;
const int SYS_KAS_INFO           = 439;
const int SYS_SYSTEM_OVERRIDE    = 454;
const int SYS_VFS_PURGE          = 455;
const int SYS_USRCTL             = 445;

// ---- Profiling / Telemetry ----
const int SYS_TELEMETRY              = 451;
const int SYS_PROC_UUID_POLICY       = 452;
const int SYS_STACK_SNAPSHOT_WITH_CONFIG = 491;
const int SYS_MICROSTACKSHOT         = 492;
const int SYS_WORK_INTERVAL_CTL      = 499;
const int SYS_WORKQ_OPEN             = 367;
const int SYS_WORKQ_KERNRETURN       = 368;

// ---- Entropy ----
const int SYS_GETENTROPY         = 500;

// ---- MAC Framework (Mandatory Access Control) ----
const int SYS___MAC_EXECVE        = 380;
const int SYS___MAC_SYSCALL       = 381;
const int SYS___MAC_GET_FILE      = 382;
const int SYS___MAC_SET_FILE      = 383;
const int SYS___MAC_GET_LINK      = 384;
const int SYS___MAC_SET_LINK      = 385;
const int SYS___MAC_GET_PROC      = 386;
const int SYS___MAC_SET_PROC      = 387;
const int SYS___MAC_GET_FD        = 388;
const int SYS___MAC_SET_FD        = 389;
const int SYS___MAC_GET_PID       = 390;
const int SYS___MAC_MOUNT         = 424;
const int SYS___MAC_GET_MOUNT     = 425;
const int SYS___MAC_GETFSSTAT     = 426;

// ---- NFS (server side) ----
const int SYS_NFSSERVCTL         = 0;   // Removed in Darwin; use nfsd(8)

// ---- Misc / kext ----
const int SYS_FILEPORT_MAKEPORT  = 430;
const int SYS_FILEPORT_MAKEFD    = 431;
const int SYS_PROC_TRACE_LOG     = 477;
const int SYS_KEXEC_LOAD         = 0;   // Not available on Darwin

// ---- Apple Silicon (AArch64) — machine-dependent traps (class 0x3000000) ----
// These are NOT BSD syscalls. They are issued via svc #0x80 with class prefix 0x3000000.
// Accessed through libc helpers, not through syscall() directly.
//
// Listed here for reference; pass (0x3000000 | number) if calling via raw svc.

const int SYS_MD_ICACHE_INVALIDATE = 1;   // __sys_icache_invalidate(addr, len)
const int SYS_MD_DCACHE_FLUSH      = 2;   // __sys_dcache_flush(addr, len)

// ---- Apple Silicon — AMX (Apple Matrix Extensions) ----
// AMX coprocessor control; exposed via private libAMX.dylib, not raw syscall.
// No public BSD syscall number; gated through psynch + thread state APIs.

// ---- Apple Silicon — commpage (not syscalls, mapped memory) ----
// The kernel maps a read-only commpage at 0xffffffffffffb000 (AArch64 userland).
// Fields include: cpu_capabilities, timebase_hz, nanotime_base, boottime, etc.
// Direct memory reads; no syscall needed.
//
// Example: read timebase frequency directly from commpage:
//   const ulong* ptr = (ulong*)0xffffffffffffb000UL + COMMPAGE_TIMEBASE_OFFSET;

// ---- Recent XNU additions (macOS 13+ Ventura / 14+ Sonoma) ----
const int SYS_SYSCTL_WRITE_ORIGIN  = 527;  // sysctl with origin tracking
const int SYS_ULOCK_WAIT2          = 528;  // ulock_wait with abs deadline
const int SYS_PROC_SUPPRESS        = 531;
const int SYS_SWIFT_ASYNC_CONTEXT_ADDR = 520;  // Swift concurrency runtime support
