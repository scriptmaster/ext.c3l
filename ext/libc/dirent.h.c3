// dirent.h.c3

module dirent;

// ========== Linux ==========

module dirent @if(env::LINUX);

// Function Declarations
extern fn Dir* opendir(char* name);
extern fn Dir* fdopendir(int fd);
extern fn int closedir(Dir* dirp);
extern fn DirEnt* readdir(Dir* dirp);
extern fn int readdir_r(Dir* dirp, DirEnt* entry, DirEnt** result);
extern fn void rewinddir(Dir* dirp);
extern fn void seekdir(Dir* dirp, long loc);
extern fn long telldir(Dir* dirp);
extern fn int dirfd(Dir* dirp);
extern fn int scandir(char* dirp, DirEnt*** namelist, void* filter, void* compar);
extern fn int alphasort(DirEnt** a, DirEnt** b);
extern fn int versionsort(DirEnt** a, DirEnt** b);

// Type Definitions
alias Dir = void;

struct DirEnt {
    ulong d_ino;
    long d_off;
    ushort d_reclen;
    char d_type;
    char[256] d_name;
}

// File type constants (d_type field)
const char DT_UNKNOWN = 0;
const char DT_FIFO = 1;
const char DT_CHR = 2;
const char DT_DIR = 4;
const char DT_BLK = 6;
const char DT_REG = 8;
const char DT_LNK = 10;
const char DT_SOCK = 12;
const char DT_WHT = 14;


// ========== Darwin ==========

module dirent @if(env::DARWIN);

// Function Declarations
extern fn Dir* opendir(char* name);
extern fn Dir* fdopendir(int fd);
extern fn int closedir(Dir* dirp);
extern fn DirEnt* readdir(Dir* dirp);
extern fn int readdir_r(Dir* dirp, DirEnt* entry, DirEnt** result);
extern fn void rewinddir(Dir* dirp);
extern fn void seekdir(Dir* dirp, long loc);
extern fn long telldir(Dir* dirp);
extern fn int dirfd(Dir* dirp);
extern fn int scandir(char* dirp, DirEnt*** namelist, void* filter, void* compar);
extern fn int alphasort(DirEnt** a, DirEnt** b);

// Type Definitions
alias Dir = void;

struct DirEnt {
    ulong d_ino;
    ulong d_seekoff;
    ushort d_reclen;
    ushort d_namlen;
    char d_type;
    char[1024] d_name;
}

// File type constants (d_type field)
const char DT_UNKNOWN = 0;
const char DT_FIFO = 1;
const char DT_CHR = 2;
const char DT_DIR = 4;
const char DT_BLK = 6;
const char DT_REG = 8;
const char DT_LNK = 10;
const char DT_SOCK = 12;
const char DT_WHT = 14;


// Darwin-specific constants
const int MAXNAMLEN = 255;

// ========== FreeBSD ==========

module dirent @if(env::FREEBSD);

// Function Declarations
extern fn Dir* opendir(char* name);
extern fn Dir* fdopendir(int fd);
extern fn int closedir(Dir* dirp);
extern fn DirEnt* readdir(Dir* dirp);
extern fn int readdir_r(Dir* dirp, DirEnt* entry, DirEnt** result);
extern fn void rewinddir(Dir* dirp);
extern fn void seekdir(Dir* dirp, long loc);
extern fn long telldir(Dir* dirp);
extern fn int dirfd(Dir* dirp);
extern fn int scandir(char* dirp, DirEnt*** namelist, void* filter, void* compar);
extern fn int alphasort(DirEnt** a, DirEnt** b);

// Type Definitions
alias Dir = void;

struct DirEnt {
    uint d_fileno;
    ushort d_reclen;
    char d_type;
    char d_namlen;
    char[256] d_name;
}

// File type constants (d_type field)
const char DT_UNKNOWN = 0;
const char DT_FIFO = 1;
const char DT_CHR = 2;
const char DT_DIR = 4;
const char DT_BLK = 6;
const char DT_REG = 8;
const char DT_LNK = 10;
const char DT_SOCK = 12;
const char DT_WHT = 14;

// FreeBSD-specific constants
const int MAXNAMLEN = 255;

// ========== NetBSD ==========

module dirent @if(env::NETBSD);

// Function Declarations
extern fn Dir* opendir(char* name);
extern fn Dir* fdopendir(int fd);
extern fn int closedir(Dir* dirp);
extern fn DirEnt* readdir(Dir* dirp);
extern fn int readdir_r(Dir* dirp, DirEnt* entry, DirEnt** result);
extern fn void rewinddir(Dir* dirp);
extern fn void seekdir(Dir* dirp, long loc);
extern fn long telldir(Dir* dirp);
extern fn int dirfd(Dir* dirp);
extern fn int scandir(char* dirp, DirEnt*** namelist, void* filter, void* compar);
extern fn int alphasort(DirEnt** a, DirEnt** b);

// Type Definitions
alias Dir = void;

struct DirEnt {
    ulong d_fileno;
    ushort d_reclen;
    ushort d_namlen;
    char d_type;
    char[512] d_name;
}

// File type constants (d_type field)
const char DT_UNKNOWN = 0;
const char DT_FIFO = 1;
const char DT_CHR = 2;
const char DT_DIR = 4;
const char DT_BLK = 6;
const char DT_REG = 8;
const char DT_LNK = 10;
const char DT_SOCK = 12;
const char DT_WHT = 14;

// NetBSD-specific constants
const int MAXNAMLEN = 511;

// ========== OpenBSD ==========

module dirent @if(env::OPENBSD);

// Function Declarations
extern fn Dir* opendir(char* name);
extern fn Dir* fdopendir(int fd);
extern fn int closedir(Dir* dirp);
extern fn DirEnt* readdir(Dir* dirp);
extern fn int readdir_r(Dir* dirp, DirEnt* entry, DirEnt** result);
extern fn void rewinddir(Dir* dirp);
extern fn void seekdir(Dir* dirp, long loc);
extern fn long telldir(Dir* dirp);
extern fn int dirfd(Dir* dirp);
extern fn int scandir(char* dirp, DirEnt*** namelist, void* filterfn, void* comparfn);
extern fn int alphasort(DirEnt** a, DirEnt** b);

// Type Definitions
alias Dir = void;

struct DirEnt {
    ulong d_fileno;
    long d_off;
    ushort d_reclen;
    char d_type;
    char d_namlen;
    char[4] __d_padding;
    char[256] d_name;
}

// File type constants (d_type field)
const char DT_UNKNOWN = 0;
const char DT_FIFO = 1;
const char DT_CHR = 2;
const char DT_DIR = 4;
const char DT_BLK = 6;
const char DT_REG = 8;
const char DT_LNK = 10;
const char DT_SOCK = 12;
const char DT_WHT = 14;

// OpenBSD-specific constants
const int MAXNAMLEN = 255;
