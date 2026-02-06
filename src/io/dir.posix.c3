// dir.posix.c3
//
// This module provides directory operations for Posix systems.
// get_cur_dir() change_dir() make_dir() remove_dir()
// list_dir() is_dir() is_file()

module ext::io::dir @if(!env::WIN32); // Posix

import errno;
import dirent;
import ext::io::stat;

const int MAX_PATH = 1024;

// Additional POSIX functions not in dirent module
extern fn char* getcwd(char* buf, CULong size);
extern fn CInt chdir(char* path);
extern fn CInt mkdir(char* path, CUInt mode);
extern fn CInt rmdir(char* path);


fn char*? path_to_cstr(String path, char[] buffer)
{
    if (path.len+1 >= buffer.len) return errno::E_ARG_TOO_BIG~;
    buffer[0:path.len] = path[0:path.len];
    buffer[path.len] = 0;
    return buffer.ptr;
}

<*
  returns String representation of buf
*>
fn String? get_cur_dir(char[] buf)
{
    // on success, result == buf.ptr
    char* result = getcwd(buf.ptr, buf.len);
    
    if (result == null) {
        return errno::get_fault()~;
    }
    
    return result.str_view();
}

fn void? change_dir(String path) @maydiscard
{
    if (path.len == 0) return errno::E_INVALID~;
    char[MAX_PATH] p2;
    char* zpath = path_to_cstr(path, &p2)!;
    
    if (chdir(zpath) != 0) {
        return errno::get_fault()~;
    }
}

fn void? make_dir(String path, bool recursive = false, CUInt mode = 0o755) @maydiscard
{
    if (path.len == 0) return errno::E_INVALID~;
    char[MAX_PATH] p2;
    char* zpath = path_to_cstr(path, &p2)!;
    
    if (!recursive) {
        if (mkdir(zpath, mode) != 0) {
            return errno::get_fault()~;
        }
        return;
    }
    
    assert(path.len+1 <= MAX_PATH);
    
    // Recursive: create parent directories
    char[MAX_PATH] temp;
    temp[0:path.len] = path[0:path.len];
    temp[path.len] = 0;
    
    // Skip leading slashes
    usz start = 0;
    while (start < path.len && temp[start] == '/') {
        start++;
    }
    if (start >= path.len) {
        // Path is all slashes or empty after skipping leading slashes
        return;  // Already at root or nothing to create
    }
    // Create each component
    for (usz i = start; i <= path.len; i++) 
    {
        // Process at '/' or end of string
        if (i == path.len || temp[i] == '/') {
            // Skip consecutive slashes
            if (i > 0 && temp[i-1] == '/') continue;
            
            // Temporarily null-terminate
            char saved = temp[i];
            temp[i] = 0;
            
            // Try to create directory (ignore EEXIST)
            if (mkdir(temp.ptr, mode) != 0) {
                if (errno::errno() != errno::EEXIST) {
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
    char[MAX_PATH] p2;
    char* zpath = path_to_cstr(path, &p2)!;
    
    if (rmdir(zpath) != 0) {
        return errno::get_fault()~;
    }
}

<*
  returned List{String} must be free'd properly
*>
fn List{String}? list_dir(Allocator allocx, String path)
{
    char[MAX_PATH] p2;
    char* zpath = path_to_cstr(path, &p2)!;
    
    dirent::Dir* dir = dirent::opendir(zpath);
    if (dir == null) {
        return errno::get_fault()~;
    }
    defer dirent::closedir(dir);
    
    // Use a dynamic list
    List{String} entries;
    entries.init(allocx);
    defer (catch err) {
        foreach (e : entries) { e.free(); }
        entries.free();
    }
    
    dirent::DirEnt* entry;
    while (result = dirent::readdir(dir)) {
        // Skip "." and ".."
        char* name = (char*)&entry.d_name[0];
        String name_str = ((ZString)name).str_view();
        if (name_str == "." || name_str == "..") continue;
        
        // Copy the name and add to list
        String name_copy = name_str.copy(allocx);
        entries.push(name_copy);
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
