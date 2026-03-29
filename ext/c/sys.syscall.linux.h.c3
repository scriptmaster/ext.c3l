// sys.syscall.linux.h.c3

module c::sys::syscall;

// ========== Linux x86_64 ==========

module c::sys::syscall @if(env::LINUX && env::X86_64);

// syscall() invokes the kernel directly with the given syscall number.
// Returns -1 on error (errno is set), or the syscall-specific return value.
extern fn long syscall(long number, ...);

// ---- File I/O ----
const int SYS_READ            = 0;
const int SYS_WRITE           = 1;
const int SYS_OPEN            = 2;
const int SYS_CLOSE           = 3;
const int SYS_STAT            = 4;
const int SYS_FSTAT           = 5;
const int SYS_LSTAT           = 6;
const int SYS_POLL            = 7;
const int SYS_LSEEK           = 8;
const int SYS_PREAD64         = 17;
const int SYS_PWRITE64        = 18;
const int SYS_READV           = 19;
const int SYS_WRITEV          = 20;
const int SYS_ACCESS          = 21;
const int SYS_PIPE            = 22;
const int SYS_SELECT          = 23;
const int SYS_DUP             = 32;
const int SYS_DUP2            = 33;
const int SYS_SENDFILE        = 40;
const int SYS_FCNTL           = 72;
const int SYS_FLOCK           = 73;
const int SYS_FSYNC           = 74;
const int SYS_FDATASYNC       = 75;
const int SYS_TRUNCATE        = 76;
const int SYS_FTRUNCATE       = 77;
const int SYS_GETDENTS        = 78;
const int SYS_GETCWD          = 79;
const int SYS_CHDIR           = 80;
const int SYS_FCHDIR          = 81;
const int SYS_RENAME          = 82;
const int SYS_MKDIR           = 83;
const int SYS_RMDIR           = 84;
const int SYS_CREAT           = 85;
const int SYS_LINK            = 86;
const int SYS_UNLINK          = 87;
const int SYS_SYMLINK         = 88;
const int SYS_READLINK        = 89;
const int SYS_CHMOD           = 90;
const int SYS_FCHMOD          = 91;
const int SYS_CHOWN           = 92;
const int SYS_FCHOWN          = 93;
const int SYS_LCHOWN          = 94;
const int SYS_UMASK           = 95;
const int SYS_READAHEAD       = 187;
const int SYS_GETDENTS64      = 217;

// ---- "at" variants (dirfd-relative) ----
const int SYS_OPENAT          = 257;
const int SYS_MKDIRAT         = 258;
const int SYS_MKNODAT         = 259;
const int SYS_FCHOWNAT        = 260;
const int SYS_FUTIMESAT       = 261;
const int SYS_NEWFSTATAT      = 262;
const int SYS_UNLINKAT        = 263;
const int SYS_RENAMEAT        = 264;
const int SYS_LINKAT          = 265;
const int SYS_SYMLINKAT       = 266;
const int SYS_READLINKAT      = 267;
const int SYS_FCHMODAT        = 268;
const int SYS_FACCESSAT       = 269;
const int SYS_UTIMENSAT       = 280;
const int SYS_DUP3            = 292;
const int SYS_PIPE2           = 293;
const int SYS_RENAMEAT2       = 316;
const int SYS_OPENAT2         = 437;
const int SYS_CLOSE_RANGE     = 436;
const int SYS_FACCESSAT2      = 439;
const int SYS_FCHMODAT2       = 452;

// ---- Memory Management ----
const int SYS_MMAP            = 9;
const int SYS_MPROTECT        = 10;
const int SYS_MUNMAP          = 11;
const int SYS_BRK             = 12;
const int SYS_MREMAP          = 25;
const int SYS_MSYNC           = 26;
const int SYS_MINCORE         = 27;
const int SYS_MADVISE         = 28;
const int SYS_MLOCK           = 149;
const int SYS_MUNLOCK         = 150;
const int SYS_MLOCKALL        = 151;
const int SYS_MUNLOCKALL      = 152;
const int SYS_REMAP_FILE_PAGES = 216;
const int SYS_FADVISE64       = 221;
const int SYS_MBIND           = 237;
const int SYS_SET_MEMPOLICY   = 238;
const int SYS_GET_MEMPOLICY   = 239;
const int SYS_MIGRATE_PAGES   = 256;
const int SYS_MOVE_PAGES      = 279;
const int SYS_MLOCK2          = 325;
const int SYS_PKEY_MPROTECT   = 329;
const int SYS_PKEY_ALLOC      = 330;
const int SYS_PKEY_FREE       = 331;
const int SYS_PROCESS_MADVISE = 440;
const int SYS_PROCESS_MRELEASE = 448;
const int SYS_MAP_SHADOW_STACK = 453;
const int SYS_SET_MEMPOLICY_HOME_NODE = 450;
const int SYS_MEMFD_CREATE    = 319;
const int SYS_MEMFD_SECRET    = 447;

// ---- Signals ----
const int SYS_RT_SIGACTION    = 13;
const int SYS_RT_SIGPROCMASK  = 14;
const int SYS_RT_SIGRETURN    = 15;
const int SYS_KILL            = 62;
const int SYS_SIGALTSTACK     = 131;
const int SYS_RT_SIGPENDING   = 127;
const int SYS_RT_SIGTIMEDWAIT = 128;
const int SYS_RT_SIGQUEUEINFO = 129;
const int SYS_RT_SIGSUSPEND   = 130;
const int SYS_TKILL           = 200;
const int SYS_TGKILL          = 234;
const int SYS_RT_TGSIGQUEUEINFO = 297;
const int SYS_SIGNALFD        = 282;
const int SYS_SIGNALFD4       = 289;
const int SYS_PAUSE           = 34;
const int SYS_PIDFD_SEND_SIGNAL = 424;

// ---- Process Management ----
const int SYS_SCHED_YIELD     = 24;
const int SYS_CLONE           = 56;
const int SYS_FORK            = 57;
const int SYS_VFORK           = 58;
const int SYS_EXECVE          = 59;
const int SYS_EXIT            = 60;
const int SYS_WAIT4           = 61;
const int SYS_GETPID          = 39;
const int SYS_GETPPID         = 110;
const int SYS_GETPGRP         = 111;
const int SYS_SETPGID         = 109;
const int SYS_GETPGID         = 121;
const int SYS_SETSID          = 112;
const int SYS_GETSID          = 124;
const int SYS_GETTID          = 186;
const int SYS_PRCTL           = 157;
const int SYS_ARCH_PRCTL      = 158;
const int SYS_PERSONALITY     = 135;
const int SYS_PTRACE          = 101;
const int SYS_ACCT            = 163;
const int SYS_CAPGET          = 125;
const int SYS_CAPSET          = 126;
const int SYS_EXECVEAT        = 322;
const int SYS_CLONE3          = 435;
const int SYS_WAITID          = 247;
const int SYS_EXIT_GROUP      = 231;
const int SYS_PIDFD_OPEN      = 434;
const int SYS_PIDFD_GETFD     = 438;
const int SYS_UNSHARE         = 272;
const int SYS_SETNS           = 308;
const int SYS_KCMP            = 312;
const int SYS_PROCESS_VM_READV  = 310;
const int SYS_PROCESS_VM_WRITEV = 311;
const int SYS_USERFAULTFD     = 323;

// ---- User / Group IDs ----
const int SYS_GETUID          = 102;
const int SYS_GETGID          = 104;
const int SYS_SETUID          = 105;
const int SYS_SETGID          = 106;
const int SYS_GETEUID         = 107;
const int SYS_GETEGID         = 108;
const int SYS_SETREUID        = 113;
const int SYS_SETREGID        = 114;
const int SYS_GETGROUPS       = 115;
const int SYS_SETGROUPS       = 116;
const int SYS_SETRESUID       = 117;
const int SYS_GETRESUID       = 118;
const int SYS_SETRESGID       = 119;
const int SYS_GETRESGID       = 120;
const int SYS_SETFSUID        = 122;
const int SYS_SETFSGID        = 123;

// ---- Scheduling ----
const int SYS_SCHED_SETPARAM         = 142;
const int SYS_SCHED_GETPARAM         = 143;
const int SYS_SCHED_SETSCHEDULER     = 144;
const int SYS_SCHED_GETSCHEDULER     = 145;
const int SYS_SCHED_GET_PRIORITY_MAX = 146;
const int SYS_SCHED_GET_PRIORITY_MIN = 147;
const int SYS_SCHED_RR_GET_INTERVAL  = 148;
const int SYS_SCHED_SETAFFINITY      = 203;
const int SYS_SCHED_GETAFFINITY      = 204;
const int SYS_SCHED_SETATTR          = 314;
const int SYS_SCHED_GETATTR          = 315;
const int SYS_GETCPU                 = 309;
const int SYS_GETPRIORITY            = 140;
const int SYS_SETPRIORITY            = 141;
const int SYS_IOPRIO_SET             = 251;
const int SYS_IOPRIO_GET             = 252;

// ---- Time ----
const int SYS_NANOSLEEP       = 35;
const int SYS_GETITIMER       = 36;
const int SYS_ALARM           = 37;
const int SYS_SETITIMER       = 38;
const int SYS_GETTIMEOFDAY    = 96;
const int SYS_SETTIMEOFDAY    = 164;
const int SYS_TIMES           = 100;
const int SYS_TIME            = 201;
const int SYS_ADJTIMEX        = 159;
const int SYS_UTIME           = 132;
const int SYS_UTIMES          = 235;
const int SYS_TIMER_CREATE    = 222;
const int SYS_TIMER_SETTIME   = 223;
const int SYS_TIMER_GETTIME   = 224;
const int SYS_TIMER_GETOVERRUN = 225;
const int SYS_TIMER_DELETE    = 226;
const int SYS_CLOCK_SETTIME   = 227;
const int SYS_CLOCK_GETTIME   = 228;
const int SYS_CLOCK_GETRES    = 229;
const int SYS_CLOCK_NANOSLEEP = 230;
const int SYS_CLOCK_ADJTIME   = 305;
const int SYS_TIMERFD_CREATE  = 283;
const int SYS_TIMERFD_SETTIME = 286;
const int SYS_TIMERFD_GETTIME = 287;

// ---- Networking / Sockets ----
const int SYS_SOCKET          = 41;
const int SYS_CONNECT         = 42;
const int SYS_ACCEPT          = 43;
const int SYS_SENDTO          = 44;
const int SYS_RECVFROM        = 45;
const int SYS_SENDMSG         = 46;
const int SYS_RECVMSG         = 47;
const int SYS_SHUTDOWN        = 48;
const int SYS_BIND            = 49;
const int SYS_LISTEN          = 50;
const int SYS_GETSOCKNAME     = 51;
const int SYS_GETPEERNAME     = 52;
const int SYS_SOCKETPAIR      = 53;
const int SYS_SETSOCKOPT      = 54;
const int SYS_GETSOCKOPT      = 55;
const int SYS_ACCEPT4         = 288;
const int SYS_RECVMMSG        = 299;
const int SYS_SENDMMSG        = 307;

// ---- I/O Multiplexing / Event Notification ----
const int SYS_IOCTL           = 16;
const int SYS_EPOLL_CREATE    = 213;
const int SYS_EPOLL_CTL_OLD   = 214;  // Not implemented
const int SYS_EPOLL_WAIT_OLD  = 215;  // Not implemented
const int SYS_EPOLL_WAIT      = 232;
const int SYS_EPOLL_CTL       = 233;
const int SYS_EPOLL_PWAIT     = 281;
const int SYS_EPOLL_CREATE1   = 291;
const int SYS_EPOLL_PWAIT2    = 441;
const int SYS_EVENTFD         = 284;
const int SYS_EVENTFD2        = 290;
const int SYS_PSELECT6        = 270;
const int SYS_PPOLL           = 271;
const int SYS_INOTIFY_INIT    = 253;
const int SYS_INOTIFY_ADD_WATCH = 254;
const int SYS_INOTIFY_RM_WATCH  = 255;
const int SYS_INOTIFY_INIT1   = 294;
const int SYS_FANOTIFY_INIT   = 300;
const int SYS_FANOTIFY_MARK   = 301;
const int SYS_PERF_EVENT_OPEN = 298;

// ---- Async I/O (POSIX AIO) ----
const int SYS_IO_SETUP        = 206;
const int SYS_IO_DESTROY      = 207;
const int SYS_IO_GETEVENTS    = 208;
const int SYS_IO_SUBMIT       = 209;
const int SYS_IO_CANCEL       = 210;
const int SYS_IO_PGETEVENTS   = 333;

// ---- io_uring (Linux 5.1+) ----
const int SYS_IO_URING_SETUP    = 425;
const int SYS_IO_URING_ENTER    = 426;
const int SYS_IO_URING_REGISTER = 427;

// ---- Splice / Tee / Sendfile ----
const int SYS_SPLICE          = 275;
const int SYS_TEE             = 276;
const int SYS_VMSPLICE        = 278;
const int SYS_SYNC_FILE_RANGE = 277;
const int SYS_COPY_FILE_RANGE = 326;
const int SYS_FALLOCATE       = 285;
const int SYS_PREADV          = 295;
const int SYS_PWRITEV         = 296;
const int SYS_PREADV2         = 327;
const int SYS_PWRITEV2        = 328;

// ---- Extended Attributes ----
const int SYS_SETXATTR        = 188;
const int SYS_LSETXATTR       = 189;
const int SYS_FSETXATTR       = 190;
const int SYS_GETXATTR        = 191;
const int SYS_LGETXATTR       = 192;
const int SYS_FGETXATTR       = 193;
const int SYS_LISTXATTR       = 194;
const int SYS_LLISTXATTR      = 195;
const int SYS_FLISTXATTR      = 196;
const int SYS_REMOVEXATTR     = 197;
const int SYS_LREMOVEXATTR    = 198;
const int SYS_FREMOVEXATTR    = 199;

// ---- System Info / Resource Limits ----
const int SYS_UNAME           = 63;
const int SYS_SYSLOG          = 103;
const int SYS_GETRLIMIT       = 97;
const int SYS_GETRUSAGE       = 98;
const int SYS_SYSINFO         = 99;
const int SYS_SETRLIMIT       = 160;
const int SYS_PRLIMIT64       = 302;
const int SYS_USTAT           = 136;
const int SYS_STATFS          = 137;
const int SYS_FSTATFS         = 138;
const int SYS_SYSFS           = 139;
const int SYS_STATX           = 332;
const int SYS_CACHESTAT       = 451;

// ---- IPC: Shared Memory ----
const int SYS_SHMGET          = 29;
const int SYS_SHMAT           = 30;
const int SYS_SHMCTL          = 31;
const int SYS_SHMDT           = 67;

// ---- IPC: Message Queues ----
const int SYS_MSGGET          = 68;
const int SYS_MSGSND          = 69;
const int SYS_MSGRCV          = 70;
const int SYS_MSGCTL          = 71;
const int SYS_MQ_OPEN         = 240;
const int SYS_MQ_UNLINK       = 241;
const int SYS_MQ_TIMEDSEND    = 242;
const int SYS_MQ_TIMEDRECEIVE = 243;
const int SYS_MQ_NOTIFY       = 244;
const int SYS_MQ_GETSETATTR   = 245;

// ---- IPC: Semaphores ----
const int SYS_SEMGET          = 64;
const int SYS_SEMOP           = 65;
const int SYS_SEMCTL          = 66;
const int SYS_SEMTIMEDOP      = 220;

// ---- Futex ----
const int SYS_FUTEX           = 202;
const int SYS_SET_ROBUST_LIST = 273;
const int SYS_GET_ROBUST_LIST = 274;
const int SYS_FUTEX_WAITV     = 449;
const int SYS_FUTEX_WAKE      = 454;
const int SYS_FUTEX_WAIT      = 455;
const int SYS_FUTEX_REQUEUE   = 456;

// ---- Thread Local Storage / Thread Area ----
const int SYS_SET_THREAD_AREA = 205;
const int SYS_GET_THREAD_AREA = 211;
const int SYS_SET_TID_ADDRESS = 218;
const int SYS_RSEQ            = 334;

// ---- Kernel Modules ----
const int SYS_CREATE_MODULE   = 174;  // Removed in 2.6
const int SYS_INIT_MODULE     = 175;
const int SYS_DELETE_MODULE   = 176;
const int SYS_GET_KERNEL_SYMS = 177;  // Removed in 2.6
const int SYS_QUERY_MODULE    = 178;  // Removed in 2.6
const int SYS_FINIT_MODULE    = 313;

// ---- kexec ----
const int SYS_KEXEC_LOAD      = 246;
const int SYS_KEXEC_FILE_LOAD = 320;

// ---- Filesystem / Mount ----
const int SYS_CHROOT          = 161;
const int SYS_SYNC            = 162;
const int SYS_SYNCFS          = 306;
const int SYS_MOUNT           = 165;
const int SYS_UMOUNT2         = 166;
const int SYS_PIVOT_ROOT      = 155;
const int SYS_SWAPON          = 167;
const int SYS_SWAPOFF         = 168;
const int SYS_QUOTACTL        = 179;
const int SYS_QUOTACTL_FD     = 443;
const int SYS_MKNOD           = 133;
const int SYS_LOOKUP_DCOOKIE  = 212;
const int SYS_USELIB          = 134;
const int SYS_NAME_TO_HANDLE_AT = 303;
const int SYS_OPEN_BY_HANDLE_AT = 304;
const int SYS_OPEN_TREE       = 428;
const int SYS_MOVE_MOUNT      = 429;
const int SYS_FSOPEN          = 430;
const int SYS_FSCONFIG        = 431;
const int SYS_FSMOUNT         = 432;
const int SYS_FSPICK          = 433;
const int SYS_MOUNT_SETATTR   = 442;
const int SYS_STATMOUNT       = 457;
const int SYS_LISTMOUNT       = 458;

// ---- Networking: Legacy / Misc ----
const int SYS_NFSSERVCTL      = 180;  // Removed in 3.1
const int SYS_GETPMSG         = 181;  // Not implemented
const int SYS_PUTPMSG         = 182;  // Not implemented
const int SYS_AFS_SYSCALL     = 183;  // Not implemented
const int SYS_TUXCALL         = 184;  // Not implemented
const int SYS_SECURITY        = 185;  // Not implemented
const int SYS_VSERVER         = 236;  // Not implemented

// ---- BPF / seccomp / landlock ----
const int SYS_BPF             = 321;
const int SYS_SECCOMP         = 317;
const int SYS_LANDLOCK_CREATE_RULESET = 444;
const int SYS_LANDLOCK_ADD_RULE       = 445;
const int SYS_LANDLOCK_RESTRICT_SELF  = 446;

// ---- Keys ----
const int SYS_ADD_KEY         = 248;
const int SYS_REQUEST_KEY     = 249;
const int SYS_KEYCTL          = 250;

// ---- Linux Security Modules ----
const int SYS_LSM_GET_SELF_ATTR  = 459;
const int SYS_LSM_SET_SELF_ATTR  = 460;
const int SYS_LSM_LIST_XATTRS   = 461;

// ---- Misc ----
const int SYS_VHANGUP         = 153;
const int SYS_MODIFY_LDT      = 154;
const int SYS_SETHOSTNAME     = 170;
const int SYS_SETDOMAINNAME   = 171;
const int SYS_IOPL            = 172;
const int SYS_IOPERM          = 173;
const int SYS_REBOOT          = 169;
const int SYS__SYSCTL         = 156;  // Removed in 5.5
const int SYS_RESTART_SYSCALL = 219;
const int SYS_GETRANDOM       = 318;
const int SYS_MEMBARRIER      = 324;



module c::sys::syscall @if(env::LINUX && env::AARCH64);

// syscall() invokes the kernel directly with the given syscall number.
// Returns -1 on error (errno is set), or the syscall-specific return value.
extern fn long syscall(long number, ...);

// ---- Async I/O (POSIX AIO) ----
const int SYS_IO_SETUP           = 0;
const int SYS_IO_DESTROY         = 1;
const int SYS_IO_SUBMIT          = 2;
const int SYS_IO_CANCEL          = 3;
const int SYS_IO_GETEVENTS       = 4;

// ---- Extended Attributes ----
const int SYS_SETXATTR           = 5;
const int SYS_LSETXATTR          = 6;
const int SYS_FSETXATTR          = 7;
const int SYS_GETXATTR           = 8;
const int SYS_LGETXATTR          = 9;
const int SYS_FGETXATTR          = 10;
const int SYS_LISTXATTR          = 11;
const int SYS_LLISTXATTR         = 12;
const int SYS_FLISTXATTR         = 13;
const int SYS_REMOVEXATTR        = 14;
const int SYS_LREMOVEXATTR       = 15;
const int SYS_FREMOVEXATTR       = 16;

// ---- Filesystem / Directory ----
const int SYS_GETCWD             = 17;
const int SYS_LOOKUP_DCOOKIE     = 18;

// ---- Event / Poll / Inotify ----
const int SYS_EVENTFD2           = 19;   // No SYS_EVENTFD on AArch64
const int SYS_EPOLL_CREATE1      = 20;   // No SYS_EPOLL_CREATE on AArch64
const int SYS_EPOLL_CTL          = 21;
const int SYS_EPOLL_PWAIT        = 22;   // No SYS_EPOLL_WAIT on AArch64
const int SYS_DUP                = 23;
const int SYS_DUP3               = 24;   // No SYS_DUP2 on AArch64
const int SYS_FCNTL              = 25;
const int SYS_INOTIFY_INIT1      = 26;   // No SYS_INOTIFY_INIT on AArch64
const int SYS_INOTIFY_ADD_WATCH  = 27;
const int SYS_INOTIFY_RM_WATCH   = 28;
const int SYS_IOCTL              = 29;
const int SYS_IOPRIO_SET         = 30;
const int SYS_IOPRIO_GET         = 31;
const int SYS_FLOCK              = 32;

// ---- File Creation / Linking ("at"-only) ----
const int SYS_MKNODAT            = 33;
const int SYS_MKDIRAT            = 34;
const int SYS_UNLINKAT           = 35;
const int SYS_SYMLINKAT          = 36;
const int SYS_LINKAT             = 37;
const int SYS_RENAMEAT           = 38;

// ---- Mount / Unmount ----
const int SYS_UMOUNT2            = 39;
const int SYS_MOUNT              = 40;
const int SYS_PIVOT_ROOT         = 41;
const int SYS_NFSSERVCTL         = 42;   // Removed in 3.1

// ---- Filesystem Info ----
const int SYS_STATFS             = 43;
const int SYS_FSTATFS            = 44;
const int SYS_TRUNCATE           = 45;
const int SYS_FTRUNCATE          = 46;
const int SYS_FALLOCATE          = 47;
const int SYS_FACCESSAT          = 48;

// ---- Directory Navigation ----
const int SYS_CHDIR              = 49;
const int SYS_FCHDIR             = 50;
const int SYS_CHROOT             = 51;
const int SYS_FCHMOD             = 52;
const int SYS_FCHMODAT           = 53;
const int SYS_FCHOWNAT           = 54;
const int SYS_FCHOWN             = 55;

// ---- File Open / Close ----
const int SYS_OPENAT             = 56;   // No SYS_OPEN on AArch64
const int SYS_CLOSE              = 57;
const int SYS_VHANGUP            = 58;

// ---- Pipe / Quota ----
const int SYS_PIPE2              = 59;   // No SYS_PIPE on AArch64
const int SYS_QUOTACTL           = 60;

// ---- Directory Entries ----
const int SYS_GETDENTS64         = 61;

// ---- File I/O ----
const int SYS_LSEEK              = 62;
const int SYS_READ               = 63;
const int SYS_WRITE              = 64;
const int SYS_READV              = 65;
const int SYS_WRITEV             = 66;
const int SYS_PREAD64            = 67;
const int SYS_PWRITE64           = 68;
const int SYS_PREADV             = 69;
const int SYS_PWRITEV            = 70;
const int SYS_SENDFILE           = 71;

// ---- I/O Multiplexing ----
const int SYS_PSELECT6           = 72;   // No SYS_SELECT on AArch64
const int SYS_PPOLL              = 73;   // No SYS_POLL on AArch64

// ---- Signals ----
const int SYS_SIGNALFD4          = 74;   // No SYS_SIGNALFD on AArch64
const int SYS_VMSPLICE           = 75;
const int SYS_SPLICE             = 76;
const int SYS_TEE                = 77;
const int SYS_READLINKAT         = 78;

// ---- Stat ----
const int SYS_FSTATAT            = 79;   // No SYS_STAT / SYS_LSTAT on AArch64
const int SYS_FSTAT              = 80;

// ---- Sync ----
const int SYS_SYNC               = 81;
const int SYS_FSYNC              = 82;
const int SYS_FDATASYNC          = 83;
const int SYS_SYNC_FILE_RANGE    = 84;

// ---- Timerfd ----
const int SYS_TIMERFD_CREATE     = 85;
const int SYS_TIMERFD_SETTIME    = 86;
const int SYS_TIMERFD_GETTIME    = 87;

// ---- Timestamps ----
const int SYS_UTIMENSAT          = 88;

// ---- Process Accounting / Capabilities ----
const int SYS_ACCT               = 89;
const int SYS_CAPGET             = 90;
const int SYS_CAPSET             = 91;
const int SYS_PERSONALITY        = 92;

// ---- Process Exit ----
const int SYS_EXIT               = 93;
const int SYS_EXIT_GROUP         = 94;
const int SYS_WAITID             = 95;

// ---- Thread / Task ----
const int SYS_SET_TID_ADDRESS    = 96;
const int SYS_UNSHARE            = 97;

// ---- Futex ----
const int SYS_FUTEX              = 98;
const int SYS_SET_ROBUST_LIST    = 99;
const int SYS_GET_ROBUST_LIST    = 100;

// ---- Time ----
const int SYS_NANOSLEEP          = 101;
const int SYS_GETITIMER          = 102;
const int SYS_SETITIMER          = 103;

// ---- kexec ----
const int SYS_KEXEC_LOAD         = 104;

// ---- Kernel Modules ----
const int SYS_INIT_MODULE        = 105;
const int SYS_DELETE_MODULE      = 106;

// ---- POSIX Timers ----
const int SYS_TIMER_CREATE       = 107;
const int SYS_TIMER_GETTIME      = 108;
const int SYS_TIMER_GETOVERRUN   = 109;
const int SYS_TIMER_SETTIME      = 110;
const int SYS_TIMER_DELETE       = 111;

// ---- POSIX Clocks ----
const int SYS_CLOCK_SETTIME      = 112;
const int SYS_CLOCK_GETTIME      = 113;
const int SYS_CLOCK_GETRES       = 114;
const int SYS_CLOCK_NANOSLEEP    = 115;

// ---- Syslog ----
const int SYS_SYSLOG             = 116;

// ---- Debug / Trace ----
const int SYS_PTRACE             = 117;

// ---- Scheduling ----
const int SYS_SCHED_SETPARAM         = 118;
const int SYS_SCHED_SETSCHEDULER     = 119;
const int SYS_SCHED_GETSCHEDULER     = 120;
const int SYS_SCHED_GETPARAM         = 121;
const int SYS_SCHED_SETAFFINITY      = 122;
const int SYS_SCHED_GETAFFINITY      = 123;
const int SYS_SCHED_YIELD            = 124;
const int SYS_SCHED_GET_PRIORITY_MAX = 125;
const int SYS_SCHED_GET_PRIORITY_MIN = 126;
const int SYS_SCHED_RR_GET_INTERVAL  = 127;

// ---- Misc ----
const int SYS_RESTART_SYSCALL    = 128;

// ---- Signals (continued) ----
const int SYS_KILL               = 129;
const int SYS_TKILL              = 130;
const int SYS_TGKILL             = 131;
const int SYS_SIGALTSTACK        = 132;
const int SYS_RT_SIGSUSPEND      = 133;
const int SYS_RT_SIGACTION       = 134;
const int SYS_RT_SIGPROCMASK     = 135;
const int SYS_RT_SIGPENDING      = 136;
const int SYS_RT_SIGTIMEDWAIT    = 137;
const int SYS_RT_SIGQUEUEINFO    = 138;
const int SYS_RT_SIGRETURN       = 139;

// ---- Priority / Resource ----
const int SYS_SETPRIORITY        = 140;
const int SYS_GETPRIORITY        = 141;
const int SYS_REBOOT             = 142;

// ---- User / Group IDs ----
const int SYS_SETREGID           = 143;
const int SYS_SETGID             = 144;
const int SYS_SETREUID           = 145;
const int SYS_SETUID             = 146;
const int SYS_SETRESUID          = 147;
const int SYS_GETRESUID          = 148;
const int SYS_SETRESGID          = 149;
const int SYS_GETRESGID          = 150;
const int SYS_SETFSUID           = 151;
const int SYS_SETFSGID           = 152;
const int SYS_TIMES              = 153;
const int SYS_SETPGID            = 154;
const int SYS_GETPGID            = 155;
const int SYS_GETSID             = 156;
const int SYS_SETSID             = 157;
const int SYS_GETGROUPS          = 158;
const int SYS_SETGROUPS          = 159;

// ---- System Info ----
const int SYS_UNAME              = 160;
const int SYS_SETHOSTNAME        = 161;
const int SYS_SETDOMAINNAME      = 162;
const int SYS_GETRLIMIT          = 163;
const int SYS_SETRLIMIT          = 164;
const int SYS_GETRUSAGE          = 165;
const int SYS_UMASK              = 166;
const int SYS_PRCTL              = 167;
const int SYS_GETCPU             = 168;

// ---- Time (gettimeofday) ----
const int SYS_GETTIMEOFDAY       = 169;
const int SYS_SETTIMEOFDAY       = 170;
const int SYS_ADJTIMEX           = 171;

// ---- Process IDs ----
const int SYS_GETPID             = 172;
const int SYS_GETPPID            = 173;
const int SYS_GETUID             = 174;
const int SYS_GETEUID            = 175;
const int SYS_GETGID             = 176;
const int SYS_GETEGID            = 177;
const int SYS_GETTID             = 178;
const int SYS_SYSINFO            = 179;

// ---- POSIX Message Queues ----
const int SYS_MQ_OPEN            = 180;
const int SYS_MQ_UNLINK          = 181;
const int SYS_MQ_TIMEDSEND       = 182;
const int SYS_MQ_TIMEDRECEIVE    = 183;
const int SYS_MQ_NOTIFY          = 184;
const int SYS_MQ_GETSETATTR      = 185;

// ---- SysV Message Queues ----
const int SYS_MSGGET             = 186;
const int SYS_MSGCTL             = 187;
const int SYS_MSGRCV             = 188;
const int SYS_MSGSND             = 189;

// ---- SysV Semaphores ----
const int SYS_SEMGET             = 190;
const int SYS_SEMCTL             = 191;
const int SYS_SEMTIMEDOP         = 192;
const int SYS_SEMOP              = 193;

// ---- SysV Shared Memory ----
const int SYS_SHMGET             = 194;
const int SYS_SHMCTL             = 195;
const int SYS_SHMAT              = 196;
const int SYS_SHMDT              = 197;

// ---- Networking / Sockets ----
const int SYS_SOCKET             = 198;
const int SYS_SOCKETPAIR         = 199;
const int SYS_BIND               = 200;
const int SYS_LISTEN             = 201;
const int SYS_ACCEPT             = 202;
const int SYS_CONNECT            = 203;
const int SYS_GETSOCKNAME        = 204;
const int SYS_GETPEERNAME        = 205;
const int SYS_SENDTO             = 206;
const int SYS_RECVFROM           = 207;
const int SYS_SETSOCKOPT         = 208;
const int SYS_GETSOCKOPT         = 209;
const int SYS_SHUTDOWN           = 210;
const int SYS_SENDMSG            = 211;
const int SYS_RECVMSG            = 212;

// ---- File Readahead ----
const int SYS_READAHEAD          = 213;

// ---- Memory Management ----
const int SYS_BRK                = 214;
const int SYS_MUNMAP             = 215;
const int SYS_MREMAP             = 216;

// ---- Keys ----
const int SYS_ADD_KEY            = 217;
const int SYS_REQUEST_KEY        = 218;
const int SYS_KEYCTL             = 219;

// ---- Process Creation ----
const int SYS_CLONE              = 220;   // Replaces fork/vfork on AArch64
const int SYS_EXECVE             = 221;

// ---- Memory Mapping ----
const int SYS_MMAP               = 222;
const int SYS_FADVISE64          = 223;

// ---- Swap ----
const int SYS_SWAPON             = 224;
const int SYS_SWAPOFF            = 225;

// ---- Memory Protection ----
const int SYS_MPROTECT           = 226;
const int SYS_MSYNC              = 227;
const int SYS_MLOCK              = 228;
const int SYS_MUNLOCK            = 229;
const int SYS_MLOCKALL           = 230;
const int SYS_MUNLOCKALL         = 231;
const int SYS_MINCORE            = 232;
const int SYS_MADVISE            = 233;
const int SYS_REMAP_FILE_PAGES   = 234;
const int SYS_MBIND              = 235;
const int SYS_GET_MEMPOLICY      = 236;
const int SYS_SET_MEMPOLICY      = 237;
const int SYS_MIGRATE_PAGES      = 238;
const int SYS_MOVE_PAGES         = 239;

// ---- Signals (rt_tgsig) ----
const int SYS_RT_TGSIGQUEUEINFO  = 240;

// ---- Performance / Profiling ----
const int SYS_PERF_EVENT_OPEN    = 241;

// ---- Sockets (continued) ----
const int SYS_ACCEPT4            = 242;
const int SYS_RECVMMSG           = 243;

// 244–259: reserved / architecture-specific range

// ---- Process Wait ----
const int SYS_WAIT4              = 260;

// ---- Resource Limits (extended) ----
const int SYS_PRLIMIT64          = 261;

// ---- Fanotify ----
const int SYS_FANOTIFY_INIT      = 262;
const int SYS_FANOTIFY_MARK      = 263;

// ---- Handle-based Open ----
const int SYS_NAME_TO_HANDLE_AT  = 264;
const int SYS_OPEN_BY_HANDLE_AT  = 265;

// ---- Clock Adjtime ----
const int SYS_CLOCK_ADJTIME      = 266;

// ---- Sync (filesystem) ----
const int SYS_SYNCFS             = 267;

// ---- Namespace ----
const int SYS_SETNS              = 268;

// ---- Sockets (sendmmsg) ----
const int SYS_SENDMMSG           = 269;

// ---- Process VM ----
const int SYS_PROCESS_VM_READV   = 270;
const int SYS_PROCESS_VM_WRITEV  = 271;

// ---- Process Comparison ----
const int SYS_KCMP               = 272;

// ---- Kernel Modules (extended) ----
const int SYS_FINIT_MODULE       = 273;

// ---- Scheduling (extended) ----
const int SYS_SCHED_SETATTR      = 274;
const int SYS_SCHED_GETATTR      = 275;

// ---- File Rename (extended) ----
const int SYS_RENAMEAT2          = 276;

// ---- Security ----
const int SYS_SECCOMP            = 277;
const int SYS_GETRANDOM          = 278;

// ---- Memory FD ----
const int SYS_MEMFD_CREATE       = 279;

// ---- BPF ----
const int SYS_BPF                = 280;

// ---- Process Exec (extended) ----
const int SYS_EXECVEAT           = 281;

// ---- User Fault FD ----
const int SYS_USERFAULTFD        = 282;

// ---- Memory Barrier ----
const int SYS_MEMBARRIER         = 283;

// ---- Memory Lock (extended) ----
const int SYS_MLOCK2             = 284;

// ---- File Copy ----
const int SYS_COPY_FILE_RANGE    = 285;

// ---- Vectored I/O (extended) ----
const int SYS_PREADV2            = 286;
const int SYS_PWRITEV2           = 287;

// ---- Memory Protection Keys ----
const int SYS_PKEY_MPROTECT      = 288;
const int SYS_PKEY_ALLOC         = 289;
const int SYS_PKEY_FREE          = 290;

// ---- Extended Stat ----
const int SYS_STATX              = 291;

// ---- Async I/O (extended) ----
const int SYS_IO_PGETEVENTS      = 292;

// ---- Restartable Sequences ----
const int SYS_RSEQ               = 293;

// 294–423: reserved

// ---- PID FD / Signals ----
const int SYS_PIDFD_SEND_SIGNAL  = 424;

// ---- io_uring (Linux 5.1+) ----
const int SYS_IO_URING_SETUP     = 425;
const int SYS_IO_URING_ENTER     = 426;
const int SYS_IO_URING_REGISTER  = 427;

// ---- New Mount API (Linux 5.2+) ----
const int SYS_OPEN_TREE          = 428;
const int SYS_MOVE_MOUNT         = 429;
const int SYS_FSOPEN             = 430;
const int SYS_FSCONFIG           = 431;
const int SYS_FSMOUNT            = 432;
const int SYS_FSPICK             = 433;

// ---- PID FD (Linux 5.3+) ----
const int SYS_PIDFD_OPEN         = 434;

// ---- Clone3 (Linux 5.3+) ----
const int SYS_CLONE3             = 435;

// ---- Close Range (Linux 5.9+) ----
const int SYS_CLOSE_RANGE        = 436;

// ---- Openat2 (Linux 5.6+) ----
const int SYS_OPENAT2            = 437;

// ---- PID FD Get FD (Linux 5.6+) ----
const int SYS_PIDFD_GETFD        = 438;

// ---- Faccessat2 (Linux 5.8+) ----
const int SYS_FACCESSAT2         = 439;

// ---- Process Madvise (Linux 5.10+) ----
const int SYS_PROCESS_MADVISE    = 440;

// ---- Epoll Pwait2 (Linux 5.11+) ----
const int SYS_EPOLL_PWAIT2       = 441;

// ---- Mount Setattr (Linux 5.12+) ----
const int SYS_MOUNT_SETATTR      = 442;

// ---- Quotactl FD (Linux 5.14+) ----
const int SYS_QUOTACTL_FD        = 443;

// ---- Landlock (Linux 5.13+) ----
const int SYS_LANDLOCK_CREATE_RULESET = 444;
const int SYS_LANDLOCK_ADD_RULE       = 445;
const int SYS_LANDLOCK_RESTRICT_SELF  = 446;

// ---- Memfd Secret (Linux 5.14+) ----
const int SYS_MEMFD_SECRET       = 447;

// ---- Process Mrelease (Linux 5.15+) ----
const int SYS_PROCESS_MRELEASE   = 448;

// ---- Futex (extended, Linux 5.16+) ----
const int SYS_FUTEX_WAITV        = 449;

// ---- NUMA Memory Policy (Linux 5.17+) ----
const int SYS_SET_MEMPOLICY_HOME_NODE = 450;

// ---- Cache Stat (Linux 6.5+) ----
const int SYS_CACHESTAT          = 451;

// ---- Fchmodat2 (Linux 6.6+) ----
const int SYS_FCHMODAT2          = 452;

// ---- Shadow Stack (Linux 6.6+) ----
const int SYS_MAP_SHADOW_STACK   = 453;

// ---- Futex (Linux 6.7+) ----
const int SYS_FUTEX_WAKE         = 454;
const int SYS_FUTEX_WAIT         = 455;
const int SYS_FUTEX_REQUEUE      = 456;

// ---- Mount Stat (Linux 6.8+) ----
const int SYS_STATMOUNT          = 457;
const int SYS_LISTMOUNT          = 458;

// ---- LSM (Linux 6.8+) ----
const int SYS_LSM_GET_SELF_ATTR  = 459;
const int SYS_LSM_SET_SELF_ATTR  = 460;
const int SYS_LSM_LIST_XATTRS   = 461;
