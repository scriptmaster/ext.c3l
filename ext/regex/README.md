# C3 RegEx Library - User Guide

## Overview
This document explains how to use the RegEx library for the C3 programming language. 
The library is based on SLRE (Super Light Regular Expression).

## Available Modules

| Module | Description |
|--------|-------------|
| `ext::regex` | RegEx operations: new_compile(), match(), group(), free(), replace(), split(), reg_match(), reg_replace(), reg_split();|
| `slre` | SLRE operations: compile(), match(), reg_match(), reg_replace() |

Back to [ext.c3l](../../README.md) library.

### API Functions

```c3
import ext::regex;

Allocator allocx;

RegEx*? reg = regex::new_compile(allocx, String expr, bool ignore_case=false);
void? reg.free();
int? n = reg.match(String str, int* start = null, int* len = null);
RegMatch? g = reg.group(int idx); // () captured substring
io::printfn("%s", g.s);
String? s2 = reg.replace(allocx, String str, String sub, int n = 0); // must free s2
List{String}? lst = reg.split(allocx, String str, int n = 0); // must free lst

bool? b = regex::reg_match(String expr, String str, int* start = null, int* end = null, bool ignore_case = false);
String? s2 = regex::reg_replace(String expr, String str, String sub, int n=0, bool ignore_case=false);
List{String}? lst = regex::reg_split(String expr, String str, int n=0, bool ignore_case=false);
```

```c3 
import slre;

RegexInfo info;
SlreCap[3] caps; // { .ptr, .len } capture () group

int n = slre::compile(char* expr, int expr_len, RegexInfo* info);
int n = slre::match(String str, int str_len, RegexInfo *info);
int n = slre::reg_match(char *regexp, char *s, int s_len, SlreCap *caps, int num_caps, int flags);
char* s2 = slre::reg_replace(char *regex, char *buf, char *sub);
```

#### Files

* [slre.c3](slre.c3)
* [slre_test.c3](slre_test.c3)
* [regex.c3](regex.c3)
* [regex_test.c3](regex_test.c3)
* [regex_example.c3](regex_example.c3)

## Main Features

### 1. Regular Expression Compilation
```c3
RegEx* reg = regex::new_compile(mem, "pattern")!;
defer reg.free();  // Always free memory

// Ignore case option
RegEx* reg = regex::new_compile(mem, "pattern", true)!;
```

### 2. Pattern Matching
```c3
// Method 1: Using RegEx object
int start, len;
int result = reg.match(text, &start, &len)!; // result > 0, if success

// Method 2: Using convenience function
bool matched = regex::reg_match("pattern", text, &start, &len)!;
```

### 3. Capture Groups
```c3
RegEx* reg = regex::new_compile(`(\d\d\d\d)-(\d\d)-(\d\d)`)!; // \d{4} not supported
int n = reg.match("at 2026-04-04, spring");
RegMatch match = reg.group(0)!;  // Full match, match.s the whole matched substring
RegMatch group1 = reg.group(1)!; // First group, group1.s first () part, YYYY
RegMatch group2 = reg.group(2)!; // Second group, group2.s second () part, mm
RegMatch group3 = reg.group(3)!; // Second group, group3.s second () part, dd
```

### 4. Find All Matches
```c3
List{int[2]} matches = reg.find_all(text); // position/length pairs
defer matches.free();

foreach (pos : matches) {
    String matched = text[pos[0]:pos[1]];
}
```

### 5. String Replacement
```c3
// Replace all matches
String result = regex::reg_replace(mem, "pattern", text, "replacement")!;
defer result.free(mem);

// Replace only n matches
String result = regex::reg_replace(mem, "pattern", text, "replacement", 3)!;
result.free(mem);
```

### 6. String Split
```c3
List{String} parts = regex::reg_split(mem, "pattern", text)!;
defer parts.free();

// Split into n parts only
List{String} parts = regex::reg_split(mem, "pattern", text, 2)!;
parts.free()
```

## Supported Regex Patterns

### Basic Patterns
- `.` - Any single character
- `^` - Start of string
- `$` - End of string
- `*` - 0 or more repetitions
- `+` - 1 or more repetitions
- `?` - 0 or 1 occurrence

### Character Classes
- `[abc]` - Any of a, b, or c
- `[^abc]` - Not a, b, or c
- `[a-z]` - Range from a to z
- `[0-9]` - Digits
- `\d` - Digit (0-9)
- `\w` - Word character (a-z, A-Z, _)
- `\s` - Whitespace character

### Grouping
- `(pattern)` - Capture group
- `{n}` - *Not Supported!!*
- `{n,m}` - *Not Supported!!*


## Limitations

- Maximum capture groups: 10 (`MAX_GROUP` constant)
- Follows SLRE feature constraints (no lookahead, lookbehind support, etc.)
- Limited UTF-8 support
- No `{n}` `{n,m}` support

## API Reference

### Functions

#### `new_compile(Allocator, String, bool = false) -> RegEx*?`
Compiles a regular expression pattern.
- **Parameters:**
  - `allocx`: Allocator to use for memory allocation
  - `expr`: Regular expression pattern
  - `ignore_case`: Enable case-insensitive matching (optional, default: false)
- **Returns:** Pointer to RegEx object, or fault on error
- **Example:**
  ```c3
  RegEx* reg = regex::new_compile(mem, "\\d+")!;
  defer reg.free();
  ```

#### `RegEx.match(&self, String, int* = null, int* = null) -> int?`
Matches the pattern against a string.
- **Parameters:**
  - `str`: String to match against
  - `start`: Pointer to get start position (optional)
  - `len`: Pointer to get length (optional)
- **Returns:** Match result (>= 0 on success), or fault on error
- **Example:**
  ```c3
  int start, len;
  int result = reg.match("test 123", &start, &len)!;
  ```

#### `RegEx.group(&self, int) -> RegMatch?`
Gets a capture group from the last match.
- **Parameters:**
  - `idx`: Group index (0 = full match, 1+ = capture groups)
- **Returns:** RegMatch struct containing matched string and position
- **Example:**
  ```c3
  RegMatch username = reg.group(1)!;
  io::printfn("Username: %s", username.s);
  ```

#### `RegEx.find_all(&self, String) -> List{int[2]}`
Finds all matches in a string.
- **Parameters:**
  - `str`: String to search in
- **Returns:** List of [position, length] pairs
- **Example:**
  ```c3
  List{int[2]} matches = reg.find_all(text);
  defer matches.free();
  ```

#### `RegEx.replace(&self, Allocator, String, String, int = 0) -> String?`
Replaces matches with a replacement string.
- **Parameters:**
  - `allocx`: Allocator for result string
  - `str`: Input string
  - `sub`: Replacement string
  - `n`: Maximum number of replacements (0 = all)
- **Returns:** New string with replacements, must be freed
- **Example:**
  ```c3
  String result = reg.replace(mem, text, "***")!;
  defer result.free(mem);
  ```

#### `RegEx.split(&self, Allocator, String, int = 0) -> List{String}?`
Splits a string by the pattern.
- **Parameters:**
  - `allocx`: Allocator for result list
  - `str`: String to split
  - `n`: Maximum number of splits (0 = all)
- **Returns:** List of string parts, must be freed
- **Example:**
  ```c3
  List{String} parts = reg.split(mem, text)!;
  defer parts.free();
  ```

### Convenience Functions

#### `reg_match(String, String, int* = null, int* = null, bool = false) -> bool?`
One-shot pattern matching without creating a RegEx object.
- **Example:**
  ```c3
  bool matched = regex::reg_match("\\d+", "test 123")!;
  ```

#### `reg_replace(Allocator, String, String, String, int = 0, bool = false) -> String?`
One-shot string replacement.
- **Example:**
  ```c3
  String result = regex::reg_replace(mem, "\\d", text, "*")!;
  defer result.free(mem);
  ```

#### `reg_split(Allocator, String, String, int = 0, bool = false) -> List{String}?`
One-shot string splitting.
- **Example:**
  ```c3
  List{String} parts = regex::reg_split(mem, ",", csv_line)!;
  defer parts.free();
  ```

## Common Use Cases

### Email Validation
```c3
RegEx* reg = regex::new_compile(mem, "^\\w+@\\w+\\.\\w+$")!;
defer reg.free();
bool is_valid = reg.match(email)! >= 0;
```

### Extract All Numbers
```c3
RegEx* reg = regex::new_compile(mem, "\\d+")!;
defer reg.free();
List{int[2]} numbers = reg.find_all(text);
defer numbers.free();
```

### Remove HTML Tags
```c3
String clean = regex::reg_replace(mem, "<[^>]+>", html, "")!;
defer clean.free(mem);
```

### Split by Whitespace
```c3
List{String} words = regex::reg_split(mem, "\\s+", text)!;
defer words.free();
```

### Password Strength Check
```c3
RegEx* has_digit = regex::new_compile(mem, "\\d")!;
RegEx* has_upper = regex::new_compile(mem, "[A-Z]")!;
RegEx* has_lower = regex::new_compile(mem, "[a-z]")!;
defer { has_digit.free(); has_upper.free(); has_lower.free(); }

bool strong = password.len >= 8 &&
              has_digit.match(password)! >= 0 &&
              has_upper.match(password)! >= 0 &&
              has_lower.match(password)! >= 0;
```

## Best Practices

1. **Always use defer for cleanup**: This prevents memory leaks
   ```c3
   RegEx* reg = regex::new_compile(mem, pattern)!;
   defer reg.free();
   ```

2. **Reuse RegEx objects**: For repeated matches with the same pattern
   ```c3
   RegEx* reg = regex::new_compile(mem, pattern)!;
   defer reg.free();
   
   foreach (text : texts) {
       reg.match(text)!;
   }
   ```

3. **Use convenience functions for one-time matches**: Simpler and cleaner
   ```c3
   if (regex::reg_match("\\d+", text)!) {
       // Handle match
   }
   ```

4. **Handle errors properly**: Use `!` or explicit error handling
   ```c3
   int start;
   int? result = reg.match(text, &start);
   if (try result) { 
        if (result >= 0) {}
           io::printfn("Match: %s", text[start..]);
        }
   } else {
       io::printn("No match or error occurred");
   }
   ```

5. **Free allocated results**: Results from replace() and split() need cleanup
   ```c3
   String result = regex::reg_replace(mem, pattern, text, replacement)!;
   defer result.free(mem);
   ```

Back to [ext.c3l](../../README.md) library.

