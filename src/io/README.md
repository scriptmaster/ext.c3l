# ext::io Extended I/O Operations

Cross-platform file/directory operations in C3, filling the gap of missing pieces in the standard library.

## Available Modules

| Module | Description |
|--------|-------------|
| `ext::io::stat` | File stat operations: exists(), size(), is_(file/dir/link), is_(readable/writable/executable), read_link(), last_modified(), change_mode() |
| `ext::io::file` | File operations: fopen(), fclose(), fread(), fwrite(), fprintf(), read(), copy(), rename(), remove(), exists(), size(), last_modified(), is_file(), is_dir(), change_mode() |
| `ext::io::dir` | Directory/folder operations: get_cur_dir(), change_dir(), make_dir(), remove_dir(), rename(), list_dir(), exists(), is_dir(), is_file(), change_mode() |

Back to [ext.c3l](../../README.md) library.

### File Status Operations

Three abstraction for status operations.
* [stat.def.c3](stat.def.c3) : cross-platform definition of `struct Stat`
* [stat.posix.c3](stat.posix.c3) : functions for posix systems.
* [stat.win32.c3](stat.win32.c3) : functions for win32 systems.

Available functions are:

```c3
import ext::io::stat;

bool b = stat::exists(String path);
long? n = stat::size(String path);
long? mtime = stat::last_modified(String path); // missing in std lib
bool b = stat::is_dir(String path);
bool b = stat::is_file(String path);
bool b = stat::is_link(String path); // missing in std lib
bool b = stat::is_readable(String psth); // missing in std lib
bool b = stat::is_writeable(String path); // missing in std lib
bool b = stat::is_executable(String path); // missing in std lib
usz? n = stat::read_link(String path, char[] output); // missing in std lib
Mode_t prev = stat::umask(Mode_t mode) @maydiscard; // missing in std lib
void? stat::change_mode(String path, Mode_t mode) @maydiscard; // missing in std lib
```

### File Operations

Abstraction for file operations.
* [file.posix.c3](file.posix.c3) : functions for posix systems.
* [file.win32.c3](file.win32.c3) : functions for win32 systems.

Available functions are:

```c3
import ext::io::file;

FFile fp = file::fopen(String file, String mode);
usz? n = fp.fread(char[] buf);
usz? n = fp.fwrite(char[] buf);
usz? n = fp.readline(char[] buf);
usz? n = fp.fprintf(String format, args...);
void fp.fflush();
void fp.fclose();
void? fp.fseek(long pos, int whence) maydiscard;
long? pos = fp.ftell();

char[]? buf = file::read(Allocator allocx, String file); // read whole file at once, must free(buf) later
void? file::remove(String file) @maydiscard;
void? file::rename(String file, String target) @maydiscard;
void? file::copy(String file, String target) @maydiscard;

bool b = file::exists(String file);
long? n = file::size(String file);
long? mtime = file::last_modified(String file); // missing in std lib
bool b = file::is_dir(String file);
bool b = file::is_file(String file);
bool b = file::is_link(String file); // missing in std lib
bool b = file::is_readable(String file); // missing in std lib
bool b = file::is_writeable(String file); // missing in std lib
bool b = file::is_executable(String file); // missing in std lib
usz? n = file::read_link(String file, char[] output); // missing in std lib
void? file::change_mode(String file, Mode_t mode) @maydiscard; // missing in std lib
```

### Directory/folder Operations

Abstraction for dir operations.
* [dir.def.c3](dir.def.c3) : cross-platform definition of `struct Dir/DirEnt`
* [dir.posix.c3](dir.posix.c3) : functions for posix systems.
* [dir.win32.c3](dir.win32.c3) : functions for win32 systems.

Available functions are:

```c3
import ext::io::dir;

String? cwd = dir::get_cur_dir(char[] buf); // returns String representation of buf
void? dir::change_dir(String path) @maydiscard;
void? dir::make_dir(String path, bool recursive = false, CUInt mode = 0o755) @maydiscard;
void? dir::remove_dir(String path) @maydiscard;
List{String}? dir::list_dir(Allocator allocx, String path); // returned List{String} must be free'd properly

bool b = dir::exists(String path);
long? mtime = dir::last_modified(String path); // missing in std lib
bool b = dir::is_dir(String path);
bool b = dir::is_file(String path);
bool b = dir::is_link(String path); // missing in std lib
bool b = dir::is_readable(String path); // missing in std lib
bool b = dir::is_writeable(String path); // missing in std lib
usz? n = dir::read_link(String path, char[] output); // missing in std lib
void? dir::change_mode(String path, Mode_t mode) @maydiscard; // missing in std lib
```

### Example

```c3
import ext::io::stat;
import std::io;

fn void check_file(String path) 
{
    if (stat::exists(path)) {
        io::printfn("File exists: %s", path);
        
        if (stat::is_dir(path)) {
            io::printfn("  Type: Directory");
        } else if (stat::is_file(path)) {
            io::printfn("  Type: File");
            
            ulong? size = stat::size(path);
            if (catch size) {
                io::printn("  Cannot get file size");
            } else {
                io::printfn("  Size: %d bytes", size);
            }
        }
        
        io::printfn("  Readable: %s", stat::is_readable(path) ? "yes" : "no");
        io::printfn("  Writable: %s", stat::is_writeable(path) ? "yes" : "no");
        io::printfn("  Executable: %s", stat::is_executable(path) ? "yes" : "no");
    }
}
```

