
// file.win32.c3

module ext::io::file @if(env::WIN32);

import std::io;
import windows;
import errno;
import ext::io::stat;

typedef FFile = windows::Handle;

fn Char16*? utf8to16(String path, Char16[] wpath) 
{
    if (path.le  == 0) return errno::E_INVALID~;
    Char16[] p2 = path.to_utf16(mem)!;
    defer free(p2);
    
    if (p2.len >= wpath.len-1) return errno::E_ARG_TOO_BIG~;
    
    wpath[0:p2.len] = p2[0:p2.len];
    wpath[p2.len] = 0;
    return wpath.ptr;
}

fn FFile? fopen(String fname, String fmode) 
{
    Char16[512] namebuf;
    Char16* name = utf8to16(fname, &namebuf)!;

    // Parse mode string
    uint access = 0;
    uint creation = windows::OPEN_EXISTING;
    
    // Simple mode parsing (r, w, a, r+, w+, a+)
    if (fmode.len == 0) return errno::E_INVALID~;
    if (fmode[0] == 'r') {
        access = windows::GENERIC_READ;
        if (fmode.len > 1 && fmode[1] == '+') {
            access |= windows::GENERIC_WRITE;
        }
    } else if (fmode[0] == 'w') {
        access = windows::GENERIC_WRITE;
        creation = windows::CREATE_ALWAYS;
        if (fmode.len > 1 && fmode[1] == '+') {
            access |= windows::GENERIC_READ;
        }
    } else if (fmode[0] == 'a') {
        access = windows::GENERIC_WRITE;
        creation = windows::OPEN_ALWAYS;
        if (fmode.len > 1 && fmode[1] == '+') {
            access |= windows::GENERIC_READ;
        }
    } else {
        return errno::E_INVALID~;
    }
    
    FFile fp = windows::createFileW(name, access, windows::FILE_SHARE_READ | windows::FILE_SHARE_WRITE, null, creation, windows::FILE_ATTRIBUTE_NORMAL, null);
    if (fp == windows::INVALID_HANDLE_VALUE) return errno::get_fault()~;
    
    // For append mode, seek to end
    if (fmode[0] == 'a') {
        windows::setFilePointerEx(fp, 0, null, windows::FILE_END);
    }
    
    return fp;
}

fn usz? FFile.fread(&self, char[] buf)
{
    uint bytes_read;
    bool success = windows::readFile(self, buf.ptr, (uint)buf.len, &bytes_read, null);
    if (!success) return errno::get_fault()~;
    if (bytes_read == 0) return errno::EOF~;
    return (usz)bytes_read;
}

fn char[]? read(Allocator allocx, String file)
{
    long n = size(file)!;
    
    char[] buf = allocator::new_array(allocx, char, n);
    defer (catch err) { free(buf); }
    
    FFile fp = fopen(file, "r")!;
    defer fp.fclose();
    long i = 0;
    while (i < n) {
        usz? r = fp.fread(buf[i..n-1]);
        if (catch err = r) {
            if (err == errno::EOF) break;
            return err~;
        }
        i += r;
    }
    assert(i == n);
    return buf;
}

fn usz? FFile.freadline(&self, char[] buf)
{
    usz idx = 0;
    while (idx < buf.len - 1) {
        char c;
        uint bytes_read;
        bool success = windows::readFile(self, &c, 1, &bytes_read, null);
        if (!success) return errno::get_fault()~;
        if (bytes_read == 0) {
            if (idx == 0) return errno::EOF~;
            break;
        }
        buf[idx++] = c;
        if (c == '\n') break;
    }
    buf[idx] = 0;
    return idx;
}

fn usz? FFile.fwrite(&self, char[] buf)
{
    uint bytes_written;
    bool success = windows::writeFile(self, buf.ptr, (uint)buf.len, &bytes_written, null);
    if (!success) return errno::get_fault()~;
    return (usz)bytes_written;
}

fn void FFile.fclose(&self)
{
    windows::closeHandle(self);
}

fn void FFile.fflush(&self)
{
    windows::flushFileBuffers(self);
}

fn usz? FFile.fprintf(&self, String fmt, args...) => @pool()
{
    // Format to temporary buffer
    DString str = dstring::temp_new();
    str.appendf(fmt, ...args);
    
    // Write formatted string
    uint bytes_written;
    bool success = windows::writeFile(self, str.str_view().ptr, (uint)str.len(), &bytes_written, null);
    if (!success) return errno::get_fault()~;
    return (usz)bytes_written;
}

fn void? FFile.fseek(&self, long pos, int whence) @maydiscard
{
    uint move_method;
    switch (whence) {
        case 0: move_method = windows::FILE_BEGIN;
        case 1: move_method = windows::FILE_CURRENT;
        case 2: move_method = windows::FILE_END;
        default: return FSEEK_ERR~;
    }
    
    bool ok = windows::setFilePointerEx(self, pos, null, move_method);
    if (! ok) return errno::get_fault()~;
}

fn long? FFile.ftell(&self)
{
    long pos;
    bool success = windows::setFilePointerEx(self, 0, &pos, windows::FILE_CURRENT);
    if (!success) return errno::get_fault()~;
    return pos;
}

fn void? remove(String fname) @maydiscard
{
    Char16[512] namebuf;
    Char16* name = utf8to16(fname, &namebuf)!;

    bool success = windows::deleteFileW(name);
    if (!success) return errno::get_fault()~;
}

fn void? rename(String fname, String fname2) @maydiscard
{
    Char16[512] namebuf;
    Char16* name = utf8to16(fname, &namebuf)!;

    Char16[512] namebuf2;
    Char16* name2 = utf8to16(fname2, &namebuf2)!;
    
    bool success = windows::moveFileW(name, name2);
    if (!success) return errno::get_fault()~;
}

fn void? copy(String fname, String fname2) @maydiscard
{
    char[] buf = read(tmem, fname)!;
    defer free(buf);
    
    FFile fp = fopen(fname2, "w")!;
    defer fp.fclose();
    
    long i = 0;
    while (i < buf.len) {
        usz r = fp.fwrite(buf[i..buf.len-1])!;
        i += r;
    }
}

fn long? size(String file) => stat::size(file);

fn bool exists(String file) => stat::exists(file);

fn long? last_modified(String file) => stat::last_modified(file);

fn bool is_dir(String file) => stat::is_dir(file);
fn bool is_file(String file) => stat::is_file(file);
fn bool is_link(String file) => stat::is_link(file);

fn bool is_readable(String file) => stat::is_readable(file);
fn bool is_writeable(String file) => stat::is_writeable(file);
fn bool is_executable(String file) => stat::is_executable(file);

fn usz? read_link(String link, char[] output) => stat::read_link(link, output);
fn void? change_mode(String file, Mode_t mode) @maydiscard => stat::change_mode(file, mode);