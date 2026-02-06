// std/io/os/stat.win32.c3

module ext::io::stat @if(env::WIN32);

import errno;

alias Dword = uint;
alias Handle = void*;
alias Bool = int;
alias LPCWstr = Char16*;
alias Long = long;
alias Mode_t = uint;

// Permission bit constants (POSIX Compatible)
const Mode_t S_IRUSR = 0o0400;    // Owner read
const Mode_t S_IWUSR = 0o0200;    // Owner write
const Mode_t S_IXUSR = 0o0100;    // Owner execute
const Mode_t S_IRGRP = 0o0040;    // Group read
const Mode_t S_IWGRP = 0o0020;    // Group write
const Mode_t S_IXGRP = 0o0010;    // Group execute
const Mode_t S_IROTH = 0o0004;    // Others read
const Mode_t S_IWOTH = 0o0002;    // Others write
const Mode_t S_IXOTH = 0o0001;    // Others execute

const Handle INVALID_HANDLE_VALUE = (Handle)uptr.max;
const Dword GENERIC_READ = 0x80000000;
const Dword GENERIC_WRITE = 0x40000000;
const Dword FILE_SHARE_READ = 0x00000001;
const Dword FILE_SHARE_WRITE = 0x00000002;
const Dword OPEN_EXISTING = 3;
const Dword FILE_ATTRIBUTE_DIRECTORY = 0x10;
const Dword FILE_ATTRIBUTE_NORMAL = 0x80;
const Dword FILE_ATTRIBUTE_READONLY = 0x01;
const Dword FILE_ATTRIBUTE_REPARSE_POINT = 0x400;
const Dword FILE_FLAG_OPEN_REPARSE_POINT = 0x00200000;
const Dword INVALID_FILE_ATTRIBUTES = 0xFFFFFFFF;
const Dword IO_REPARSE_TAG_SYMLINK = 0xA000000C;
const Dword IO_REPARSE_TAG_MOUNT_POINT = 0xA0000003;
const Dword FSCTL_GET_REPARSE_POINT = 0x900a8;

const Dword ERROR_FILE_NOT_FOUND = 2;
const Dword ERROR_PATH_NOT_FOUND = 3;
const Dword ERROR_ACCESS_DENIED = 5;
const Dword ERROR_SHARING_VIOLATION = 32;
const Dword ERROR_INVALID_NAME = 123;
const Dword ERROR_FILENAME_EXCEED_RANGE = 206;

struct Win32FileAttributeData {
    Dword dwFileAttributes;
    Dword ftCreationTime_low;
    Dword ftCreationTime_high;
    Dword ftLastAccessTime_low;
    Dword ftLastAccessTime_high;
    Dword ftLastWriteTime_low;
    Dword ftLastWriteTime_high;
    Dword nFileSizeHigh;
    Dword nFileSizeLow;
}

struct Win32FindDataW {
    Dword dwFileAttributes;
    Dword ftCreationTime_low;
    Dword ftCreationTime_high;
    Dword ftLastAccessTime_low;
    Dword ftLastAccessTime_high;
    Dword ftLastWriteTime_low;
    Dword ftLastWriteTime_high;
    Dword nFileSizeHigh;
    Dword nFileSizeLow;
    Dword dwReserved0;
    Dword dwReserved1;
    ushort[260] cFileName;
    ushort[14] cAlternateFileName;
}

struct ReparseDataBuffer {
    Dword reparseTag;
    ushort reparseDataLength;
    ushort reserved;
    ushort substituteNameOffset;
    ushort substituteNameLength;
    ushort printNameOffset;
    ushort printNameLength;
    Dword flags;
    ushort[1] pathBuffer;
}

faultdef 
    PATH_NOT_FOUND,
    PERMISSION_DENIED,
    PATH_TOO_LONG,
    SHARING_VIOLATION,
    INVALID_NAME,
    IO_ERROR,
    GENERAL_ERR;

extern fn Bool getFileAttributesExW(
    LPCWstr filename, 
    int info_level, 
    void* file_info
) @cname("GetFileAttributesExW");

extern fn Dword getFileAttributesW(
    LPCWstr filename
) @cname("GetFileAttributesW");

extern fn Handle createFileW(
    LPCWstr filename,
    Dword access,
    Dword share_mode, 
    void* security, 
    Dword creation,
    Dword flags, 
    Handle template
) @cname("CreateFileW");

extern fn Bool closeHandle(Handle handle) @cname("CloseHandle");

extern fn Bool getFileSizeEx(Handle file, Long* size) @cname("GetFileSizeEx");

extern fn Bool deviceIoControl(
    Handle device, 
    Dword control_code, 
    void* in_buffer, 
    Dword in_size,
    void* out_buffer, 
    Dword out_size, 
    Dword* bytes_returned, 
    void* overlapped
) @cname("DeviceIoControl");

extern fn Handle findFirstFileW(
    LPCWstr filename, 
    Win32FindDataW* find_data
) @cname("FindFirstFileW");

extern fn Bool findClose(Handle find_file) @cname("FindClose");

extern fn Dword getLastError() @cname("GetLastError");

extern fn Bool setFileAttributesW(
    LPCWstr filename,
    Dword attrs
) @cname("SetFileAttributesW");


fn Char16*? utf8to16(String path, Char16[] wpath) 
{
    Char16[] p2 = path.to_utf16(tmem)!;
    defer free(p2);
    
    if (p2.len >= wpath.len-1) return PATH_TOO_LONG~;
    
    wpath[0:p2.len] = p2[0:p2.len];
    wpath[p2.len] = 0;
    return wpath.ptr;
}

fn bool exists(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath) ?? return false;
    
    Dword attrs = getFileAttributesW(name);
    return attrs != INVALID_FILE_ATTRIBUTES;
}

fn long? size(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath)!;
    
    Win32FileAttributeData file_info;
    if (!getFileAttributesExW(name, 0, &file_info)) {
        return errno::get_fault()~;
    }
    
    long size = ((long)file_info.nFileSizeHigh << 32) | (long)file_info.nFileSizeLow;
    return size;
}

fn long? last_modified(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath)!;
    
    Win32FileAttributeData file_info;
    if (!getFileAttributesExW(name, 0, &file_info)) {
        return errno::get_fault()~;
    }
    
    long filetime = ((long)file_info.ftLastWriteTime_high << 32) | (long)file_info.ftLastWriteTime_low;
    return filetime;
}

fn bool is_dir(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath) ?? return false;
    
    Dword attrs = getFileAttributesW(name);
    if (attrs == INVALID_FILE_ATTRIBUTES) return false;
    
    return (attrs & FILE_ATTRIBUTE_DIRECTORY) != 0;
}

fn bool is_file(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath) ?? return false;
    
    Dword attrs = getFileAttributesW(name);
    if (attrs == INVALID_FILE_ATTRIBUTES) return false;
    
    return (attrs & FILE_ATTRIBUTE_DIRECTORY) == 0;
}

fn bool is_link(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath) ?? return false;
    
    Dword attrs = getFileAttributesW(name);
    if (attrs == INVALID_FILE_ATTRIBUTES) return false;
    
    return (attrs & FILE_ATTRIBUTE_REPARSE_POINT) != 0;
}

fn usz? read_link(String path, char[] output) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath)!;
    
    Handle handle = createFileW(
        name, 0, 
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        null, OPEN_EXISTING, FILE_FLAG_OPEN_REPARSE_POINT,
        INVALID_HANDLE_VALUE);
    
    if (handle == INVALID_HANDLE_VALUE) {
        return errno::get_fault()~;
    }
    
    defer closeHandle(handle);
    
    char[16384] buffer;
    Dword bytes_returned;
    
    if (!deviceIoControl(handle, FSCTL_GET_REPARSE_POINT, null, 0,
        &buffer, 16384, &bytes_returned, null)) {
        return errno::get_fault()~;
    }
    
    ReparseDataBuffer* reparse = (ReparseDataBuffer*)&buffer;
    
    if ((reparse.reparseTag != IO_REPARSE_TAG_SYMLINK) && 
        (reparse.reparseTag != IO_REPARSE_TAG_MOUNT_POINT)) {
        return GENERAL_ERR~;
    }

    Char16* target = (Char16*)&reparse.pathBuffer[reparse.printNameOffset / 2];
    usz len = reparse.printNameLength / 2;
    
    String s = string::from_utf16(tmem, target[0:len])!;
    defer s.free();
    
    if (s.len >= output.len) return PATH_TOO_LONG~;
    
    output[0:s.len] = s[0:s.len];
    output[s.len] = 0;
    
    return (usz)s.len;
}

fn bool is_readable(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath) ?? return false;
    
    Handle handle = createFileW(
        name, GENERIC_READ,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        null, OPEN_EXISTING, 0, INVALID_HANDLE_VALUE);
    
    if (handle == INVALID_HANDLE_VALUE) return false;
    
    defer closeHandle(handle);
    return true;
}

fn bool is_writeable(String path) 
{
    Char16[260] wpath;
    Char16* name = utf8to16(path, &wpath) ?? return false;

    Handle handle = createFileW(
        name, GENERIC_WRITE,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        null, OPEN_EXISTING, 0, INVALID_HANDLE_VALUE);
    
    if (handle == INVALID_HANDLE_VALUE) return false;
    
    defer closeHandle(handle);
    return true;
}

fn bool is_executable(String path) 
{
    if (!file_exists(path)) return false;
    if (is_dir(path)) return false;
    
    usz idx = path.rindex_of_char('.') ?? return false;
    
    String ext = path[idx..];
    String ext_lower = ext.to_lower_tcopy();
    defer ext_lower.free(tmem);
    
    switch (ext_lower) {
        case ".exe":
        case ".bat":
        case ".cmd":
        case ".com":
        case ".msi":
        case ".ps1":
        case ".vbs":
            return true;
        default:
            return false;
    }
}

Mode_t win_umask_value = 0o022;
fn Mode_t umask(Mode_t mask)
{
    Mode_t old = win_umask_value;
    win_umask_value = mask & 0o777;
    return old;
}

fn void? change_mode(String file, Mode_t mode) @maydiscard
{
    Char16[260] wpath;
    Char16* name = utf8to16(file, &wpath)!;

    Dword attrs = getFileAttributesW(name);
    if (attrs == INVALID_FILE_ATTRIBUTES) {
        return errno::get_fault()~;
    }
    
    if (mode & S_IWUSR) {
        attrs &= ~FILE_ATTRIBUTE_READONLY;
    } else {
        attrs |= FILE_ATTRIBUTE_READONLY;
    }
    
    if (!setFileAttributesW(name, attrs)) {
        return errno::get_fault()~;
    }
}
