# ext::mem - mem allocation macros in ext lib

`ext::mem` is for giving memory allocation macros within a library.

# Available module

| Module | Description |
|--------|-------------|
| `ext::mem` | Allocation macros: set_allocator(), mem_alloc(), mem_malloc(), mem_alloc_array(), mem_copy(), mem_copy_str(), mem_free() |

This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

# API functions

```c3 
import ext::mem;

void mem::set_allocator(Allocator alloc); // this is done only once in a lifetime of a program
// if missing, first allocation sets `mem` as the default allocator

// @builtin, so you don't have to specify `mem::` prefix
void* p = mem_malloc(size) @builtin;
Type* p = mem_alloc(Type) @builtin;
Type[] p = mem_alloc_array(Type, number) @builtin;
char[] p = mem_copy(char[] buf) @builtin;
String p = mem_copy_str(String str) @builtin;
void mem_free(void* p) @builtin;
```


This is a part of extended C3 library.
Back to [ext.c3l](../../README.md) library.

