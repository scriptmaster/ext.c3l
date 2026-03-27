// processthreadapi.h.c3

module c::processthreadapi @if(env::WIN32);

// Windows Process and Thread API
// C3 mapping for processthreadapi.h

// Common Windows types
alias Handle = void*;
alias DWord = uint;
alias Bool = int;
alias Word = ushort;
alias Byte = char;
alias Long = int;
alias ULong = uint;
alias LongPtr = iptr;
alias ULongPtr = uptr;
alias PVoid = void*;
alias Size = ulong;

// Process creation flags
const uint DEBUG_PROCESS = 0x00000001;
const uint DEBUG_ONLY_THIS_PROCESS = 0x00000002;
const uint CREATE_SUSPENDED = 0x00000004;
const uint DETACHED_PROCESS = 0x00000008;
const uint CREATE_NEW_CONSOLE = 0x00000010;
const uint NORMAL_PRIORITY_CLASS = 0x00000020;
const uint IDLE_PRIORITY_CLASS = 0x00000040;
const uint HIGH_PRIORITY_CLASS = 0x00000080;
const uint REALTIME_PRIORITY_CLASS = 0x00000100;
const uint CREATE_NEW_PROCESS_GROUP = 0x00000200;
const uint CREATE_UNICODE_ENVIRONMENT = 0x00000400;
const uint CREATE_SEPARATE_WOW_VDM = 0x00000800;
const uint CREATE_SHARED_WOW_VDM = 0x00001000;
const uint CREATE_FORCEDOS = 0x00002000;
const uint BELOW_NORMAL_PRIORITY_CLASS = 0x00004000;
const uint ABOVE_NORMAL_PRIORITY_CLASS = 0x00008000;
const uint INHERIT_PARENT_AFFINITY = 0x00010000;
const uint INHERIT_CALLER_PRIORITY = 0x00020000;
const uint CREATE_PROTECTED_PROCESS = 0x00040000;
const uint EXTENDED_STARTUPINFO_PRESENT = 0x00080000;
const uint PROCESS_MODE_BACKGROUND_BEGIN = 0x00100000;
const uint PROCESS_MODE_BACKGROUND_END = 0x00200000;
const uint CREATE_SECURE_PROCESS = 0x00400000;
const uint CREATE_BREAKAWAY_FROM_JOB = 0x01000000;
const uint CREATE_PRESERVE_CODE_AUTHZ_LEVEL = 0x02000000;
const uint CREATE_DEFAULT_ERROR_MODE = 0x04000000;
const uint CREATE_NO_WINDOW = 0x08000000;
const uint PROFILE_USER = 0x10000000;
const uint PROFILE_KERNEL = 0x20000000;
const uint PROFILE_SERVER = 0x40000000;
const uint CREATE_IGNORE_SYSTEM_DEFAULT = 0x80000000;

// Thread creation flags
const uint STACK_SIZE_PARAM_IS_A_RESERVATION = 0x00010000;

// Thread priority values
const int THREAD_PRIORITY_LOWEST = -2;
const int THREAD_PRIORITY_BELOW_NORMAL = -1;
const int THREAD_PRIORITY_NORMAL = 0;
const int THREAD_PRIORITY_HIGHEST = 2;
const int THREAD_PRIORITY_ABOVE_NORMAL = 1;
const int THREAD_PRIORITY_ERROR_RETURN = 0x7FFFFFFF;
const int THREAD_PRIORITY_TIME_CRITICAL = 15;
const int THREAD_PRIORITY_IDLE = -15;

// Thread access rights
const uint THREAD_TERMINATE = 0x0001;
const uint THREAD_SUSPEND_RESUME = 0x0002;
const uint THREAD_GET_CONTEXT = 0x0008;
const uint THREAD_SET_CONTEXT = 0x0010;
const uint THREAD_QUERY_INFORMATION = 0x0040;
const uint THREAD_SET_INFORMATION = 0x0020;
const uint THREAD_SET_THREAD_TOKEN = 0x0080;
const uint THREAD_IMPERSONATE = 0x0100;
const uint THREAD_DIRECT_IMPERSONATION = 0x0200;
const uint THREAD_SET_LIMITED_INFORMATION = 0x0400;
const uint THREAD_QUERY_LIMITED_INFORMATION = 0x0800;
const uint THREAD_RESUME = 0x1000;
const uint THREAD_ALL_ACCESS = 0x001FFFFF;

// Process access rights
const uint PROCESS_TERMINATE = 0x0001;
const uint PROCESS_CREATE_THREAD = 0x0002;
const uint PROCESS_SET_SESSIONID = 0x0004;
const uint PROCESS_VM_OPERATION = 0x0008;
const uint PROCESS_VM_READ = 0x0010;
const uint PROCESS_VM_WRITE = 0x0020;
const uint PROCESS_DUP_HANDLE = 0x0040;
const uint PROCESS_CREATE_PROCESS = 0x0080;
const uint PROCESS_SET_QUOTA = 0x0100;
const uint PROCESS_SET_INFORMATION = 0x0200;
const uint PROCESS_QUERY_INFORMATION = 0x0400;
const uint PROCESS_SUSPEND_RESUME = 0x0800;
const uint PROCESS_QUERY_LIMITED_INFORMATION = 0x1000;
const uint PROCESS_SET_LIMITED_INFORMATION = 0x2000;
const uint PROCESS_ALL_ACCESS = 0x001FFFFF;

// Startup info flags
const uint STARTF_USESHOWWINDOW = 0x00000001;
const uint STARTF_USESIZE = 0x00000002;
const uint STARTF_USEPOSITION = 0x00000004;
const uint STARTF_USECOUNTCHARS = 0x00000008;
const uint STARTF_USEFILLATTRIBUTE = 0x00000010;
const uint STARTF_RUNFULLSCREEN = 0x00000020;
const uint STARTF_FORCEONFEEDBACK = 0x00000040;
const uint STARTF_FORCEOFFFEEDBACK = 0x00000080;
const uint STARTF_USESTDHANDLES = 0x00000100;
const uint STARTF_USEHOTKEY = 0x00000200;
const uint STARTF_TITLEISLINKNAME = 0x00000800;
const uint STARTF_TITLEISAPPID = 0x00001000;
const uint STARTF_PREVENTPINNING = 0x00002000;
const uint STARTF_UNTRUSTEDSOURCE = 0x00008000;

// Structures
struct SecurityAttributes {
    DWord length;
    PVoid securityDescriptor;
    Bool inheritHandle;
}

struct ProcessInformation {
    Handle process;
    Handle thread;
    DWord processId;
    DWord threadId;
}

struct Coord {
    short x;
    short y;
}

struct StartupInfoA {
    DWord cb;
    char* reserved;
    char* desktop;
    char* title;
    DWord x;
    DWord y;
    DWord xSize;
    DWord ySize;
    DWord xCountChars;
    DWord yCountChars;
    DWord fillAttribute;
    DWord flags;
    Word showWindow;
    Word cbReserved2;
    Byte* lpReserved2;
    Handle stdInput;
    Handle stdOutput;
    Handle stdError;
}

struct StartupInfoW {
    DWord cb;
    short* reserved;
    short* desktop;
    short* title;
    DWord x;
    DWord y;
    DWord xSize;
    DWord ySize;
    DWord xCountChars;
    DWord yCountChars;
    DWord fillAttribute;
    DWord flags;
    Word showWindow;
    Word cbReserved2;
    Byte* lpReserved2;
    Handle stdInput;
    Handle stdOutput;
    Handle stdError;
}

struct ProcessMemoryCounters {
    DWord cb;
    DWord pageFaultCount;
    Size peakWorkingSetSize;
    Size workingSetSize;
    Size quotaPeakPagedPoolUsage;
    Size quotaPagedPoolUsage;
    Size quotaPeakNonPagedPoolUsage;
    Size quotaNonPagedPoolUsage;
    Size pagefileUsage;
    Size peakPagefileUsage;
}

struct ProcessMemoryCountersEx {
    DWord cb;
    DWord pageFaultCount;
    Size peakWorkingSetSize;
    Size workingSetSize;
    Size quotaPeakPagedPoolUsage;
    Size quotaPagedPoolUsage;
    Size quotaPeakNonPagedPoolUsage;
    Size quotaNonPagedPoolUsage;
    Size pagefileUsage;
    Size peakPagefileUsage;
    Size privateUsage;
}

// Thread callback type
alias ThreadStartRoutine = fn DWord(PVoid);

// Process and Thread Functions
extern fn Bool createProcessA(
    char* applicationName,
    char* commandLine,
    SecurityAttributes* processAttributes,
    SecurityAttributes* threadAttributes,
    Bool inheritHandles,
    DWord creationFlags,
    PVoid environment,
    char* currentDirectory,
    StartupInfoA* startupInfo,
    ProcessInformation* processInformation
) @cname("CreateProcessA");

extern fn Bool createProcessW(
    short* applicationName,
    short* commandLine,
    SecurityAttributes* processAttributes,
    SecurityAttributes* threadAttributes,
    Bool inheritHandles,
    DWord creationFlags,
    PVoid environment,
    short* currentDirectory,
    StartupInfoW* startupInfo,
    ProcessInformation* processInformation
) @cname("CreateProcessW");

extern fn Handle createThread(
    SecurityAttributes* threadAttributes,
    Size stackSize,
    ThreadStartRoutine startAddress,
    PVoid parameter,
    DWord creationFlags,
    DWord* threadId
) @cname("CreateThread");

extern fn Handle createRemoteThread(
    Handle process,
    SecurityAttributes* threadAttributes,
    Size stackSize,
    ThreadStartRoutine startAddress,
    PVoid parameter,
    DWord creationFlags,
    DWord* threadId
) @cname("CreateRemoteThread");

extern fn Handle getCurrentProcess() @cname("GetCurrentProcess");

extern fn DWord getCurrentProcessId() @cname("GetCurrentProcessId");

extern fn Handle getCurrentThread() @cname("GetCurrentThread");

extern fn DWord getCurrentThreadId() @cname("GetCurrentThreadId");

extern fn Bool terminateProcess(Handle process, uint exitCode) @cname("TerminateProcess");

extern fn Bool terminateThread(Handle thread, DWord exitCode) @cname("TerminateThread");

extern fn DWord suspendThread(Handle thread) @cname("SuspendThread");

extern fn DWord resumeThread(Handle thread) @cname("ResumeThread");

extern fn void exitProcess(uint exitCode) @cname("ExitProcess");

extern fn void exitThread(DWord exitCode) @cname("ExitThread");

extern fn Bool getExitCodeProcess(Handle process, DWord* exitCode) @cname("GetExitCodeProcess");

extern fn Bool getExitCodeThread(Handle thread, DWord* exitCode) @cname("GetExitCodeThread");

extern fn Handle openProcess(DWord desiredAccess, Bool inheritHandle, DWord processId) @cname("OpenProcess");

extern fn Handle openThread(DWord desiredAccess, Bool inheritHandle, DWord threadId) @cname("OpenThread");

extern fn Bool setPriorityClass(Handle process, DWord priorityClass) @cname("SetPriorityClass");

extern fn DWord getPriorityClass(Handle process) @cname("GetPriorityClass");

extern fn Bool setThreadPriority(Handle thread, int priority) @cname("SetThreadPriority");

extern fn int getThreadPriority(Handle thread) @cname("GetThreadPriority");

extern fn Bool getProcessTimes(
    Handle process,
    void* creationTime,
    void* exitTime,
    void* kernelTime,
    void* userTime
) @cname("GetProcessTimes");

extern fn Bool getThreadTimes(
    Handle thread,
    void* creationTime,
    void* exitTime,
    void* kernelTime,
    void* userTime
) @cname("GetThreadTimes");

extern fn DWord getProcessId(Handle process) @cname("GetProcessId");

extern fn DWord getThreadId(Handle thread) @cname("GetThreadId");

extern fn DWord getProcessIdOfThread(Handle thread) @cname("GetProcessIdOfThread");

extern fn Bool getProcessHandleCount(Handle process, DWord* handleCount) @cname("GetProcessHandleCount");

extern fn ULongPtr setThreadAffinityMask(Handle thread, ULongPtr threadAffinityMask) @cname("SetThreadAffinityMask");

extern fn Bool setProcessAffinityMask(Handle process, ULongPtr processAffinityMask) @cname("SetProcessAffinityMask");

extern fn Bool getProcessAffinityMask(
    Handle process,
    ULongPtr* processAffinityMask,
    ULongPtr* systemAffinityMask
) @cname("GetProcessAffinityMask");

extern fn DWord waitForSingleObject(Handle handle, DWord milliseconds) @cname("WaitForSingleObject");

extern fn DWord waitForMultipleObjects(
    DWord count,
    Handle* handles,
    Bool waitAll,
    DWord milliseconds
) @cname("WaitForMultipleObjects");

extern fn void sleep(DWord milliseconds) @cname("Sleep");

extern fn Bool switchToThread() @cname("SwitchToThread");

extern fn DWord tlsAlloc() @cname("TlsAlloc");

extern fn Bool tlsFree(DWord tlsIndex) @cname("TlsFree");

extern fn PVoid tlsGetValue(DWord tlsIndex) @cname("TlsGetValue");

extern fn Bool tlsSetValue(DWord tlsIndex, PVoid tlsValue) @cname("TlsSetValue");

extern fn Bool isProcessorFeaturePresent(DWord processorFeature) @cname("IsProcessorFeaturePresent");

extern fn void getCurrentProcessorNumber() @cname("GetCurrentProcessorNumber");

extern fn Bool getProcessMemoryInfo(
    Handle process,
    ProcessMemoryCounters* counters,
    DWord cb
) @cname("GetProcessMemoryInfo");

extern fn Bool setProcessWorkingSetSize(
    Handle process,
    Size minimumWorkingSetSize,
    Size maximumWorkingSetSize
) @cname("SetProcessWorkingSetSize");

extern fn Bool getProcessWorkingSetSize(
    Handle process,
    Size* minimumWorkingSetSize,
    Size* maximumWorkingSetSize
) @cname("GetProcessWorkingSetSize");

extern fn Bool flushProcessWriteBuffers() @cname("FlushProcessWriteBuffers");

extern fn DWord getProcessVersion(DWord processId) @cname("GetProcessVersion");

extern fn Bool setThreadIdealProcessor(Handle thread, DWord idealProcessor) @cname("SetThreadIdealProcessor");

extern fn DWord setThreadIdealProcessorEx(
    Handle thread,
    void* idealProcessor,
    void* previousIdealProcessor
) @cname("SetThreadIdealProcessorEx");

extern fn Bool getThreadIdealProcessorEx(Handle thread, void* idealProcessor) @cname("GetThreadIdealProcessorEx");

extern fn void getStartupInfoA(StartupInfoA* startupInfo) @cname("GetStartupInfoA");

extern fn void getStartupInfoW(StartupInfoW* startupInfo) @cname("GetStartupInfoW");

extern fn Bool createProcessAsUserA(
    Handle token,
    char* applicationName,
    char* commandLine,
    SecurityAttributes* processAttributes,
    SecurityAttributes* threadAttributes,
    Bool inheritHandles,
    DWord creationFlags,
    PVoid environment,
    char* currentDirectory,
    StartupInfoA* startupInfo,
    ProcessInformation* processInformation
) @cname("CreateProcessAsUserA");

extern fn Bool createProcessAsUserW(
    Handle token,
    short* applicationName,
    short* commandLine,
    SecurityAttributes* processAttributes,
    SecurityAttributes* threadAttributes,
    Bool inheritHandles,
    DWord creationFlags,
    PVoid environment,
    short* currentDirectory,
    StartupInfoW* startupInfo,
    ProcessInformation* processInformation
) @cname("CreateProcessAsUserW");

extern fn DWord queueUserApc(void* apcFunc, Handle thread, ULongPtr data) @cname("QueueUserAPC");

extern fn Bool getThreadIoPendingFlag(Handle thread, Bool* ioIsPending) @cname("GetThreadIOPendingFlag");

extern fn DWord getThreadErrorMode() @cname("GetThreadErrorMode");

extern fn Bool setThreadErrorMode(DWord newMode, DWord* oldMode) @cname("SetThreadErrorMode");

extern fn Bool setThreadStackGuarantee(ULong* stackSizeInBytes) @cname("SetThreadStackGuarantee");

extern fn DWord setThreadDescription(Handle thread, short* threadDescription) @cname("SetThreadDescription");

extern fn DWord getThreadDescription(Handle thread, short** threadDescription) @cname("GetThreadDescription");

// Process/Thread attribute list functions
extern fn Bool initializeProcThreadAttributeList(
    void* attributeList,
    DWord attributeCount,
    DWord flags,
    Size* size
) @cname("InitializeProcThreadAttributeList");

extern fn void deleteProcThreadAttributeList(void* attributeList) @cname("DeleteProcThreadAttributeList");

extern fn Bool updateProcThreadAttribute(
    void* attributeList,
    DWord flags,
    ULongPtr attribute,
    PVoid value,
    Size size,
    PVoid previousValue,
    Size* returnSize
) @cname("UpdateProcThreadAttribute");

// Constants for WAIT functions
const uint INFINITE = 0xFFFFFFFF;
const uint WAIT_ABANDONED = 0x00000080;
const uint WAIT_OBJECT_0 = 0x00000000;
const uint WAIT_TIMEOUT = 0x00000102;
const uint WAIT_FAILED = 0xFFFFFFFF;

// TLS constants
const uint TLS_OUT_OF_INDEXES = 0xFFFFFFFF;
