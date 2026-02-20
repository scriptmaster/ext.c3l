// setjmp.h.c3

// Standard C setjmp/longjmp - available on all platforms
module setjmp @if(!env::WIN32);

extern fn int  setjmp(JmpBuf* env);
extern fn void longjmp(JmpBuf* env, int val);

// Underscored variants (no signal mask save/restore)
extern fn int  _setjmp(JmpBuf* env);
extern fn void _longjmp(JmpBuf* env, int val);



module setjmp @if(env::LINUX);

extern fn int  sigsetjmp(SigJmpBuf* env, int savemask) @cname("__sigsetjmp");
extern fn void siglongjmp(SigJmpBuf* env, int val) @cname("siglongjmp");

// x86_64: matches struct __jmp_buf_tag in glibc bits/setjmp.h
// __jmpbuf saves: rbx, rbp, r12-r15, rsp, rip
struct JmpBuf {
    long[8]   __jmpbuf;         // Register save area
    int       __mask_was_saved; // Whether the signal mask was saved
    int       __padding;
    ulong[16] __saved_mask;     // Saved signal mask (__sigset_t)
}

// On Linux sigjmp_buf is identical to jmp_buf
alias SigJmpBuf = JmpBuf;



module setjmp @if(env::DARWIN);

extern fn int  sigsetjmp(SigJmpBuf* env, int savemask);
extern fn void siglongjmp(SigJmpBuf* env, int val);

// x86_64: _JBLEN = 37 (from i386/setjmp.h, _JBLEN differs per arch)
// arm64 note: _JBLEN = 17 (int[17]); adjust if targeting arm64
struct JmpBuf {
    int[37] _jb;
}

// sigjmp_buf wraps jmp_buf and stores the saved signal mask
struct SigJmpBuf {
    int[37] _jb;
    int     _mask_saved;
    uint    _sigmask;  // Darwin uses 32-bit sigset_t
}



module setjmp @if(env::FREEBSD);

extern fn int  sigsetjmp(SigJmpBuf* env, int savemask);
extern fn void siglongjmp(SigJmpBuf* env, int val);

// x86_64: 12 longs (from machine/setjmp.h)
// saves: rbx, rbp, r12-r15, rsp, rip + fp regs
struct JmpBuf {
    long[12] _jb;
}

struct SigJmpBuf {
    long[12] _jb;
    int      _mask_saved;
    int      _padding;
    uint[4]  _sigmask;  // sigset_t = uint[4] on FreeBSD
}



module setjmp @if(env::NETBSD);

extern fn int  sigsetjmp(SigJmpBuf* env, int savemask);
extern fn void siglongjmp(SigJmpBuf* env, int val);

// x86_64: 14 longs (from x86_64/setjmp.h)
struct JmpBuf {
    long[14] _jb;
}

struct SigJmpBuf {
    long[14] _jb;
    int      _mask_saved;
    int      _padding;
    uint[4]  _sigmask;  // sigset_t = uint[4] on NetBSD
}



module setjmp @if(env::OPENBSD);

extern fn int  sigsetjmp(SigJmpBuf* env, int savemask);
extern fn void siglongjmp(SigJmpBuf* env, int val);

// x86_64: 10 longs (from machine/setjmp.h)
struct JmpBuf {
    long[10] _jb;
}

// sigjmp_buf includes a 32-bit signal mask (OpenBSD uses 32-bit sigset_t)
struct SigJmpBuf {
    long[10] _jb;
    int      _mask_saved;
    uint     _sigmask;
}
