// dir.win32.c3
//
// This module provides directory operations for Windows systems.
// get_cur_dir() change_dir() make_dir() remove_dir()
// list_dir() is_dir() is_file()

module ext::io::dir @if(env::WIN32);

import errno;
import std::io;
import ext::io::stat;

const int MAX_PATH = 1024;

extern fn CULong getCurrentDirectoryW(CULong nBufferLength, Char16* lpBuffer) @cname("GetCurrentDirectoryW");
extern fn CBool setCurrentDirectoryW(WString lpPathName) @cname("SetCurrentDirectoryW");
extern fn CBool createDirectoryW(WString lpPathName, void* lpSecurityAttributes) @cname("CreateDirectoryW");
extern fn CBool removeDirectoryW(WString lpPathName) @cname("RemoveDirectoryW");

// findFile structures and functions
struct Win32FindDataW
{
    CULong dwFileAttributes;
    CULong ftCreationTime_low;
    CULong ftCreationTime_high;
    CULong ftLastAccessTime_low;
    CULong ftLastAccessTime_high;
    CULong ftLastWriteTime_low;
    CULong ftLastWriteTime_high;
    CULong nFileSizeHigh;
    CULong nFileSizeLow;
    CULong dwReserved0;
    CULong dwReserved1;
    Char16[260] cFileName;
    Char16[14] cAlternateFileName;
}

const CULong FILE_ATTRIBUTE_DIRECTORY = 0x10;
const CULong INVALID_HANDLE_VALUE = 0xFFFFFFFF;

extern fn void* findFirstFileW(WString lpFileName, Win32FindDataW* lpfindFileData) @cname("FindFirstFileW");
extern fn CBool findNextFileW(void* hfindFile, Win32FindDataW* lpfindFileData) @cname("FindNextFileW");
extern fn CBool findClose(void* hfindFile) @cname("FindClose");

fn Char16*? utf8to16(String path, Char16[] wpath) 
{
    if (path.len == 0) return errno::E_INVALID?;

    Char16[] p2 = path.to_utf16(tmem)!;
    defer free(p2);
    
    if (p2.len >= wpath.len-1) return errno::E_ARG_TOO_BIG~;
    
    wpath[0:p2.len] = p2[0:p2.len];
    wpath[p2.len] = 0;
    return wpath.ptr;
}

fn String? u16to8(Char16[] from, char[] buf)
{
    String s = string::from_utf16(tmem, from)!;
    defer s.free();
    
    if (s.len >= buf.len+1) return errno::E_ARG_TOO_BIG~;
    
    buf[0:s.len] = s[0:s.len];
    buf[s.len] = 0;
    
    return (String)buf[0:s.len];
}


<*
  returns String representation of buf
*>
fn String? get_cur_dir(char[] buf)
{
    Char16[MAX_PATH] wbuf;
    CULong len = getCurrentDirectoryW(wbuf.len, wbuf.ptr);
    if (len == 0) {
        return errno::get_fault()~;
    }
    
    if (len >= wbuf.len) {
        return errno::E_ARG_TOO_BIG~;
    }
    
    return u16to8(wbuf[0:len], buf)!;
}

fn void? change_dir(String path) @maydiscard
{
    Char16[MAX_PATH] p2;
    Char16* wpath = utf8to16(path, &p2)!;
    
    if (!setCurrentDirectoryW(wpath)) {
        return errno::get_fault()~;
    }
}

fn void? make_dir(String path, bool recursive = false, CUInt mode = 0o755) @maydiscard
{
    Char16[MAX_PATH] p2;
    Char16* wpath = utf8to16(path, &p2)!;
    
    if (!recursive) {
        if (!createDirectoryW(wpath, null)) {
            if (errno::errno() != errno::EEXISTS) { // ERROR_ALREADY_EXISTS
                return errno::get_fault()~;
            }
        }
        return;
    }
    
    assert(path.len+1 <= MAX_PATH);
    
    // Recursive: create parent directories
    Char16[MAX_PATH] temp;
    for (usz i = 0; i < path.len; i++) {
        temp[i] = (Char16)path[i];
    }
    temp[path.len] = 0;
    
    // Skip leading path components (drive letter, UNC paths)
    usz start = 0;
    
    // Handle drive letter (C:\)
    if (path.len >= 2 && temp[1] == ':') {
        start = 2;
        if (start < path.len && (temp[start] == '\\' || temp[start] == '/')) {
            start++;
        }
    }
    // Handle UNC paths (\\server\share)
    else if (path.len >= 2 && (temp[0] == '\\' || temp[0] == '/') && (temp[1] == '\\' || temp[1] == '/')) {
        start = 2;
        // Skip server name
        while (start < path.len && temp[start] != '\\' && temp[start] != '/') {
            start++;
        }
        if (start < path.len) start++; // Skip separator
        // Skip share name
        while (start < path.len && temp[start] != '\\' && temp[start] != '/') {
            start++;
        }
        if (start < path.len) start++; // Skip separator
    }
    // Handle rooted path (\Windows)
    else if (path.len >= 1 && (temp[0] == '\\' || temp[0] == '/')) {
        start = 1;
    }
    
    if (start >= path.len) {
        return; // Nothing to create
    }
    
    // create each component
    for (usz i = start; i <= path.len; i++) 
    {
        // Process at '\' or '/' or end of string
        if (i == path.len || temp[i] == '\\' || temp[i] == '/') {
            // Skip consecutive slashes
            if (i > 0 && (temp[i-1] == '\\' || temp[i-1] == '/')) continue;
            
            // Temporarily null-terminate
            Char16 saved = temp[i];
            temp[i] = 0;
            
            // Try to create directory (ignore ERROR_ALREADY_EXISTS)
            if (!createDirectoryW((WString)&temp[0], null)) {
                if (errno::errno() != errno::ERROR_ALREADY_EXISTS) { // ERROR_ALREADY_EXISTS
                    return errno::get_fault()~;
                }
            }
            
            // Restore character
            temp[i] = saved;
        }
    }
}

fn void? remove_dir(String path) @maydiscard
{
    Char16[MAX_PATH] p2;
    Char16* wpath = utf8to16(path, &p2)!;
    
    if (!removeDirectoryW(wpath)) {
        return errno::get_fault()~;
    }
}

<*
returned List{String} must be freed properly
*>
fn List{String}? list_dir(Allocator allocx, String path)
{
    if (path.len+2 >= MAX_PATH) return errno::E_ARG_TOO_BIG~;

    // create search pattern (path\*)
    
    char[MAX_PATH] p1;
    p1[0:path.len] = path[0:path.len];
    usz pos = path.len;
    if (p1[pos-1] != '/' and p1[pos-1] != '\\') {
        p1[pos++] = '\\';
    }
    p1[pos] = '*';
    
    Char16[MAX_PATH + 2] p2;
    Char16* spath = utf8to16(p1[0..pos], &p2)!;

    Win32FindDataW find_data;
    void* handle = findFirstFileW(spath, &find_data);
    
    if (handle == (void*)INVALID_HANDLE_VALUE) {
        return errno::get_fault()~;
    }
    defer findClose(handle);
    
    // Use a dynamic list
    List{String} entries;
    entries.init(allocx);
    defer (catch err) {
        foreach (e : entries) {
            e.free();
        }
        entries.free();
    }
    
    while (true) {
        // Skip "." and ".."
        Char16* wname = &find_data.cFileName[0];

        char[MAX_PATH] name_buf;
        String name_str = u16to8(wname, &name_buf)!;
        
        if (name_str != "." && name_str != "..") {
            String name_copy = name_str.copy(allocx);
            entries.push(name_copy);
        }
        
        // get next file
        if (!findNextFileW(handle, &find_data)) {
            if (errno::errno() == errno::NO_MORE_FILES) { // ERROR_NO_MORE_FILES
                break;
            }
            return errno::get_fault()~;
        }
    }
    
    return entries;
}

fn bool exists(String path) => stat::exists(path);

fn long? last_modified(String path) => stat::last_modified(path);

fn bool is_dir(String path) => stat::is_dir(path);
fn bool is_file(String path) => stat::is_file(path);
fn bool is_link(String path) => stat::is_link(path);

fn bool is_readable(String path) => stat::is_readable(path);
fn bool is_writeable(String path) => stat::is_writeable(path);

fn usz? read_link(String link, char[] output) => stat::read_link(link, output);

fn void? change_mode(String path, Mode_t mode) @maydiscard => stat::change_mode(path, mode);
