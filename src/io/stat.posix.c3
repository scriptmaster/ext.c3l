
// std/io/os/stat.posix.c3
//
// This module provides following functions for Posix systems.
// file_exists() file_size() last_modified() 
// is_dir() is_file() is_link() 
// is_readable() is_writeable()
// is_executable()
// read_link()


module ext::io::stat @if(!env::WIN32); // Posix

import libc;

// extern fn CInt libc::stat(char* path, Stat* buf) ;
extern fn CInt lstat(char* path, Stat* buf);
extern fn CInt access(char* path, CInt mode);
extern fn CLong readlink(char* path, char* buf, CULong bufsize);

// File mode constants
const CUInt S_IFMT   = 0o170000;  // Bit mask for file type
const CUInt S_IFSOCK = 0o140000;  // Socket
const CUInt S_IFLNK  = 0o120000;  // Symbolic link
const CUInt S_IFREG  = 0o100000;  // Regular file
const CUInt S_IFBLK  = 0o060000;  // Block device
const CUInt S_IFDIR  = 0o040000;  // Directory
const CUInt S_IFCHR  = 0o020000;  // Character device
const CUInt S_IFIFO  = 0o010000;  // FIFO

// Permission bits
const CUInt S_ISUID  = 0o4000;    // Set UID bit
const CUInt S_ISGID  = 0o2000;    // Set GID bit
const CUInt S_ISVTX  = 0o1000;    // Sticky bit
const CUInt S_IRWXU  = 0o0700;    // Owner permissions
const CUInt S_IRUSR  = 0o0400;    // Owner read
const CUInt S_IWUSR  = 0o0200;    // Owner write
const CUInt S_IXUSR  = 0o0100;    // Owner execute
const CUInt S_IRWXG  = 0o0070;    // Group permissions
const CUInt S_IRWXO  = 0o0007;    // Other permissions

// Access mode constants
const CInt F_OK = 0;  // File exists
const CInt R_OK = 4;  // Read permission
const CInt W_OK = 2;  // Write permission
const CInt X_OK = 1;  // Execute permission

const int MAX_PATH = 1024;

// Detailed fault definitions
faultdef 
    PATH_NOT_FOUND,      // ENOENT: File or directory doesn't exist
    PERMISSION_DENIED,   // EACCES: Permission denied
    NOT_A_DIRECTORY,     // ENOTDIR: Component in path is not a directory
    IS_A_DIRECTORY,      // EISDIR: Path is a directory when file expected
    TOO_MANY_LINKS,      // ELOOP: Too many symbolic links
    PATH_TOO_LONG,       // ENAMETOOLONG: Path or component too long
    FILE_TOO_LARGE,      // EOVERFLOW: File size cannot be represented
    IO_ERROR,            // EIO: I/O error occurred
    INVALID_ARG,    // EINVAL: Invalid argument
    GENERAL_ERR        // Other errors
    ;

// Helper macro to convert String to ZString safely
macro ZString? path_to_zstring(String path, char[] buffer)
{
    if (path.len >= buffer.len) return PATH_TOO_LONG~;
    buffer[0:path.len] = path[0:path.len];
    buffer[path.len] = 0;  // Add null terminator
    return (ZString)&buffer[0];
}

// Helper function to convert errno to appropriate fault
fn fault errno_to_fault()
{
    Errno err = libc::errno();
    
    switch (err)
    {
        case errno::ENOENT:
            return PATH_NOT_FOUND;
        case errno::EACCES:
            return PERMISSION_DENIED;
        case errno::ENOTDIR:
            return NOT_A_DIRECTORY;
        case errno::EISDIR:
            return IS_A_DIRECTORY;
        case errno::ELOOP:
            return TOO_MANY_LINKS;
        case errno::ENAMETOOLONG:
            return PATH_TOO_LONG;
        case errno::EOVERFLOW:
            return FILE_TOO_LARGE;
        case errno::EIO:
            return IO_ERROR;
        case errno::EINVAL:
            return INVALID_ARG;
        default:
            return GENERAL_ERR;
    }
}

fn ulong? file_size(String path)
{
    char[MAX_PATH] p2; 
    ZString zpath = path_to_zstring(path, &p2)!;
    
    Stat st;
    if (libc::stat(zpath, &st) != 0) {
        return errno_to_fault()~;
    }
    
    return (ulong)st.st_size;
}

fn bool file_exists(String path)
{
    char[MAX_PATH] p2; 
    ZString? zpath = path_to_zstring(path, &p2);
    if (catch zpath) return false;
    
    return access(zpath, F_OK) == 0;
}

fn bool is_dir(String path)
{
    char[MAX_PATH] p2; 
    ZString? zpath = path_to_zstring(path, &p2);
    if (catch zpath) return false;
    
    Stat st;
    if (libc::stat(zpath, &st) != 0) return false;
    
    return (st.st_mode & S_IFMT) == S_IFDIR;
}

fn bool is_file(String path)
{
    char[MAX_PATH] p2; 
    ZString? zpath = path_to_zstring(path, &p2);
    if (catch zpath) return false;
    
    Stat st;
    if (libc::stat(zpath, &st) != 0) return false;
    
    return (st.st_mode & S_IFMT) == S_IFREG;
}

fn bool is_link(String path)
{
    char[MAX_PATH] p2; 
    ZString? zpath = path_to_zstring(path, &p2);
    if (catch zpath) return false;
    
    Stat st;
    // lstat doesn't follow symbolic links
    if (lstat(zpath, &st) != 0) return false;
    
    return (st.st_mode & S_IFMT) == S_IFLNK;
}

fn long? last_modified(String path)
{
    char[MAX_PATH] p2; 
    ZString zpath = path_to_zstring(path, &p2)!;
    
    Stat st;
    if (libc::stat(zpath, &st) != 0) {
        return errno_to_fault()~;
    }
    
    return st.st_mtime;  // Macro handles platform differences
}

fn bool is_readable(String path)
{
    char[MAX_PATH] p2; 
    ZString? zpath = path_to_zstring(path, &p2);
    if (catch zpath) return false;
    
    return access(zpath, R_OK) == 0;
}

fn bool is_writeable(String path)
{
    char[MAX_PATH] p2; 
    ZString? zpath = path_to_zstring(path, &p2);
    if (catch zpath) return false;
    
    return access(zpath, W_OK) == 0;
}

fn bool is_executable(String path)
{
    char[MAX_PATH] p2; 
    ZString? zpath = path_to_zstring(path, &p2);
    if (catch zpath) return false;
    
    return access(zpath, X_OK) == 0;
}

fn usz? read_link(String path, char[] output)
{
    char[MAX_PATH] p2; 
    ZString zpath = path_to_zstring(path, &p2)!;
    
    // Check for empty buffer
    if (output.len == 0) {
        return INVALID_ARG~;
    }
    
    CLong n = readlink(zpath, output.ptr, (CULong)output.len-1);
    
    if (n < 0) {
        return errno_to_fault()~;
    }
    
    output[n] = 0;
    return (usz)n;
}

/*
module stat::test;

import std::io;

fn void test_libc::stat()
{
    // Test with detailed error handling
    ulong? size = io::file_size("test.txt");
    if (catch err = size) {
        switch (err)
        {
            case PATH_NOT_FOUND:
                io::printn("Error: File not found");
            case PERMISSION_DENIED:
                io::printn("Error: Permission denied");
            case PATH_TOO_LONG:
                io::printn("Error: Path too long for buffer");
            case PATH_TOO_LONG:
                io::printn("Error: Path name too long (system limit)");
            default:
                io::printfn("Error: %s", err);
        }
    } else {
        io::printfn("File size: %d bytes", size);
    }
    
    // Test basic checks - these now safely return false on path errors
    if (io::file_exists("test.txt")) {
        io::printn("File exists!");
        
        if (io::is_readable("test.txt")) {
            io::printn("File is readable");
        }
        
        if (io::is_writeable("test.txt")) {
            io::printn("File is writeable");
        }
        
        if (io::is_executable("test.txt")) {
            io::printn("File is executable");
        }
    }
    
    // Test with very long path - safely returns false instead of panic
    char[2000] long_path;
    for (int i = 0; i < 1999; i++) {
        long_path[i] = 'a';
    }
    long_path[1999] = 0;
    String long_str = (String)&long_path;
    
    if (io::file_exists(long_str)) {
        io::printn("Impossible - path too long!");
    } else {
        io::printn("Long path correctly handled (returns false)");
    }
    
    // Test directory check
    if (io::is_dir("/tmp")) {
        io::printn("/tmp is a directory");
    }
    
    // Test symbolic link reading with error handling
    if (io::is_link("mylink")) {
        char[MAX_PATH] target;
        usz? len = io::read_link("mylink", &target);
        if (catch err = len) {
            switch (err)
            {
                case PATH_TOO_LONG:
                    io::printn("Error: Link path too long for buffer");
                case INVALID_ARG:
                    io::printn("Error: Invalid buffer provided");
                default:
                    io::printfn("Cannot read link: %s", err);
            }
        } else {
            io::printfn("Link target: %s", (ZString)target.ptr);
        }
    }
    
    // Test modification time with error handling
    long? mtime = io::last_modified("test.txt");
    if (catch err = mtime) {
        io::printfn("Cannot get modification time: %s", err);
    } else {
        io::printfn("Last modified: %d", mtime);
    }
}
*/
