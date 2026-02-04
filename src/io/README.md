# ext::io Extended I/O Operations

## Available Modules

### Cross-Platform Utilities

| Module | Description |
|--------|-------------|
| `ext::io::stat` | File system utilities: file existence, size, type checking (file/dir/link), permissions (readable/writable/executable), symbolic link resolution, and modification time queries |

### Cross-Platform File Status Operations

Three abstraction files for file operations.
* `stat.def.c3` : cross-platform definition of `struct Stat`
* `stat.posix.c3` : functions for posix systems.
* `stat.win32.c3` : functions for win32 systems.

Available functions are:
* `bool file_exists(String file)`
* `long? file_size(String file)`
* `long? last_modified(String file)` missing in std lib
* `bool is_dir(String path)`
* `bool is_file(String path)`
* `bool is_link(String path)` missing in std lib
* `bool is_readable(String file)` missing in std lib
* `bool is_writeable(String path)` missing in std lib
* `bool is_executable(String file)` missing in std lib
* `usz? read_link(String path, char[] output)` missing in std lib

```c3
import ext::io::stat;
import std::io;

fn void check_file(String path) 
{
    if (stat::file_exists(path)) {
        io::printfn("File exists: %s", path);
        
        if (stat::is_dir(path)) {
            io::printfn("  Type: Directory");
        } else if (stat::is_file(path)) {
            io::printfn("  Type: File");
            
            ulong? size = stat::file_size(path);
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

