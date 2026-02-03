// stdio.h.c3

module stdio;

alias Size = usz;
alias CFile = void*;

// Standard I/O

extern fn int printf(char* format, ...);
extern fn int scanf(char* format, ...);

extern fn int puts(char* s);
extern fn int putchar(int c);
extern fn int getchar();

// File operations

extern fn CFile fopen(char* filename, char* mode);
extern fn CFile fdopen(int fd, char* mode);
extern fn int fclose(CFile stream);
extern fn int fflush(CFile stream);

extern fn int remove(char* filename);
extern fn int rename(char* oldname, char* newname);

// File I/O 

extern fn int fprintf(CFile stream, char* format, ...);
extern fn int fscanf(CFile stream, char* format, ...);

extern fn char* fgets(char* s, int n, CFile stream);
extern fn int fputs(char* s, CFile stream);

extern fn Size fread(void* ptr, Size size, Size nmemb, CFile stream);
extern fn Size fwrite(void* ptr, Size size, Size nmemb, CFile stream);

// File Positioning

enum Whence: int (int val) {
    SEEK_SET = 0,
    SEEK_CUR = 1, 
    SEEK_END = 2
}

extern fn int fseek(CFile stream, long offset, int whence);
extern fn long ftell(CFile stream);
extern fn void rewind(CFile stream);
extern fn int _fseeki64(CFile stream, long offset, int whence) @if(env::WIN32);
extern fn long _ftelli64(CFile stream) @if(env::WIN32);

// String I/O 

extern fn int sprintf(char* str, char* format, ...);
extern fn int snprintf(char* str, Size size, char* format, ...);
extern fn int sscanf(char* str, char* format, ...);
