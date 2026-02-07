// file.posix.c3

module ext::io::file @if(!env::WIN32);

import errno;
import stdio;
import ext::io::stat;

typedef FFile = inline CFile;

fn char*? scopy(char[] buf, String str) @inline
{
    if (str.len == 0) return errno::E_INVALID~;
    if (str.len > buf.len+1) return errno::E_ARG_TOO_BIG~;
    usz len = (str.len < buf.len-1) ? str.len: buf.len-1;
    buf[0:len] = str[0:len];
    buf[len] = 0;
    return buf.ptr;
}

fn FFile? fopen(String fname, String fmode) 
{
    char[256] namebuf;
    char* name = scopy(&namebuf, fname)!;
    
    char[16] modebuf;
    char* mode = scopy(&modebuf, fmode)!;
    
    FFile fp = (FFile)stdio::fopen(name, mode);
    if (fp == null) return errno::get_fault()~;
    
    return fp;
}

fn usz? FFile.fread(&self, char[] buf)
{
    usz n = stdio::fread(buf.ptr, 1, buf.len, self);
    if (stdio::ferror(self)) return errno::get_fault()~;
    if (n == 0 && stdio::feof(self)) return errno::EOF~;
    return n;
}

fn char[]? read(Allocator allocx, String file)
{
    long n = size(file)!;

    char[] buf = allocator::alloc_array(allocx, char, n);
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
    assert(n == i);
    return buf;
}

fn usz? FFile.freadline(&self, char[] buf)
{
    usz idx = 0;
    while (idx < buf.len - 1) {
        ichar c = stdio::fgetc(self);
        if (c == stdio::EOF) {
            if (stdio::ferror(self)) return errno::get_fault()~;
            if (idx == 0) return errno::EOF~;
            break;
        }
        buf[idx++] = (char)c;
        if (c == '\n') break;
    }
    buf[idx] = 0;
    return idx;
}

fn usz? FFile.fwrite(&self, char[] buf)
{
    usz n = stdio::fwrite(buf.ptr, 1, buf.len, self);
    if (stdio::ferror(self)) return errno::get_fault()~;
    return n;
}

fn void FFile.fclose(&self)
{
    stdio::fclose(self);
}

fn void FFile.fflush(&self)
{
    stdio::fflush(self);
}

fn usz? FFile.fprintf(&self, String fmt, args...)
{
    char[2048] fmtbuf;
    char* format = scopy(&fmtbuf, fmt)!;
    
    int n = stdio::fprintf(self, format, args);
    if (n < 0) return errno::get_fault()~;
    return (usz) n;
}

fn void? FFile.fseek(&self, long pos, int whence) @maydiscard
{
    int n = stdio::fseek(self, pos, whence);
    if (n != 0) return errno::get_fault()~;
}

fn long? FFile.ftell(&self)
{
    long n = stdio::ftell(self);
    if (n < 0) return errno::get_fault()~;
    return n;
}

fn void? remove(String fname) @maydiscard
{
    char[256] namebuf;
    char* name = scopy(&namebuf, fname)!;
    int n = stdio::remove(name);
    if (n != 0) return errno::get_fault()~;
}

fn void? rename(String fname, String fname2) @maydiscard
{
    char[256] namebuf;
    char* name = scopy(&namebuf, fname)!;
    
    char[256] namebuf2;
    char* name2 = scopy(&namebuf2, fname2)!;
    int n = stdio::rename(name, name2);
    if (n != 0) return errno::get_fault()~;
}

fn void? copy(String fname, String fname2) @maydiscard
{
    char[] buf = read(mem, fname)!;
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