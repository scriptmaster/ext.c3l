// objbase.h.c3

module c::objbase @if(env::WIN32);

// -----------------------------------------------------------------------
// Basic Windows types used throughout COM
// -----------------------------------------------------------------------

alias LPVoid = void*;
alias PVoid = void*;
alias Bool = int;
alias DWord = uint;
alias Word = ushort;
alias Byte = char;
alias Long = long;
alias ULong = ulong;
alias LongLong = long;  // 64-bit signed
alias ULongPtr = ulong;
alias Handle = ulong;    // HANDLE (void* on Win64)

// HRESULT: 32-bit result code
// Bit 31 (S): 0 = success, 1 = failure
// Bits 16-30 (Facility): origin of error
// Bits 0-15 (Code): specific error code
alias HResult = int;


// WCHAR (UTF-16LE)
alias WChar = ushort;
alias LPWStr = WChar*;
alias LPCWStr = WChar*;

// TCHAR (Unicode build)
alias TChar = WChar;
alias LPTStr = TChar*;

// -----------------------------------------------------------------------
// GUID / UUID
// -----------------------------------------------------------------------

// Globally Unique Identifier
struct Guid {
    uint   data1;
    ushort data2;
    ushort data3;
    char[8] data4;
}

// Aliases
alias Uuid = Guid;
alias Clsid = Guid;   // Class ID
alias Iid = Guid;     // Interface ID
alias Libid = Guid;   // Type Library ID
alias Catid = Guid;   // Category ID

alias LpGuid = Guid*;
alias LpClsid = Guid*;
alias LpIid = Guid*;
alias LpcGuid = Guid*;
alias RefGuid = Guid*;   // REFGUID  (const GUID&)
alias RefClsid = Guid*;  // REFCLSID (const CLSID&)
alias RefIid = Guid*;    // REFIID   (const IID&)

// Well-known GUIDs
// IID_IUnknown = {00000000-0000-0000-C000-000000000046}
const Guid IID_IUNKNOWN = { 0x00000000, 0x0000, 0x0000, { 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46 } };
// IID_IClassFactory = {00000001-0000-0000-C000-000000000046}
const Guid IID_ICLASS_FACTORY = { 0x00000001, 0x0000, 0x0000, { 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46 } };
// IID_IMalloc = {00000002-0000-0000-C000-000000000046}
const Guid IID_IMALLOC = { 0x00000002, 0x0000, 0x0000, { 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46 } };

// -----------------------------------------------------------------------
// HRESULT: Facility codes
// -----------------------------------------------------------------------

const int FACILITY_NULL          = 0;
const int FACILITY_RPC           = 1;
const int FACILITY_DISPATCH      = 2;
const int FACILITY_STORAGE       = 3;
const int FACILITY_ITF           = 4;   // Interface-specific errors
const int FACILITY_WIN32         = 7;
const int FACILITY_WINDOWS       = 8;
const int FACILITY_SECURITY      = 9;
const int FACILITY_SSPI          = 9;
const int FACILITY_CONTROL       = 10;
const int FACILITY_CERT          = 11;
const int FACILITY_INTERNET      = 12;
const int FACILITY_MEDIASERVER   = 13;
const int FACILITY_MSMQ          = 14;
const int FACILITY_SETUPAPI      = 15;
const int FACILITY_SCARD         = 16;
const int FACILITY_COMPLUS       = 17;
const int FACILITY_AAF           = 18;
const int FACILITY_URT           = 19;
const int FACILITY_ACS           = 20;
const int FACILITY_DPLAY         = 21;
const int FACILITY_UMI           = 22;
const int FACILITY_SXS           = 23;
const int FACILITY_WINDOWS_CE    = 24;
const int FACILITY_HTTP          = 25;

// -----------------------------------------------------------------------
// HRESULT: Common success codes
// -----------------------------------------------------------------------

const HResult S_OK           = 0x00000000;  // Success
const HResult S_FALSE        = 0x00000001;  // Success (alternate)

// -----------------------------------------------------------------------
// HRESULT: Common error codes
// -----------------------------------------------------------------------

const HResult E_UNEXPECTED        = (HResult)0x8000FFFF;  // Unexpected failure
const HResult E_NOTIMPL           = (HResult)0x80004001;  // Not implemented
const HResult E_OUTOFMEMORY       = (HResult)0x8007000E;  // Out of memory
const HResult E_INVALIDARG        = (HResult)0x80070057;  // Invalid argument
const HResult E_NOINTERFACE       = (HResult)0x80004002;  // Interface not supported
const HResult E_POINTER           = (HResult)0x80004003;  // Invalid pointer
const HResult E_HANDLE            = (HResult)0x80070006;  // Invalid handle
const HResult E_ABORT             = (HResult)0x80004004;  // Operation aborted
const HResult E_FAIL              = (HResult)0x80004005;  // Unspecified failure
const HResult E_ACCESSDENIED      = (HResult)0x80070005;  // Access denied

// CO error codes
const HResult CO_E_NOTINITIALIZED        = (HResult)0x800401F0;  // CoInitialize not called
const HResult CO_E_ALREADYINITIALIZED    = (HResult)0x800401F1;  // Already initialized
const HResult CO_E_CANTDETERMINECLASS    = (HResult)0x800401F2;  // Class cannot be determined
const HResult CO_E_CLASSSTRING           = (HResult)0x800401F3;  // Invalid class string
const HResult CO_E_IIDSTRING             = (HResult)0x800401F4;  // Invalid interface ID string
const HResult CO_E_APPNOTFOUND           = (HResult)0x800401F5;  // Application not found
const HResult CO_E_APPSINGLEUSE          = (HResult)0x800401F6;  // App is single use
const HResult CO_E_ERRORINAPP            = (HResult)0x800401F7;  // Error in application
const HResult CO_E_DLLNOTFOUND           = (HResult)0x800401F8;  // DLL not found
const HResult CO_E_ERRORINDLL            = (HResult)0x800401F9;  // Error in DLL
const HResult CO_E_WRONGOSFORAPP         = (HResult)0x800401FA;  // OS version mismatch
const HResult CO_E_OBJNOTREG             = (HResult)0x800401FB;  // Object not registered
const HResult CO_E_OBJISREG              = (HResult)0x800401FC;  // Object already registered
const HResult CO_E_OBJNOTCONNECTED       = (HResult)0x800401FD;  // Object not connected
const HResult CO_E_APPDIDNTREG           = (HResult)0x800401FE;  // App did not register
const HResult CO_E_RELEASED              = (HResult)0x800401FF;  // Object has been released

// REGDB error codes
const HResult REGDB_E_CLASSNOTREG        = (HResult)0x80040154;  // CLSID not registered
const HResult REGDB_E_IIDNOTREG          = (HResult)0x80040155;  // IID not registered
const HResult REGDB_E_BADTHREADINGMODEL  = (HResult)0x80040150;  // Threading model mismatch

// CLASS error codes
const HResult CLASS_E_NOAGGREGATION      = (HResult)0x80040110;  // Aggregation not supported
const HResult CLASS_E_CLASSNOTAVAILABLE  = (HResult)0x80040111;  // DLL does not support CLSID
const HResult CLASS_E_NOTLICENSED        = (HResult)0x80040112;  // License check failed

// -----------------------------------------------------------------------
// HRESULT helper macros (as inline functions)
// -----------------------------------------------------------------------

fn bool succeeded(HResult hr) @inline {
    return hr >= 0;
}

fn bool failed(HResult hr) @inline {
    return hr < 0;
}

fn bool isError(HResult hr) @inline {
    return hr < 0;
}

fn int hresultCode(HResult hr) @inline {
    return hr & 0xFFFF;
}

fn int hresultFacility(HResult hr) @inline {
    return (hr >> 16) & 0x1FFF;
}

fn int hresultSeverity(HResult hr) @inline {
    return (hr >> 31) & 0x1;
}

fn HResult makeHresult(int sev, int fac, int code) @inline {
    return (HResult)((sev << 31) | (fac << 16) | code);
}

fn HResult hresultFromWin32(ulong x) @inline {
    return x != 0 ? (HResult)(x & 0x0000FFFF) | (FACILITY_WIN32 << 16) | (HResult)0x80000000 : S_OK;
}

// -----------------------------------------------------------------------
// CoInitialize flags (COINIT)
// -----------------------------------------------------------------------

const DWord COINIT_APARTMENTTHREADED = 0x2;   // Single-threaded apartment (STA)
const DWord COINIT_MULTITHREADED     = 0x0;   // Multi-threaded apartment (MTA)
const DWord COINIT_DISABLE_OLE1DDE   = 0x4;   // Disable OLE 1.0 DDE support
const DWord COINIT_SPEED_OVER_MEMORY = 0x8;   // Trade memory for speed

// -----------------------------------------------------------------------
// CLSCTX: Class context flags for CoCreateInstance
// -----------------------------------------------------------------------

const DWord CLSCTX_INPROC_SERVER         = 0x1;    // In-process server (DLL)
const DWord CLSCTX_INPROC_HANDLER        = 0x2;    // In-process handler (DLL)
const DWord CLSCTX_LOCAL_SERVER          = 0x4;    // Local out-of-process server (.exe)
const DWord CLSCTX_INPROC_SERVER16       = 0x8;    // 16-bit in-process server (legacy)
const DWord CLSCTX_REMOTE_SERVER         = 0x10;   // Remote server (DCOM)
const DWord CLSCTX_INPROC_HANDLER16      = 0x20;   // 16-bit in-process handler (legacy)
const DWord CLSCTX_RESERVED1            = 0x40;
const DWord CLSCTX_RESERVED2            = 0x80;
const DWord CLSCTX_RESERVED3            = 0x100;
const DWord CLSCTX_RESERVED4            = 0x200;
const DWord CLSCTX_NO_CODE_DOWNLOAD      = 0x400;  // Disable code download
const DWord CLSCTX_RESERVED5            = 0x800;
const DWord CLSCTX_NO_CUSTOM_MARSHAL     = 0x1000; // Disable custom marshal
const DWord CLSCTX_ENABLE_CODE_DOWNLOAD  = 0x2000; // Enable code download
const DWord CLSCTX_NO_FAILURE_LOG        = 0x4000; // Suppress activation failure log
const DWord CLSCTX_DISABLE_AAA           = 0x8000; // Disable Activate-As-Activator
const DWord CLSCTX_ENABLE_AAA            = 0x10000; // Enable Activate-As-Activator
const DWord CLSCTX_FROM_DEFAULT_CONTEXT  = 0x20000; // Activate from default context
const DWord CLSCTX_ACTIVATE_X86_SERVER   = 0x40000; // Force x86 server
const DWord CLSCTX_ACTIVATE_64_BIT_SERVER = 0x80000; // Force 64-bit server
const DWord CLSCTX_ENABLE_CLOAKING       = 0x100000; // Enable cloaking
const DWord CLSCTX_APPCONTAINER          = 0x400000; // AppContainer activation
const DWord CLSCTX_ACTIVATE_AAA_AS_IU    = 0x800000; // Activate AAA as interactive user
const DWord CLSCTX_PS_DLL               = (DWord)0x80000000; // Reserved for PS DLL

// Convenience groupings
const DWord CLSCTX_INPROC   = CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER;
const DWord CLSCTX_SERVER   = CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER;
const DWord CLSCTX_ALL      = CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER;

// -----------------------------------------------------------------------
// REGCLS: Class registration flags
// -----------------------------------------------------------------------

const DWord REGCLS_SINGLEUSE         = 0x0;  // Single instance per registration
const DWord REGCLS_MULTIPLEUSE       = 0x1;  // Multiple instances per registration
const DWord REGCLS_MULTI_SEPARATE    = 0x2;  // Multiple instances, separate
const DWord REGCLS_SUSPENDED         = 0x4;  // Register as suspended
const DWord REGCLS_SURROGATE         = 0x8;  // Register as surrogate

// -----------------------------------------------------------------------
// MSHLFLAGS: Marshaling flags
// -----------------------------------------------------------------------

const DWord MSHLFLAGS_NORMAL      = 0x0;  // Normal marshal
const DWord MSHLFLAGS_TABLESTRONG = 0x1;  // Table-strong marshal
const DWord MSHLFLAGS_TABLEWEAK   = 0x2;  // Table-weak marshal
const DWord MSHLFLAGS_NOPING      = 0x4;  // No ping

// -----------------------------------------------------------------------
// MSHCTX: Marshaling context
// -----------------------------------------------------------------------

const DWord MSHCTX_LOCAL          = 0;  // Unmarshal in same machine different process
const DWord MSHCTX_NOSHAREDMEM    = 1;  // No shared memory
const DWord MSHCTX_DIFFERENTMACHINE = 2; // Unmarshal on different machine
const DWord MSHCTX_INPROC         = 3;  // Unmarshal in same process
const DWord MSHCTX_CROSSCTX       = 4;  // Unmarshal in different context

// -----------------------------------------------------------------------
// DVASPECT: Data/view aspect
// -----------------------------------------------------------------------

const DWord DVASPECT_CONTENT   = 1;   // Full content
const DWord DVASPECT_THUMBNAIL = 2;   // Thumbnail
const DWord DVASPECT_ICON      = 4;   // Icon
const DWord DVASPECT_DOCPRINT  = 8;   // Printed document

// -----------------------------------------------------------------------
// STGC: Storage commit flags
// -----------------------------------------------------------------------

const DWord STGC_DEFAULT          = 0x0;
const DWord STGC_OVERWRITE        = 0x1;
const DWord STGC_ONLYIFCURRENT    = 0x2;
const DWord STGC_DANGEROUSLYCOMMITMERELYTODISKCACHE = 0x4;
const DWord STGC_CONSOLIDATE      = 0x8;

// -----------------------------------------------------------------------
// STGMOVE: Storage move flags
// -----------------------------------------------------------------------

const DWord STGMOVE_MOVE  = 0;
const DWord STGMOVE_COPY  = 1;
const DWord STGMOVE_SHALLOWCOPY = 2;

// -----------------------------------------------------------------------
// IUnknown virtual table and interface
// -----------------------------------------------------------------------

// IUnknown vtable (function pointer layout)
// C3 does not have COM vtable sugar; represent as explicit struct of fn pointers
interface IUnknownVtbl {
    fn HResult queryInterface(void*, RefIid, void**);  // QueryInterface
    fn DWord addRef(void*);           // AddRef
    fn DWord release(void*);           // Release
}

struct IUnknown {
    IUnknownVtbl* vtbl;
}

// -----------------------------------------------------------------------
// IClassFactory virtual table and interface
// -----------------------------------------------------------------------

interface IClassFactoryVtbl {
    // IUnknown methods
    fn HResult queryInterface(void*, RefIid, void**);
    fn DWord addRef(void*);
    fn DWord release(void*);
    // IClassFactory methods
    fn HResult createInstance(void*, IUnknown*, RefIid, void**);  // CreateInstance
    fn HResult lockServer(void*, Bool);       // LockServer
}

struct IClassFactory {
    IClassFactoryVtbl* vtbl;
}

// -----------------------------------------------------------------------
// IMalloc virtual table and interface
// -----------------------------------------------------------------------

interface IMallocVtbl {
    // IUnknown methods
    fn HResult queryInterface(void*, RefIid, void**);
    fn DWord addRef(void*);
    fn DWord release(void*);
    // IMalloc methods
    fn void* alloc(void*, ulong);    // Alloc
    fn void* realloc(void*, void*, ulong); // Realloc
    fn void free(void*, void*);     // Free
    fn ulong getSize(void*, void*); // GetSize
    fn int didAlloc(void*, void*); // DidAlloc
    fn void heapMinimize(void*); // HeapMinimize
}

struct IMalloc {
    IMallocVtbl* vtbl;
}

// -----------------------------------------------------------------------
// COM Initialization / Uninitialization
// -----------------------------------------------------------------------

extern fn HResult coInitialize(void* pvreserved)                     @cname("CoInitialize");
extern fn HResult coInitializeEx(void* pvreserved, DWord coinit)     @cname("CoInitializeEx");
extern fn void    coUninitialize()                                   @cname("CoUninitialize");

// -----------------------------------------------------------------------
// COM Class / Instance Creation
// -----------------------------------------------------------------------

extern fn HResult coCreateInstance(
    RefClsid   rclsid,       // CLSID of object to create
    IUnknown*  punkouter,    // Aggregate's controlling IUnknown (or null)
    DWord      dwclscontext, // Context (CLSCTX_*)
    RefIid     riid,         // Desired interface IID
    void**     ppv           // Out: pointer to interface
) @cname("CoCreateInstance");

extern fn HResult coCreateInstanceEx(
    RefClsid          rclsid,
    IUnknown*         punkouter,
    DWord             dwclscontext,
    void*             pserverinfo,  // COSERVERINFO* (DCOM)
    DWord             dwcount,
    void*             presults     // MULTI_QI*
) @cname("CoCreateInstanceEx");

extern fn HResult coGetClassObject(
    RefClsid   rclsid,
    DWord      dwclscontext,
    void*      pserverinfo,
    RefIid     riid,
    void**     ppv
) @cname("CoGetClassObject");

// -----------------------------------------------------------------------
// COM Registration
// -----------------------------------------------------------------------

extern fn HResult coRegisterClassObject(
    RefClsid     rclsid,
    IUnknown*    punk,
    DWord        dwclscontext,
    DWord        flags,
    DWord*       lpdwregister
) @cname("CoRegisterClassObject");

extern fn HResult coRevokeClassObject(DWord dwregister) @cname("CoRevokeClassObject");

extern fn HResult coRegisterPSClsid(RefIid riid, RefClsid rclsid) @cname("CoRegisterPSClsid");
extern fn HResult coGetPSClsid(RefIid riid, Clsid* pclsid)        @cname("CoGetPSClsid");

// -----------------------------------------------------------------------
// COM Memory Allocation (task allocator)
// -----------------------------------------------------------------------

extern fn void*   coTaskMemAlloc(ulong cb)            @cname("CoTaskMemAlloc");
extern fn void*   coTaskMemRealloc(void* pv, ulong cb) @cname("CoTaskMemRealloc");
extern fn void    coTaskMemFree(void* pv)             @cname("CoTaskMemFree");
extern fn HResult coGetMalloc(DWord dwmemcontext, IMalloc** ppmalloc) @cname("CoGetMalloc");

// -----------------------------------------------------------------------
// COM Marshaling
// -----------------------------------------------------------------------

extern fn HResult coMarshalInterface(
    void*      pstm,        // IStream*
    RefIid     riid,
    IUnknown*  punk,
    DWord      dwdestcontext,
    void*      pvdestcontext,
    DWord      mshlflags
) @cname("CoMarshalInterface");

extern fn HResult coUnmarshalInterface(
    void*   pstm,           // IStream*
    RefIid  riid,
    void**  ppv
) @cname("CoUnmarshalInterface");

extern fn HResult coReleaseMarshalData(void* pstm) @cname("CoReleaseMarshalData");

extern fn HResult coMarshalInterThreadInterfaceInStream(
    RefIid    riid,
    IUnknown* punk,
    void**    ppstm         // IStream**
) @cname("CoMarshalInterThreadInterfaceInStream");

extern fn HResult coGetInterfaceAndReleaseStream(
    void*   pstm,           // IStream*
    RefIid  riid,
    void**  ppv
) @cname("CoGetInterfaceAndReleaseStream");

// -----------------------------------------------------------------------
// COM GUID Utilities
// -----------------------------------------------------------------------

extern fn HResult coCreateGuid(Guid* pguid)        @cname("CoCreateGuid");
extern fn Bool isEqualGUID(RefGuid rguid1, RefGuid rguid2) @cname("IsEqualGUID");
extern fn Bool isEqualCLSID(RefClsid rclsid1, RefClsid rclsid2) @cname("IsEqualCLSID");
extern fn Bool isEqualIID(RefIid riid1, RefIid riid2) @cname("IsEqualIID");

extern fn HResult stringFromCLSID(RefClsid rclsid, LPWStr* lplpsz)  @cname("StringFromCLSID");
extern fn HResult clsidFromString(LPCWStr lpsz, Clsid* pclsid)      @cname("CLSIDFromString");
extern fn HResult stringFromIID(RefIid rclsid, LPWStr* lplpsz)      @cname("StringFromIID");
extern fn HResult iidFromString(LPCWStr lpsz, Iid* lpiid)           @cname("IIDFromString");
extern fn int     stringFromGUID2(RefGuid rguid, LPWStr lpsz, int cbmax) @cname("StringFromGUID2");

// -----------------------------------------------------------------------
// COM Miscellaneous
// -----------------------------------------------------------------------

extern fn HResult coGetCurrentProcess(DWord* lpdwpid)  @cname("CoGetCurrentProcess");
extern fn HResult coQueryProxyBlanket(
    IUnknown* pproxy,
    uint*     pwauthnsvc,
    uint*     pauthzsvc,
    WChar**   pserverprincname,
    uint*     pauthnlevel,
    uint*     pimplevel,
    void**    pauthinfo,
    DWord*    pcapabilities
) @cname("CoQueryProxyBlanket");

extern fn HResult coSetProxyBlanket(
    IUnknown* pproxy,
    uint      dwauthnSvc,
    uint      dwAuthzSvc,
    WChar*    pServerPrincName,
    uint      dwAuthnLevel,
    uint      dwImpLevel,
    void*     pAuthInfo,
    DWord     dwCapabilities
) @cname("CoSetProxyBlanket");

extern fn HResult coQueryClientBlanket(
    uint*   pauthnSvc,
    uint*   pauthzSvc,
    WChar** pServerPrincName,
    uint*   pAuthnLevel,
    uint*   pImpLevel,
    void**  pPrivs,
    DWord*  pCapabilities
) @cname("CoQueryClientBlanket");

extern fn HResult coImpersonateClient()    @cname("CoImpersonateClient");
extern fn HResult coRevertToSelf()         @cname("CoRevertToSelf");

extern fn HResult coLockObjectExternal(
    IUnknown* punk,
    Bool   flock,
    Bool   flastunlockreleases
) @cname("CoLockObjectExternal");

extern fn Bool coIsHandlerConnected(IUnknown* punk) @cname("CoIsHandlerConnected");

extern fn HResult coFreeUnusedLibraries()               @cname("CoFreeUnusedLibraries");
extern fn void    coFreeUnusedLibrariesEx(DWord dwunloaddelay, DWord dwreserved) @cname("CoFreeUnusedLibrariesEx");

// -----------------------------------------------------------------------
// COM Library loading
// -----------------------------------------------------------------------

// DllGetClassObject / DllCanUnloadNow: exported from COM server DLLs
// (not called directly; invoked by COM runtime)
// alias ppv) = fn HResult DllGetClassObjectFn(RefClsid rclsid, RefIid riid, void**;
// alias DllCanUnloadNowFn() = fn HResult;
