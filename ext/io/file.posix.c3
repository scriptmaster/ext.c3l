// file.posix.c3

module ext::io::cfile @if(!env::WIN32);

import errno;
import stdio;
import ext::io::stat;

struct File 
{
    CFile fp;
}

fn char*? scopy(char[] buf, String str) @inline
{
    if (str.len == 0) return errno::E_INVALID~;
    if (str.len > buf.len+1) return errno::E_ARG_TOO_BIG~;
    usz len = (str.len < buf.len-1) ? str.len: buf.len-1;
    buf[0:len] = str[0:len];
    buf[len] = 0;
    return buf.ptr;
}

fn File? open(String fname, String fmode) 
{
    char[256] namebuf;
    char* name = scopy(&namebuf, fname)!;
    
    char[16] modebuf;
    char* mode = scopy(&modebuf, fmode)!;
    
    File file;
    file.fp = (CFile)stdio::fopen(name, mode);
    if (file.fp == null) return errno::get_fault()~;
    
    return file;
}

fn usz? File.read(&self, char[] buf) @dynamic
{
    usz n = stdio::fread(buf.ptr, 1, buf.len, self.fp);
    if (stdio::ferror(self.fp)) return errno::get_fault()~;
    if (n == 0 && stdio::feof(self.fp)) return errno::EOF~;
    return n;
}

fn usz? File.readline(&self, char[] buf)
{
    usz idx = 0;
    while (idx < buf.len - 1) {
        ichar c = stdio::fgetc(self.fp);
        if (c == stdio::EOF) {
            if (stdio::ferror(self.fp)) return errno::get_fault()~;
            if (idx == 0) return errno::EOF~;
            break;
        }
        buf[idx++] = (char)c;
        if (c == '\n') break;
    }
    buf[idx] = 0;
    return idx;
}

fn char? File.read_byte(&self) @dynamic
{
	int c = stdio::fgetc(self.fp);
    if (stdio::ferror(self.fp)) return errno::get_fault()~;
    if (stdio::feof(self.fp)) return errno::EOF~;
	return (char)c;
}

fn usz? File.write(&self, char[] buf) @dynamic
{
    usz n = stdio::fwrite(buf.ptr, 1, buf.len, self.fp);
    if (stdio::ferror(self.fp)) return errno::get_fault()~;
    return n;
}

fn void? File.write_byte(&self, char c) @dynamic
{
	int r = stdio::fputc(c, self.fp);
	if (stdio::ferror(self.fp)) return errno::get_fault()~;
    return;
}

fn void File.close(&self)
{
    stdio::fclose(self.fp);
}

fn void File.flush(&self)
{
    stdio::fflush(self.fp);
}

fn usz? File.printf(&self, String fmt, args...)
{
    DString str = dstring::temp();
    defer str.free();
    str.appendf(fmt, ...args);

    usz? n = self.write(str.str_view())!; 
    return (usz) n;
}

fn usz? File.seek(&self, long pos, int whence) @maydiscard
{
    int n = stdio::fseek(self.fp, pos, whence);
    if (n != 0) return errno::get_fault()~;
    return self.tell();
}

fn long? File.tell(&self)
{
    long n = stdio::ftell(self.fp);
    if (n < 0) return errno::get_fault()~;
    return n;
}

fn bool File.eof(&self) 
{
    return stdio::feof(self.fp) != 0;
}

fn char[]? load(Allocator allocx, String file)
{
    long n = size(file)!;

    char[] buf = allocator::alloc_array(allocx, char, n);
    defer (catch err) { free(buf); }
    
    File fp = open(file, "r")!;
    defer fp.close();
    long i = 0;
    while (i < n) {
        usz? r = fp.read(buf[i..n-1]);
        if (catch err = r) {
            if (err == errno::EOF) break;
            return err~;
        }
        i += r;
    }
    assert(n == i);
    return buf;
}

fn void? save(String filename, char[] data)
{
	File file = open(filename, "wb")!;
	defer (void)file.close();
	while (data.len)
	{
		usz written = file.write(data)!;
		data = data[written..];
	}
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
    char[] buf = load(mem, fname)!;
    defer free(buf);
    
    File fp = open(fname2, "w")!;
    defer fp.close();
    
    long i = 0;
    while (i < buf.len) {
        usz r = fp.write(buf[i..buf.len-1])!;
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