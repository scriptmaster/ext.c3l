// complex.h.c3

module c::complex;

// ========== Linux ==========

module c::complex @if(env::LINUX);

// Complex number types
struct FloatComplex {
    float real;
    float imag;
}

struct DoubleComplex {
    double real;
    double imag;
}

struct LongDoubleComplex {
    double real;
    double imag;
}

// Type aliases
alias CFloatComplex = FloatComplex;
alias CDoubleComplex = DoubleComplex;
alias CLongDoubleComplex = LongDoubleComplex;

// Double precision complex functions
extern fn double cabs(DoubleComplex z);
extern fn double carg(DoubleComplex z);
extern fn DoubleComplex conj(DoubleComplex z);
extern fn DoubleComplex cproj(DoubleComplex z);
extern fn double creal(DoubleComplex z);
extern fn double cimag(DoubleComplex z);

// Trigonometric functions
extern fn DoubleComplex cacos(DoubleComplex z);
extern fn DoubleComplex casin(DoubleComplex z);
extern fn DoubleComplex catan(DoubleComplex z);
extern fn DoubleComplex ccos(DoubleComplex z);
extern fn DoubleComplex csin(DoubleComplex z);
extern fn DoubleComplex ctan(DoubleComplex z);

// Hyperbolic functions
extern fn DoubleComplex cacosh(DoubleComplex z);
extern fn DoubleComplex casinh(DoubleComplex z);
extern fn DoubleComplex catanh(DoubleComplex z);
extern fn DoubleComplex ccosh(DoubleComplex z);
extern fn DoubleComplex csinh(DoubleComplex z);
extern fn DoubleComplex ctanh(DoubleComplex z);

// Exponential and logarithmic functions
extern fn DoubleComplex cexp(DoubleComplex z);
extern fn DoubleComplex clog(DoubleComplex z);
extern fn DoubleComplex clog10(DoubleComplex z);

// Power and square root functions
extern fn DoubleComplex cpow(DoubleComplex x, DoubleComplex y);
extern fn DoubleComplex csqrt(DoubleComplex z);

// Float precision complex functions
extern fn float cabsf(FloatComplex z);
extern fn float cargf(FloatComplex z);
extern fn FloatComplex conjf(FloatComplex z);
extern fn FloatComplex cprojf(FloatComplex z);
extern fn float crealf(FloatComplex z);
extern fn float cimagf(FloatComplex z);

// Float trigonometric functions
extern fn FloatComplex cacosf(FloatComplex z);
extern fn FloatComplex casinf(FloatComplex z);
extern fn FloatComplex catanf(FloatComplex z);
extern fn FloatComplex ccosf(FloatComplex z);
extern fn FloatComplex csinf(FloatComplex z);
extern fn FloatComplex ctanf(FloatComplex z);

// Float hyperbolic functions
extern fn FloatComplex cacoshf(FloatComplex z);
extern fn FloatComplex casinhf(FloatComplex z);
extern fn FloatComplex catanhf(FloatComplex z);
extern fn FloatComplex ccoshf(FloatComplex z);
extern fn FloatComplex csinhf(FloatComplex z);
extern fn FloatComplex ctanhf(FloatComplex z);

// Float exponential and logarithmic functions
extern fn FloatComplex cexpf(FloatComplex z);
extern fn FloatComplex clogf(FloatComplex z);
extern fn FloatComplex clog10f(FloatComplex z);

// Float power and square root functions
extern fn FloatComplex cpowf(FloatComplex x, FloatComplex y);
extern fn FloatComplex csqrtf(FloatComplex z);

// Long double precision complex functions
extern fn double cabsl(LongDoubleComplex z);
extern fn double cargl(LongDoubleComplex z);
extern fn LongDoubleComplex conjl(LongDoubleComplex z);
extern fn LongDoubleComplex cprojl(LongDoubleComplex z);
extern fn double creall(LongDoubleComplex z);
extern fn double cimagl(LongDoubleComplex z);

// Long double trigonometric functions
extern fn LongDoubleComplex cacosl(LongDoubleComplex z);
extern fn LongDoubleComplex casinl(LongDoubleComplex z);
extern fn LongDoubleComplex catanl(LongDoubleComplex z);
extern fn LongDoubleComplex ccosl(LongDoubleComplex z);
extern fn LongDoubleComplex csinl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanl(LongDoubleComplex z);

// Long double hyperbolic functions
extern fn LongDoubleComplex cacoshl(LongDoubleComplex z);
extern fn LongDoubleComplex casinhl(LongDoubleComplex z);
extern fn LongDoubleComplex catanhl(LongDoubleComplex z);
extern fn LongDoubleComplex ccoshl(LongDoubleComplex z);
extern fn LongDoubleComplex csinhl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanhl(LongDoubleComplex z);

// Long double exponential and logarithmic functions
extern fn LongDoubleComplex cexpl(LongDoubleComplex z);
extern fn LongDoubleComplex clogl(LongDoubleComplex z);
extern fn LongDoubleComplex clog10l(LongDoubleComplex z);

// Long double power and square root functions
extern fn LongDoubleComplex cpowl(LongDoubleComplex x, LongDoubleComplex y);
extern fn LongDoubleComplex csqrtl(LongDoubleComplex z);

// Complex number construction (C11 macros)
macro FloatComplex cmplxf(float real, float imag) => FloatComplex { real, imag };
macro DoubleComplex cmplx(double real, double imag) => DoubleComplex { real, imag };
macro LongDoubleComplex cmplxl(double real, double imag) => LongDoubleComplex { real, imag };

// Imaginary unit
const DoubleComplex I = { 0.0, 1.0 };
const FloatComplex I_F = { 0.0f, 1.0f };
const LongDoubleComplex I_L = { 0.0, 1.0 };

// ========== Darwin (macOS) ==========

module c::complex @if(env::DARWIN);

// Complex number types
struct FloatComplex {
    float real;
    float imag;
}

struct DoubleComplex {
    double real;
    double imag;
}

struct LongDoubleComplex {
    double real;
    double imag;
}

alias CFloatComplex = FloatComplex;
alias CDoubleComplex = DoubleComplex;
alias CLongDoubleComplex = LongDoubleComplex;

// Double precision functions
extern fn double cabs(DoubleComplex z);
extern fn double carg(DoubleComplex z);
extern fn DoubleComplex conj(DoubleComplex z);
extern fn DoubleComplex cproj(DoubleComplex z);
extern fn double creal(DoubleComplex z);
extern fn double cimag(DoubleComplex z);
extern fn DoubleComplex cacos(DoubleComplex z);
extern fn DoubleComplex casin(DoubleComplex z);
extern fn DoubleComplex catan(DoubleComplex z);
extern fn DoubleComplex ccos(DoubleComplex z);
extern fn DoubleComplex csin(DoubleComplex z);
extern fn DoubleComplex ctan(DoubleComplex z);
extern fn DoubleComplex cacosh(DoubleComplex z);
extern fn DoubleComplex casinh(DoubleComplex z);
extern fn DoubleComplex catanh(DoubleComplex z);
extern fn DoubleComplex ccosh(DoubleComplex z);
extern fn DoubleComplex csinh(DoubleComplex z);
extern fn DoubleComplex ctanh(DoubleComplex z);
extern fn DoubleComplex cexp(DoubleComplex z);
extern fn DoubleComplex clog(DoubleComplex z);
extern fn DoubleComplex cpow(DoubleComplex x, DoubleComplex y);
extern fn DoubleComplex csqrt(DoubleComplex z);

// Float precision functions
extern fn float cabsf(FloatComplex z);
extern fn float cargf(FloatComplex z);
extern fn FloatComplex conjf(FloatComplex z);
extern fn FloatComplex cprojf(FloatComplex z);
extern fn float crealf(FloatComplex z);
extern fn float cimagf(FloatComplex z);
extern fn FloatComplex cacosf(FloatComplex z);
extern fn FloatComplex casinf(FloatComplex z);
extern fn FloatComplex catanf(FloatComplex z);
extern fn FloatComplex ccosf(FloatComplex z);
extern fn FloatComplex csinf(FloatComplex z);
extern fn FloatComplex ctanf(FloatComplex z);
extern fn FloatComplex cacoshf(FloatComplex z);
extern fn FloatComplex casinhf(FloatComplex z);
extern fn FloatComplex catanhf(FloatComplex z);
extern fn FloatComplex ccoshf(FloatComplex z);
extern fn FloatComplex csinhf(FloatComplex z);
extern fn FloatComplex ctanhf(FloatComplex z);
extern fn FloatComplex cexpf(FloatComplex z);
extern fn FloatComplex clogf(FloatComplex z);
extern fn FloatComplex cpowf(FloatComplex x, FloatComplex y);
extern fn FloatComplex csqrtf(FloatComplex z);

// Long double precision functions
extern fn double cabsl(LongDoubleComplex z);
extern fn double cargl(LongDoubleComplex z);
extern fn LongDoubleComplex conjl(LongDoubleComplex z);
extern fn LongDoubleComplex cprojl(LongDoubleComplex z);
extern fn double creall(LongDoubleComplex z);
extern fn double cimagl(LongDoubleComplex z);
extern fn LongDoubleComplex cacosl(LongDoubleComplex z);
extern fn LongDoubleComplex casinl(LongDoubleComplex z);
extern fn LongDoubleComplex catanl(LongDoubleComplex z);
extern fn LongDoubleComplex ccosl(LongDoubleComplex z);
extern fn LongDoubleComplex csinl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanl(LongDoubleComplex z);
extern fn LongDoubleComplex cacoshl(LongDoubleComplex z);
extern fn LongDoubleComplex casinhl(LongDoubleComplex z);
extern fn LongDoubleComplex catanhl(LongDoubleComplex z);
extern fn LongDoubleComplex ccoshl(LongDoubleComplex z);
extern fn LongDoubleComplex csinhl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanhl(LongDoubleComplex z);
extern fn LongDoubleComplex cexpl(LongDoubleComplex z);
extern fn LongDoubleComplex clogl(LongDoubleComplex z);
extern fn LongDoubleComplex cpowl(LongDoubleComplex x, LongDoubleComplex y);
extern fn LongDoubleComplex csqrtl(LongDoubleComplex z);

// Complex number construction (C11 macros)
macro FloatComplex cmplxf(float real, float imag) => FloatComplex { real, imag };
macro DoubleComplex cmplx(double real, double imag) => DoubleComplex { real, imag };
macro LongDoubleComplex cmplxl(double real, double imag) => LongDoubleComplex { real, imag };

const DoubleComplex I = { 0.0, 1.0 };
const FloatComplex I_F = { 0.0f, 1.0f };
const LongDoubleComplex I_L = { 0.0, 1.0 };

// ========== FreeBSD ==========

module c::complex @if(env::FREEBSD);

// Complex number types
struct FloatComplex {
    float real;
    float imag;
}

struct DoubleComplex {
    double real;
    double imag;
}

struct LongDoubleComplex {
    double real;
    double imag;
}

alias CFloatComplex = FloatComplex;
alias CDoubleComplex = DoubleComplex;
alias CLongDoubleComplex = LongDoubleComplex;

// Double precision functions
extern fn double cabs(DoubleComplex z);
extern fn double carg(DoubleComplex z);
extern fn DoubleComplex conj(DoubleComplex z);
extern fn DoubleComplex cproj(DoubleComplex z);
extern fn double creal(DoubleComplex z);
extern fn double cimag(DoubleComplex z);
extern fn DoubleComplex cacos(DoubleComplex z);
extern fn DoubleComplex casin(DoubleComplex z);
extern fn DoubleComplex catan(DoubleComplex z);
extern fn DoubleComplex ccos(DoubleComplex z);
extern fn DoubleComplex csin(DoubleComplex z);
extern fn DoubleComplex ctan(DoubleComplex z);
extern fn DoubleComplex cacosh(DoubleComplex z);
extern fn DoubleComplex casinh(DoubleComplex z);
extern fn DoubleComplex catanh(DoubleComplex z);
extern fn DoubleComplex ccosh(DoubleComplex z);
extern fn DoubleComplex csinh(DoubleComplex z);
extern fn DoubleComplex ctanh(DoubleComplex z);
extern fn DoubleComplex cexp(DoubleComplex z);
extern fn DoubleComplex clog(DoubleComplex z);
extern fn DoubleComplex cpow(DoubleComplex x, DoubleComplex y);
extern fn DoubleComplex csqrt(DoubleComplex z);

// Float precision functions
extern fn float cabsf(FloatComplex z);
extern fn float cargf(FloatComplex z);
extern fn FloatComplex conjf(FloatComplex z);
extern fn FloatComplex cprojf(FloatComplex z);
extern fn float crealf(FloatComplex z);
extern fn float cimagf(FloatComplex z);
extern fn FloatComplex cacosf(FloatComplex z);
extern fn FloatComplex casinf(FloatComplex z);
extern fn FloatComplex catanf(FloatComplex z);
extern fn FloatComplex ccosf(FloatComplex z);
extern fn FloatComplex csinf(FloatComplex z);
extern fn FloatComplex ctanf(FloatComplex z);
extern fn FloatComplex cacoshf(FloatComplex z);
extern fn FloatComplex casinhf(FloatComplex z);
extern fn FloatComplex catanhf(FloatComplex z);
extern fn FloatComplex ccoshf(FloatComplex z);
extern fn FloatComplex csinhf(FloatComplex z);
extern fn FloatComplex ctanhf(FloatComplex z);
extern fn FloatComplex cexpf(FloatComplex z);
extern fn FloatComplex clogf(FloatComplex z);
extern fn FloatComplex cpowf(FloatComplex x, FloatComplex y);
extern fn FloatComplex csqrtf(FloatComplex z);

// Long double precision functions
extern fn double cabsl(LongDoubleComplex z);
extern fn double cargl(LongDoubleComplex z);
extern fn LongDoubleComplex conjl(LongDoubleComplex z);
extern fn LongDoubleComplex cprojl(LongDoubleComplex z);
extern fn double creall(LongDoubleComplex z);
extern fn double cimagl(LongDoubleComplex z);
extern fn LongDoubleComplex cacosl(LongDoubleComplex z);
extern fn LongDoubleComplex casinl(LongDoubleComplex z);
extern fn LongDoubleComplex catanl(LongDoubleComplex z);
extern fn LongDoubleComplex ccosl(LongDoubleComplex z);
extern fn LongDoubleComplex csinl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanl(LongDoubleComplex z);
extern fn LongDoubleComplex cacoshl(LongDoubleComplex z);
extern fn LongDoubleComplex casinhl(LongDoubleComplex z);
extern fn LongDoubleComplex catanhl(LongDoubleComplex z);
extern fn LongDoubleComplex ccoshl(LongDoubleComplex z);
extern fn LongDoubleComplex csinhl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanhl(LongDoubleComplex z);
extern fn LongDoubleComplex cexpl(LongDoubleComplex z);
extern fn LongDoubleComplex clogl(LongDoubleComplex z);
extern fn LongDoubleComplex cpowl(LongDoubleComplex x, LongDoubleComplex y);
extern fn LongDoubleComplex csqrtl(LongDoubleComplex z);

// Complex number construction (C11 macros)
macro FloatComplex cmplxf(float real, float imag) => FloatComplex { real, imag };
macro DoubleComplex cmplx(double real, double imag) => DoubleComplex { real, imag };
macro LongDoubleComplex cmplxl(double real, double imag) => LongDoubleComplex { real, imag };

const DoubleComplex I = { 0.0, 1.0 };
const FloatComplex I_F = { 0.0f, 1.0f };
const LongDoubleComplex I_L = { 0.0, 1.0 };

// ========== NetBSD ==========

module c::complex @if(env::NETBSD);

// Complex number types
struct FloatComplex {
    float real;
    float imag;
}

struct DoubleComplex {
    double real;
    double imag;
}

struct LongDoubleComplex {
    double real;
    double imag;
}

alias CFloatComplex = FloatComplex;
alias CDoubleComplex = DoubleComplex;
alias CLongDoubleComplex = LongDoubleComplex;

// Double precision functions
extern fn double cabs(DoubleComplex z);
extern fn double carg(DoubleComplex z);
extern fn DoubleComplex conj(DoubleComplex z);
extern fn DoubleComplex cproj(DoubleComplex z);
extern fn double creal(DoubleComplex z);
extern fn double cimag(DoubleComplex z);
extern fn DoubleComplex cacos(DoubleComplex z);
extern fn DoubleComplex casin(DoubleComplex z);
extern fn DoubleComplex catan(DoubleComplex z);
extern fn DoubleComplex ccos(DoubleComplex z);
extern fn DoubleComplex csin(DoubleComplex z);
extern fn DoubleComplex ctan(DoubleComplex z);
extern fn DoubleComplex cacosh(DoubleComplex z);
extern fn DoubleComplex casinh(DoubleComplex z);
extern fn DoubleComplex catanh(DoubleComplex z);
extern fn DoubleComplex ccosh(DoubleComplex z);
extern fn DoubleComplex csinh(DoubleComplex z);
extern fn DoubleComplex ctanh(DoubleComplex z);
extern fn DoubleComplex cexp(DoubleComplex z);
extern fn DoubleComplex clog(DoubleComplex z);
extern fn DoubleComplex cpow(DoubleComplex x, DoubleComplex y);
extern fn DoubleComplex csqrt(DoubleComplex z);

// Float precision functions
extern fn float cabsf(FloatComplex z);
extern fn float cargf(FloatComplex z);
extern fn FloatComplex conjf(FloatComplex z);
extern fn FloatComplex cprojf(FloatComplex z);
extern fn float crealf(FloatComplex z);
extern fn float cimagf(FloatComplex z);
extern fn FloatComplex cacosf(FloatComplex z);
extern fn FloatComplex casinf(FloatComplex z);
extern fn FloatComplex catanf(FloatComplex z);
extern fn FloatComplex ccosf(FloatComplex z);
extern fn FloatComplex csinf(FloatComplex z);
extern fn FloatComplex ctanf(FloatComplex z);
extern fn FloatComplex cacoshf(FloatComplex z);
extern fn FloatComplex casinhf(FloatComplex z);
extern fn FloatComplex catanhf(FloatComplex z);
extern fn FloatComplex ccoshf(FloatComplex z);
extern fn FloatComplex csinhf(FloatComplex z);
extern fn FloatComplex ctanhf(FloatComplex z);
extern fn FloatComplex cexpf(FloatComplex z);
extern fn FloatComplex clogf(FloatComplex z);
extern fn FloatComplex cpowf(FloatComplex x, FloatComplex y);
extern fn FloatComplex csqrtf(FloatComplex z);

// Long double precision functions
extern fn double cabsl(LongDoubleComplex z);
extern fn double cargl(LongDoubleComplex z);
extern fn LongDoubleComplex conjl(LongDoubleComplex z);
extern fn LongDoubleComplex cprojl(LongDoubleComplex z);
extern fn double creall(LongDoubleComplex z);
extern fn double cimagl(LongDoubleComplex z);
extern fn LongDoubleComplex cacosl(LongDoubleComplex z);
extern fn LongDoubleComplex casinl(LongDoubleComplex z);
extern fn LongDoubleComplex catanl(LongDoubleComplex z);
extern fn LongDoubleComplex ccosl(LongDoubleComplex z);
extern fn LongDoubleComplex csinl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanl(LongDoubleComplex z);
extern fn LongDoubleComplex cacoshl(LongDoubleComplex z);
extern fn LongDoubleComplex casinhl(LongDoubleComplex z);
extern fn LongDoubleComplex catanhl(LongDoubleComplex z);
extern fn LongDoubleComplex ccoshl(LongDoubleComplex z);
extern fn LongDoubleComplex csinhl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanhl(LongDoubleComplex z);
extern fn LongDoubleComplex cexpl(LongDoubleComplex z);
extern fn LongDoubleComplex clogl(LongDoubleComplex z);
extern fn LongDoubleComplex cpowl(LongDoubleComplex x, LongDoubleComplex y);
extern fn LongDoubleComplex csqrtl(LongDoubleComplex z);

// Complex number construction (C11 macros)
macro FloatComplex cmplxf(float real, float imag) => FloatComplex { real, imag };
macro DoubleComplex cmplx(double real, double imag) => DoubleComplex { real, imag };
macro LongDoubleComplex cmplxl(double real, double imag) => LongDoubleComplex { real, imag };

const DoubleComplex I = { 0.0, 1.0 };
const FloatComplex I_F = { 0.0f, 1.0f };
const LongDoubleComplex I_L = { 0.0, 1.0 };

// ========== OpenBSD ==========

module c::complex @if(env::OPENBSD);

// Complex number types
struct FloatComplex {
    float real;
    float imag;
}

struct DoubleComplex {
    double real;
    double imag;
}

struct LongDoubleComplex {
    double real;
    double imag;
}

alias CFloatComplex = FloatComplex;
alias CDoubleComplex = DoubleComplex;
alias CLongDoubleComplex = LongDoubleComplex;

// Double precision functions
extern fn double cabs(DoubleComplex z);
extern fn double carg(DoubleComplex z);
extern fn DoubleComplex conj(DoubleComplex z);
extern fn DoubleComplex cproj(DoubleComplex z);
extern fn double creal(DoubleComplex z);
extern fn double cimag(DoubleComplex z);
extern fn DoubleComplex cacos(DoubleComplex z);
extern fn DoubleComplex casin(DoubleComplex z);
extern fn DoubleComplex catan(DoubleComplex z);
extern fn DoubleComplex ccos(DoubleComplex z);
extern fn DoubleComplex csin(DoubleComplex z);
extern fn DoubleComplex ctan(DoubleComplex z);
extern fn DoubleComplex cacosh(DoubleComplex z);
extern fn DoubleComplex casinh(DoubleComplex z);
extern fn DoubleComplex catanh(DoubleComplex z);
extern fn DoubleComplex ccosh(DoubleComplex z);
extern fn DoubleComplex csinh(DoubleComplex z);
extern fn DoubleComplex ctanh(DoubleComplex z);
extern fn DoubleComplex cexp(DoubleComplex z);
extern fn DoubleComplex clog(DoubleComplex z);
extern fn DoubleComplex cpow(DoubleComplex x, DoubleComplex y);
extern fn DoubleComplex csqrt(DoubleComplex z);

// Float precision functions
extern fn float cabsf(FloatComplex z);
extern fn float cargf(FloatComplex z);
extern fn FloatComplex conjf(FloatComplex z);
extern fn FloatComplex cprojf(FloatComplex z);
extern fn float crealf(FloatComplex z);
extern fn float cimagf(FloatComplex z);
extern fn FloatComplex cacosf(FloatComplex z);
extern fn FloatComplex casinf(FloatComplex z);
extern fn FloatComplex catanf(FloatComplex z);
extern fn FloatComplex ccosf(FloatComplex z);
extern fn FloatComplex csinf(FloatComplex z);
extern fn FloatComplex ctanf(FloatComplex z);
extern fn FloatComplex cacoshf(FloatComplex z);
extern fn FloatComplex casinhf(FloatComplex z);
extern fn FloatComplex catanhf(FloatComplex z);
extern fn FloatComplex ccoshf(FloatComplex z);
extern fn FloatComplex csinhf(FloatComplex z);
extern fn FloatComplex ctanhf(FloatComplex z);
extern fn FloatComplex cexpf(FloatComplex z);
extern fn FloatComplex clogf(FloatComplex z);
extern fn FloatComplex cpowf(FloatComplex x, FloatComplex y);
extern fn FloatComplex csqrtf(FloatComplex z);

// Long double precision functions
extern fn double cabsl(LongDoubleComplex z);
extern fn double cargl(LongDoubleComplex z);
extern fn LongDoubleComplex conjl(LongDoubleComplex z);
extern fn LongDoubleComplex cprojl(LongDoubleComplex z);
extern fn double creall(LongDoubleComplex z);
extern fn double cimagl(LongDoubleComplex z);
extern fn LongDoubleComplex cacosl(LongDoubleComplex z);
extern fn LongDoubleComplex casinl(LongDoubleComplex z);
extern fn LongDoubleComplex catanl(LongDoubleComplex z);
extern fn LongDoubleComplex ccosl(LongDoubleComplex z);
extern fn LongDoubleComplex csinl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanl(LongDoubleComplex z);
extern fn LongDoubleComplex cacoshl(LongDoubleComplex z);
extern fn LongDoubleComplex casinhl(LongDoubleComplex z);
extern fn LongDoubleComplex catanhl(LongDoubleComplex z);
extern fn LongDoubleComplex ccoshl(LongDoubleComplex z);
extern fn LongDoubleComplex csinhl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanhl(LongDoubleComplex z);
extern fn LongDoubleComplex cexpl(LongDoubleComplex z);
extern fn LongDoubleComplex clogl(LongDoubleComplex z);
extern fn LongDoubleComplex cpowl(LongDoubleComplex x, LongDoubleComplex y);
extern fn LongDoubleComplex csqrtl(LongDoubleComplex z);

// Complex number construction (C11 macros)
macro FloatComplex cmplxf(float real, float imag) => FloatComplex { real, imag };
macro DoubleComplex cmplx(double real, double imag) => DoubleComplex { real, imag };
macro LongDoubleComplex cmplxl(double real, double imag) => LongDoubleComplex { real, imag };

const DoubleComplex I = { 0.0, 1.0 };
const FloatComplex I_F = { 0.0f, 1.0f };
const LongDoubleComplex I_L = { 0.0, 1.0 };

// ========== Windows ==========

module c::complex @if(env::WIN32);

// Complex number types
struct FloatComplex {
    float real;
    float imag;
}

struct DoubleComplex {
    double real;
    double imag;
}

struct LongDoubleComplex {
    double real;
    double imag;
}

alias CFloatComplex = FloatComplex;
alias CDoubleComplex = DoubleComplex;
alias CLongDoubleComplex = LongDoubleComplex;

// Note: MSVC does not fully support C99 complex.h
// Complex functions may be available in newer versions or with MinGW/Clang
// For full support, use C++ <complex> or third-party libraries

// These functions are available in C11 standard library (Visual Studio 2015+)
// However, support may be limited - check your compiler version

extern fn double cabs(DoubleComplex z);
extern fn double carg(DoubleComplex z);
extern fn DoubleComplex conj(DoubleComplex z);
extern fn DoubleComplex cproj(DoubleComplex z);
extern fn double creal(DoubleComplex z);
extern fn double cimag(DoubleComplex z);
extern fn DoubleComplex cacos(DoubleComplex z);
extern fn DoubleComplex casin(DoubleComplex z);
extern fn DoubleComplex catan(DoubleComplex z);
extern fn DoubleComplex ccos(DoubleComplex z);
extern fn DoubleComplex csin(DoubleComplex z);
extern fn DoubleComplex ctan(DoubleComplex z);
extern fn DoubleComplex cacosh(DoubleComplex z);
extern fn DoubleComplex casinh(DoubleComplex z);
extern fn DoubleComplex catanh(DoubleComplex z);
extern fn DoubleComplex ccosh(DoubleComplex z);
extern fn DoubleComplex csinh(DoubleComplex z);
extern fn DoubleComplex ctanh(DoubleComplex z);
extern fn DoubleComplex cexp(DoubleComplex z);
extern fn DoubleComplex clog(DoubleComplex z);
extern fn DoubleComplex cpow(DoubleComplex x, DoubleComplex y);
extern fn DoubleComplex csqrt(DoubleComplex z);

// Float versions
extern fn float cabsf(FloatComplex z);
extern fn float cargf(FloatComplex z);
extern fn FloatComplex conjf(FloatComplex z);
extern fn FloatComplex cprojf(FloatComplex z);
extern fn float crealf(FloatComplex z);
extern fn float cimagf(FloatComplex z);
extern fn FloatComplex cacosf(FloatComplex z);
extern fn FloatComplex casinf(FloatComplex z);
extern fn FloatComplex catanf(FloatComplex z);
extern fn FloatComplex ccosf(FloatComplex z);
extern fn FloatComplex csinf(FloatComplex z);
extern fn FloatComplex ctanf(FloatComplex z);
extern fn FloatComplex cacoshf(FloatComplex z);
extern fn FloatComplex casinhf(FloatComplex z);
extern fn FloatComplex catanhf(FloatComplex z);
extern fn FloatComplex ccoshf(FloatComplex z);
extern fn FloatComplex csinhf(FloatComplex z);
extern fn FloatComplex ctanhf(FloatComplex z);
extern fn FloatComplex cexpf(FloatComplex z);
extern fn FloatComplex clogf(FloatComplex z);
extern fn FloatComplex cpowf(FloatComplex x, FloatComplex y);
extern fn FloatComplex csqrtf(FloatComplex z);

// Long double versions (often aliased to double on Windows)
extern fn double cabsl(LongDoubleComplex z);
extern fn double cargl(LongDoubleComplex z);
extern fn LongDoubleComplex conjl(LongDoubleComplex z);
extern fn LongDoubleComplex cprojl(LongDoubleComplex z);
extern fn double creall(LongDoubleComplex z);
extern fn double cimagl(LongDoubleComplex z);
extern fn LongDoubleComplex cacosl(LongDoubleComplex z);
extern fn LongDoubleComplex casinl(LongDoubleComplex z);
extern fn LongDoubleComplex catanl(LongDoubleComplex z);
extern fn LongDoubleComplex ccosl(LongDoubleComplex z);
extern fn LongDoubleComplex csinl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanl(LongDoubleComplex z);
extern fn LongDoubleComplex cacoshl(LongDoubleComplex z);
extern fn LongDoubleComplex casinhl(LongDoubleComplex z);
extern fn LongDoubleComplex catanhl(LongDoubleComplex z);
extern fn LongDoubleComplex ccoshl(LongDoubleComplex z);
extern fn LongDoubleComplex csinhl(LongDoubleComplex z);
extern fn LongDoubleComplex ctanhl(LongDoubleComplex z);
extern fn LongDoubleComplex cexpl(LongDoubleComplex z);
extern fn LongDoubleComplex clogl(LongDoubleComplex z);
extern fn LongDoubleComplex cpowl(LongDoubleComplex x, LongDoubleComplex y);
extern fn LongDoubleComplex csqrtl(LongDoubleComplex z);

// Windows-specific: _Fcomplex, _Dcomplex, _Lcomplex types exist
// but they use different structure layout
// The above definitions should work with MinGW/Clang

// Macros
// Complex number construction (C11 macros)
macro FloatComplex cmplxf(float real, float imag) => FloatComplex { real, imag };
macro DoubleComplex cmplx(double real, double imag) => DoubleComplex { real, imag };
macro LongDoubleComplex cmplxl(double real, double imag) => LongDoubleComplex { real, imag };

const DoubleComplex I = { 0.0, 1.0 };
const FloatComplex I_F = { 0.0f, 1.0f };
const LongDoubleComplex I_L = { 0.0, 1.0 };

// Alternative: Use C++ <complex> for full support on Windows
// Or use a third-party complex number library
