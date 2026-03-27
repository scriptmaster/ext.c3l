// aiofiles.tempfile.c3

module ext::aiofiles::tempfile;

import c::stdlib;
import c::stdio;
import c::unistd;
import c::processthreadapi;
import std::time;
import std::collections::list;
import ext::debug;
import ext::mem;
import ext::io::dir;
import ext::io::cfile;
import ext::aiofiles;

struct AioTempFile {
    inline AioFile file;
    String name;
    String fullpath;
}

fn String sys_temp_dir() @private
{
    $if env::WIN32:
        char* tmp = stdlib::getenv("TMPDIR");
        if (tmp == null) tmp = stdlib::getenv("TEMP");
        char[256] buf;
        int n = stdio::snprintf(&buf[0], buf.len, "%s\\_aio_", tmp);
        dir::make_dir((String)buf[0:(usz)n], true);
        return ((ZString)tmp).str_view();
    $else
        dir::make_dir("/tmp/_aio_");
        return "/tmp";
    $endif
}

fn String get_temp_name(char[] buf) @private
{
    static int count = 0;
    ulong now = (ulong)time::now();

  $if env::WIN32:
    uint pid = (uint)processthreadapi::getCurrentProcessId();
    uint tid = (uint)processthreadapi::getCurrentThreadId();
  $else
    uint pid = (uint)unistd::getpid();
    uint tid = (uint)unistd::gettid();
  $endif
 
    int n = stdio::snprintf(buf.ptr, buf.len, "%x.%x.%x.%x", now, pid, tid, count++);
    return (String)buf[0:n];
}

fn AioTempFile? temporaryFile()
{
    char[64] fbuf;
    String fname = get_temp_name(&fbuf);
    String tdir = sys_temp_dir();
    
    char[1024] pbuf;
    int n = stdio::snprintf(&pbuf[0], pbuf.len, "%s/_aio_/%s", tdir.ptr, fname.ptr);
    String fullpath = (String)pbuf[0:n];
    
    AioFile file = aiofiles::open(fullpath, "w+")!;
    
    return { .file = file, .name = fname.copy(mem), .fullpath = fullpath.copy(mem) };
}

fn void AioTempFile.close(&self)
{
    self.file.close();
    self.name.free(mem);
    cfile::remove(self.fullpath);
    self.fullpath.free(mem);
}

struct AioTempDir {
    String fullpath;
}

fn AioTempDir temporayDirectory()
{
    char[64] fbuf;
    String fname = get_temp_name(&fbuf);
    String tdir = sys_temp_dir();
    
    char[1024] pbuf;
    int n = stdio::snprintf(&pbuf[0], pbuf.len, "%s/_aio_/%s", tdir.ptr, fname.ptr);
    String fullpath = (String)pbuf[0:n];

    dir::make_dir(fullpath, true);
    
    return { .fullpath = fullpath.copy(mem) };
}

fn void? clean_dir(String dir) @maydiscard
{
    List{String}? files = dir::list_dir(mem, dir);
    if (catch err = files) {
        return err~;
    }
    defer files.free();
    foreach (file: files) {
        char[1024] pbuf;
        int n = stdio::snprintf(&pbuf[0], pbuf.len, "%s/%s", dir.ptr, file.ptr);
        String fullpath = (String)pbuf[0:n];
        
        if (dir::is_file(fullpath)) {
            cfile::remove(fullpath);
        }
        
        if (dir::is_link(fullpath)) {
            cfile::remove(fullpath);
        }
        
        if (dir::is_dir(fullpath)) {
            clean_dir(fullpath);
        }
    }
    dir::remove_dir(dir);
}

fn void AioTempDir.close(&self)
{
    clean_dir(self.fullpath);
    self.fullpath.free(mem);
}