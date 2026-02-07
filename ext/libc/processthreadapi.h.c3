module processthreadapi @if(env::WIN32);

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
    PVoid security_descriptor;
    Bool inherit_handle;
}

struct ProcessInformation {
    Handle process;
    Handle thread;
    DWord process_id;
    DWord thread_id;
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
    DWord x_size;
    DWord y_size;
    DWord x_count_chars;
    DWord y_count_chars;
    DWord fill_attribute;
    DWord flags;
    Word show_window;
    Word cb_reserved2;
    Byte* lp_reserved2;
    Handle std_input;
    Handle std_output;
    Handle std_error;
}

struct StartupInfoW {
    DWord cb;
    short* reserved;
    short* desktop;
    short* title;
    DWord x;
    DWord y;
    DWord x_size;
    DWord y_size;
    DWord x_count_chars;
    DWord y_count_chars;
    DWord fill_attribute;
    DWord flags;
    Word show_window;
    Word cb_reserved2;
    Byte* lp_reserved2;
    Handle std_input;
    Handle std_output;
    Handle std_error;
}

struct ProcessMemoryCounters {
    DWord cb;
    DWord page_fault_count;
    Size peak_working_set_size;
    Size working_set_size;
    Size quota_peak_paged_pool_usage;
    Size quota_paged_pool_usage;
    Size quota_peak_non_paged_pool_usage;
    Size quota_non_paged_pool_usage;
    Size pagefile_usage;
    Size peak_pagefile_usage;
}

struct ProcessMemoryCountersEx {
    DWord cb;
    DWord page_fault_count;
    Size peak_working_set_size;
    Size working_set_size;
    Size quota_peak_paged_pool_usage;
    Size quota_paged_pool_usage;
    Size quota_peak_non_paged_pool_usage;
    Size quota_non_paged_pool_usage;
    Size pagefile_usage;
    Size peak_pagefile_usage;
    Size private_usage;
}

// Thread callback type
alias ThreadStartRoutine = fn DWord(PVoid);

// Process and Thread Functions
extern fn Bool create_process_a(
    char* application_name,
    char* command_line,
    SecurityAttributes* process_attributes,
    SecurityAttributes* thread_attributes,
    Bool inherit_handles,
    DWord creation_flags,
    PVoid environment,
    char* current_directory,
    StartupInfoA* startup_info,
    ProcessInformation* process_information
) @cname("CreateProcessA");

extern fn Bool create_process_w(
    short* application_name,
    short* command_line,
    SecurityAttributes* process_attributes,
    SecurityAttributes* thread_attributes,
    Bool inherit_handles,
    DWord creation_flags,
    PVoid environment,
    short* current_directory,
    StartupInfoW* startup_info,
    ProcessInformation* process_information
) @cname("CreateProcessW");

extern fn Handle create_thread(
    SecurityAttributes* thread_attributes,
    Size stack_size,
    ThreadStartRoutine start_address,
    PVoid parameter,
    DWord creation_flags,
    DWord* thread_id
) @cname("CreateThread");

extern fn Handle create_remote_thread(
    Handle process,
    SecurityAttributes* thread_attributes,
    Size stack_size,
    ThreadStartRoutine start_address,
    PVoid parameter,
    DWord creation_flags,
    DWord* thread_id
) @cname("CreateRemoteThread");

extern fn Handle get_current_process() @cname("GetCurrentProcess");

extern fn DWord get_current_process_id() @cname("GetCurrentProcessId");

extern fn Handle get_current_thread() @cname("GetCurrentThread");

extern fn DWord get_current_thread_id() @cname("GetCurrentThreadId");

extern fn Bool terminate_process(Handle process, uint exit_code) @cname("TerminateProcess");

extern fn Bool terminate_thread(Handle thread, DWord exit_code) @cname("TerminateThread");

extern fn DWord suspend_thread(Handle thread) @cname("SuspendThread");

extern fn DWord resume_thread(Handle thread) @cname("ResumeThread");

extern fn void exit_process(uint exit_code) @cname("ExitProcess");

extern fn void exit_thread(DWord exit_code) @cname("ExitThread");

extern fn Bool get_exit_code_process(Handle process, DWord* exit_code) @cname("GetExitCodeProcess");

extern fn Bool get_exit_code_thread(Handle thread, DWord* exit_code) @cname("GetExitCodeThread");

extern fn Handle open_process(DWord desired_access, Bool inherit_handle, DWord process_id) @cname("OpenProcess");

extern fn Handle open_thread(DWord desired_access, Bool inherit_handle, DWord thread_id) @cname("OpenThread");

extern fn Bool set_priority_class(Handle process, DWord priority_class) @cname("SetPriorityClass");

extern fn DWord get_priority_class(Handle process) @cname("GetPriorityClass");

extern fn Bool set_thread_priority(Handle thread, int priority) @cname("SetThreadPriority");

extern fn int get_thread_priority(Handle thread) @cname("GetThreadPriority");

extern fn Bool get_process_times(
    Handle process,
    void* creation_time,
    void* exit_time,
    void* kernel_time,
    void* user_time
) @cname("GetProcessTimes");

extern fn Bool get_thread_times(
    Handle thread,
    void* creation_time,
    void* exit_time,
    void* kernel_time,
    void* user_time
) @cname("GetThreadTimes");

extern fn DWord get_process_id(Handle process) @cname("GetProcessId");

extern fn DWord get_thread_id(Handle thread) @cname("GetThreadId");

extern fn DWord get_process_id_of_thread(Handle thread) @cname("GetProcessIdOfThread");

extern fn Bool get_process_handle_count(Handle process, DWord* handle_count) @cname("GetProcessHandleCount");

extern fn ULongPtr set_thread_affinity_mask(Handle thread, ULongPtr thread_affinity_mask) @cname("SetThreadAffinityMask");

extern fn Bool set_process_affinity_mask(Handle process, ULongPtr process_affinity_mask) @cname("SetProcessAffinityMask");

extern fn Bool get_process_affinity_mask(
    Handle process,
    ULongPtr* process_affinity_mask,
    ULongPtr* system_affinity_mask
) @cname("GetProcessAffinityMask");

extern fn DWord wait_for_single_object(Handle handle, DWord milliseconds) @cname("WaitForSingleObject");

extern fn DWord wait_for_multiple_objects(
    DWord count,
    Handle* handles,
    Bool wait_all,
    DWord milliseconds
) @cname("WaitForMultipleObjects");

extern fn void sleep(DWord milliseconds) @cname("Sleep");

extern fn Bool switch_to_thread() @cname("SwitchToThread");

extern fn DWord tls_alloc() @cname("TlsAlloc");

extern fn Bool tls_free(DWord tls_index) @cname("TlsFree");

extern fn PVoid tls_get_value(DWord tls_index) @cname("TlsGetValue");

extern fn Bool tls_set_value(DWord tls_index, PVoid tls_value) @cname("TlsSetValue");

extern fn Bool is_processor_feature_present(DWord processor_feature) @cname("IsProcessorFeaturePresent");

extern fn void get_current_processor_number() @cname("GetCurrentProcessorNumber");

extern fn Bool get_process_memory_info(
    Handle process,
    ProcessMemoryCounters* counters,
    DWord cb
) @cname("GetProcessMemoryInfo");

extern fn Bool set_process_working_set_size(
    Handle process,
    Size minimum_working_set_size,
    Size maximum_working_set_size
) @cname("SetProcessWorkingSetSize");

extern fn Bool get_process_working_set_size(
    Handle process,
    Size* minimum_working_set_size,
    Size* maximum_working_set_size
) @cname("GetProcessWorkingSetSize");

extern fn Bool flush_process_write_buffers() @cname("FlushProcessWriteBuffers");

extern fn DWord get_process_version(DWord process_id) @cname("GetProcessVersion");

extern fn Bool set_thread_ideal_processor(Handle thread, DWord ideal_processor) @cname("SetThreadIdealProcessor");

extern fn DWord set_thread_ideal_processor_ex(
    Handle thread,
    void* ideal_processor,
    void* previous_ideal_processor
) @cname("SetThreadIdealProcessorEx");

extern fn Bool get_thread_ideal_processor_ex(Handle thread, void* ideal_processor) @cname("GetThreadIdealProcessorEx");

extern fn void get_startup_info_a(StartupInfoA* startup_info) @cname("GetStartupInfoA");

extern fn void get_startup_info_w(StartupInfoW* startup_info) @cname("GetStartupInfoW");

extern fn Bool create_process_as_user_a(
    Handle token,
    char* application_name,
    char* command_line,
    SecurityAttributes* process_attributes,
    SecurityAttributes* thread_attributes,
    Bool inherit_handles,
    DWord creation_flags,
    PVoid environment,
    char* current_directory,
    StartupInfoA* startup_info,
    ProcessInformation* process_information
) @cname("CreateProcessAsUserA");

extern fn Bool create_process_as_user_w(
    Handle token,
    short* application_name,
    short* command_line,
    SecurityAttributes* process_attributes,
    SecurityAttributes* thread_attributes,
    Bool inherit_handles,
    DWord creation_flags,
    PVoid environment,
    short* current_directory,
    StartupInfoW* startup_info,
    ProcessInformation* process_information
) @cname("CreateProcessAsUserW");

extern fn DWord queue_user_apc(void* apc_func, Handle thread, ULongPtr data) @cname("QueueUserAPC");

extern fn Bool get_thread_io_pending_flag(Handle thread, Bool* io_is_pending) @cname("GetThreadIOPendingFlag");

extern fn DWord get_thread_error_mode() @cname("GetThreadErrorMode");

extern fn Bool set_thread_error_mode(DWord new_mode, DWord* old_mode) @cname("SetThreadErrorMode");

extern fn Bool set_thread_stack_guarantee(ULong* stack_size_in_bytes) @cname("SetThreadStackGuarantee");

extern fn DWord set_thread_description(Handle thread, short* thread_description) @cname("SetThreadDescription");

extern fn DWord get_thread_description(Handle thread, short** thread_description) @cname("GetThreadDescription");

// Process/Thread attribute list functions
extern fn Bool initialize_proc_thread_attribute_list(
    void* attribute_list,
    DWord attribute_count,
    DWord flags,
    Size* size
) @cname("InitializeProcThreadAttributeList");

extern fn void delete_proc_thread_attribute_list(void* attribute_list) @cname("DeleteProcThreadAttributeList");

extern fn Bool update_proc_thread_attribute(
    void* attribute_list,
    DWord flags,
    ULongPtr attribute,
    PVoid value,
    Size size,
    PVoid previous_value,
    Size* return_size
) @cname("UpdateProcThreadAttribute");

// Constants for WAIT functions
const uint INFINITE = 0xFFFFFFFF;
const uint WAIT_ABANDONED = 0x00000080;
const uint WAIT_OBJECT_0 = 0x00000000;
const uint WAIT_TIMEOUT = 0x00000102;
const uint WAIT_FAILED = 0xFFFFFFFF;

// TLS constants
const uint TLS_OUT_OF_INDEXES = 0xFFFFFFFF;
