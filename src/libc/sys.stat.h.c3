// sys.stat.h.c3

// sys/stat.h

module sys::stat @if(!env::WIN32);

// Get file status
extern fn CInt stat(char* path, Stat* buf);
extern fn CInt fstat(CInt fd, Stat* buf);
extern fn CInt lstat(char* path, Stat* buf);

// Get file status (including flags) - Linux only
extern fn CInt fstatat(CInt dirfd, char* pathname, Stat* buf, CInt flags);


// Chane file permission
extern fn CInt chmod(char* path, Mode mode);
extern fn CInt fchmod(CInt fd, Mode mode);
extern fn CInt fchmodat(CInt dirfd, char* pathname, Mode mode, CInt flags);

// Make directory
extern fn CInt mkdir(char* pathname, Mode mode);
extern fn CInt mkdirat(CInt dirfd, char* pathname, Mode mode);

// FIFO special file create
extern fn CInt mkfifo(char* pathname, Mode mode);
extern fn CInt mkfifoat(CInt dirfd, char* pathname, Mode mode);

// File create 
extern fn CInt mknod(char* pathname, Mode mode, Dev dev);
extern fn CInt mknodat(CInt dirfd, char* pathname, Mode mode, Dev dev);

// File creation mode masking
extern fn Mode umask(Mode mask);

module sys::stat @if(env::POSIX);

// POSIX  asic types
alias Mode = CUInt;
alias Dev = CULong;
alias Ino = CULong;
alias Nlink = CULong;
alias Uid = CUInt;
alias Gid = CUInt;
alias Off = CLongLong;
alias BlkSize = CLong;
alias BlkCnt = CLongLong;
alias Time = CLong;

// TimeSpec 
struct TimeSpec {
    Time tv_sec;
    CLong tv_nsec;
}

// struct stat
struct Stat {
    Dev st_dev; 
    Ino st_ino;  
    Nlink st_nlink; 
    Mode st_mode;
    Uid st_uid;
    Gid st_gid; 
    CInt __pad0;
    Dev st_rdev;
    Off st_size;
    BlkSize st_blksize;
    BlkCnt st_blocks;
    TimeSpec st_atim;
    TimeSpec st_mtim;
    TimeSpec st_ctim;
    
    CLong[3] __unused;
}

// File type mask
const Mode S_IFMT   = 0o170000;
const Mode S_IFSOCK = 0o140000;
const Mode S_IFLNK  = 0o120000;
const Mode S_IFREG  = 0o100000;
const Mode S_IFBLK  = 0o060000;
const Mode S_IFDIR  = 0o040000;
const Mode S_IFCHR  = 0o020000;
const Mode S_IFIFO  = 0o010000;

// File type test macro 
fn bool s_isreg(Mode m) @inline => (m & S_IFMT) == S_IFREG;
fn bool s_isdir(Mode m) @inline => (m & S_IFMT) == S_IFDIR;
fn bool s_ischr(Mode m) @inline => (m & S_IFMT) == S_IFCHR;
fn bool s_isblk(Mode m) @inline => (m & S_IFMT) == S_IFBLK;
fn bool s_isfifo(Mode m) @inline => (m & S_IFMT) == S_IFIFO;
fn bool s_islnk(Mode m) @inline => (m & S_IFMT) == S_IFLNK;
fn bool s_issock(Mode m) @inline => (m & S_IFMT) == S_IFSOCK;

// Owner permission
const Mode S_ISUID = 0o4000;
const Mode S_ISGID = 0o2000;
const Mode S_ISVTX = 0o1000;
const Mode S_IRWXU = 0o0700;
const Mode S_IRUSR = 0o0400;
const Mode S_IWUSR = 0o0200;
const Mode S_IXUSR = 0o0100;

// Group permission
const Mode S_IRWXG = 0o0070;
const Mode S_IRGRP = 0o0040;
const Mode S_IWGRP = 0o0020;
const Mode S_IXGRP = 0o0010;

// Other user permission
const Mode S_IRWXO = 0o0007;
const Mode S_IROTH = 0o0004;
const Mode S_IWOTH = 0o0002;
const Mode S_IXOTH = 0o0001;

