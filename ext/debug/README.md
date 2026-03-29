# ext::debug - debugging macros in ext lib

`ext::debug` is for giving debugging macros within a library.

# Available module

| Module | Description |
|--------|-------------|
| `ext::debug` | Debugging macros: warn(), @assert() |

This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

# API functions

```c3 
import ext::debug;

// @builtin, so you don't have to specify `debug::` prefix
void warn(format_string, args...) @builtin; // io::printfn() with file name and line number

void @assert(expr, "assert message") @builtin; // if expr==false, print message with file/linumber and abort.
```


This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

