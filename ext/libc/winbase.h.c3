// winbase.h.c3l - C3 bindings for winbase.h (Windows Base API)
// Requires Windows platform

module winbase @if(env::WIN32);

alias Byte = char;
alias Word = ushort;
alias Dword = uint;
alias Qword = ulong;
alias DwordPtr = usz;
alias Long = int;
alias ULong = uint;
alias LongLong = long;
alias ULongLong = ulong;

// Pointer types
alias Pvoid = void*;
alias LPVoid = void*;
alias LPCVoid = void*;

// String types
alias Char = char;
alias WChar = ushort;
alias TChar = char;  // ANSI by default, use WChar for Unicode
alias LPStr = char*;
alias LPCStr = char*;
alias LPWStr = ushort*;
alias LPCWStr = ushort*;
alias LPTStr = char*;
alias LPCTStr = char*;

// Boolean
alias Bool = int;
const Bool TRUE = 1;
const Bool FALSE = 0;

// Handles (opaque pointers)
alias Handle = void*;
alias HInstance = void*;
alias HModule = void*;
alias HWnd = void*;
alias HMenu = void*;
alias HIcon = void*;
alias HCursor = void*;
alias HBrush = void*;
alias HFont = void*;
alias HBitmap = void*;
alias HRgn = void*;
alias HPalette = void*;
alias HAccel = void*;
alias HGlobal = void*;
alias HLocal = void*;

// ============================================================
// Constants - Handle Values
// ============================================================

const Handle INVALID_HANDLE_VALUE       = (Handle)(iptr)iptr.max;
const Handle NULL_HANDLE                = (Handle)0;

// ============================================================
// Constants - INFINITE / Timeout
// ============================================================

const uint INFINITE                     = 0xFFFFFFFF;
const uint IGNORE                       = 0;

// ============================================================
// Constants - Wait Results
// ============================================================

const Dword WAIT_FAILED                 = 0xFFFFFFFF;
const Dword WAIT_OBJECT_0               = 0x00000000;
const Dword WAIT_ABANDONED              = 0x00000080;
const Dword WAIT_ABANDONED_0            = 0x00000080;
const Dword WAIT_IO_COMPLETION          = 0x000000C0;
const Dword WAIT_TIMEOUT                = 0x00000102;

// ============================================================
// Constants - File Attributes
// ============================================================

const Dword FILE_ATTRIBUTE_READONLY             = 0x00000001;
const Dword FILE_ATTRIBUTE_HIDDEN               = 0x00000002;
const Dword FILE_ATTRIBUTE_SYSTEM               = 0x00000004;
const Dword FILE_ATTRIBUTE_DIRECTORY            = 0x00000010;
const Dword FILE_ATTRIBUTE_ARCHIVE              = 0x00000020;
const Dword FILE_ATTRIBUTE_DEVICE               = 0x00000040;
const Dword FILE_ATTRIBUTE_NORMAL               = 0x00000080;
const Dword FILE_ATTRIBUTE_TEMPORARY            = 0x00000100;
const Dword FILE_ATTRIBUTE_SPARSE_FILE          = 0x00000200;
const Dword FILE_ATTRIBUTE_REPARSE_POINT        = 0x00000400;
const Dword FILE_ATTRIBUTE_COMPRESSED           = 0x00000800;
const Dword FILE_ATTRIBUTE_OFFLINE              = 0x00001000;
const Dword FILE_ATTRIBUTE_NOT_CONTENT_INDEXED  = 0x00002000;
const Dword FILE_ATTRIBUTE_ENCRYPTED            = 0x00004000;
const Dword FILE_ATTRIBUTE_VIRTUAL              = 0x00010000;
const Dword FILE_ATTRIBUTE_RECALL_ON_OPEN       = 0x00040000;
const Dword FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS= 0x00400000;
const Dword INVALID_FILE_ATTRIBUTES             = 0xFFFFFFFF;

// ============================================================
// Constants - File Flags
// ============================================================

const Dword FILE_FLAG_WRITE_THROUGH         = 0x80000000;
const Dword FILE_FLAG_OVERLAPPED            = 0x40000000;
const Dword FILE_FLAG_NO_BUFFERING          = 0x20000000;
const Dword FILE_FLAG_RANDOM_ACCESS         = 0x10000000;
const Dword FILE_FLAG_SEQUENTIAL_SCAN       = 0x08000000;
const Dword FILE_FLAG_DELETE_ON_CLOSE       = 0x04000000;
const Dword FILE_FLAG_BACKUP_SEMANTICS      = 0x02000000;
const Dword FILE_FLAG_POSIX_SEMANTICS       = 0x01000000;
const Dword FILE_FLAG_SESSION_AWARE         = 0x00800000;
const Dword FILE_FLAG_OPEN_REPARSE_POINT    = 0x00200000;
const Dword FILE_FLAG_OPEN_NO_RECALL        = 0x00100000;
const Dword FILE_FLAG_FIRST_PIPE_INSTANCE   = 0x00080000;

// ============================================================
// Constants - File Access Rights
// ============================================================

const Dword GENERIC_READ                = 0x80000000;
const Dword GENERIC_WRITE               = 0x40000000;
const Dword GENERIC_EXECUTE             = 0x20000000;
const Dword GENERIC_ALL                 = 0x10000000;

const Dword FILE_READ_DATA              = 0x0001;
const Dword FILE_LIST_DIRECTORY         = 0x0001;
const Dword FILE_WRITE_DATA             = 0x0002;
const Dword FILE_ADD_FILE               = 0x0002;
const Dword FILE_APPEND_DATA            = 0x0004;
const Dword FILE_ADD_SUBDIRECTORY       = 0x0004;
const Dword FILE_CREATE_PIPE_INSTANCE   = 0x0004;
const Dword FILE_READ_EA                = 0x0008;
const Dword FILE_WRITE_EA               = 0x0010;
const Dword FILE_EXECUTE                = 0x0020;
const Dword FILE_TRAVERSE               = 0x0020;
const Dword FILE_DELETE_CHILD           = 0x0040;
const Dword FILE_READ_ATTRIBUTES        = 0x0080;
const Dword FILE_WRITE_ATTRIBUTES       = 0x0100;
const Dword FILE_ALL_ACCESS             = 0x001F01FF;

// ============================================================
// Constants - File Share Mode
// ============================================================

const Dword FILE_SHARE_NONE             = 0x00000000;
const Dword FILE_SHARE_READ             = 0x00000001;
const Dword FILE_SHARE_WRITE            = 0x00000002;
const Dword FILE_SHARE_DELETE           = 0x00000004;

// ============================================================
// Constants - File Creation Disposition
// ============================================================

const Dword CREATE_NEW                  = 1;
const Dword CREATE_ALWAYS               = 2;
const Dword OPEN_EXISTING               = 3;
const Dword OPEN_ALWAYS                 = 4;
const Dword TRUNCATE_EXISTING           = 5;

// ============================================================
// Constants - File Move Method (SetFilePointer)
// ============================================================

const Dword FILE_BEGIN                  = 0;
const Dword FILE_CURRENT                = 1;
const Dword FILE_END                    = 2;

// ============================================================
// Constants - Standard Handles
// ============================================================

const Dword STD_INPUT_HANDLE            = (Dword)-10;
const Dword STD_OUTPUT_HANDLE           = (Dword)-11;
const Dword STD_ERROR_HANDLE            = (Dword)-12;

// ============================================================
// Constants - global/Local Memory Flags
// ============================================================

const uint GMEM_FIXED                   = 0x0000;
const uint GMEM_MOVEABLE                = 0x0002;
const uint GMEM_NOCOMPACT               = 0x0010;
const uint GMEM_NODISCARD               = 0x0020;
const uint GMEM_ZEROINIT                = 0x0040;
const uint GMEM_MODIFY                  = 0x0080;
const uint GMEM_DISCARDABLE             = 0x0100;
const uint GMEM_NOT_BANKED              = 0x1000;
const uint GMEM_SHARE                   = 0x2000;
const uint GMEM_DDESHARE                = 0x2000;
const uint GMEM_NOTIFY                  = 0x4000;
const uint GMEM_LOWER                   = GMEM_NOT_BANKED;
const uint GMEM_VALID_FLAGS             = 0x7F72;
const uint GMEM_INVALID_HANDLE          = 0x8000;
const uint GHND                         = (GMEM_MOVEABLE | GMEM_ZEROINIT);
const uint GPTR                         = (GMEM_FIXED | GMEM_ZEROINIT);

const uint LMEM_FIXED                   = 0x0000;
const uint LMEM_MOVEABLE                = 0x0002;
const uint LMEM_NOCOMPACT               = 0x0010;
const uint LMEM_NODISCARD               = 0x0020;
const uint LMEM_ZEROINIT                = 0x0040;
const uint LMEM_MODIFY                  = 0x0080;
const uint LMEM_DISCARDABLE             = 0x0F00;
const uint LMEM_VALID_FLAGS             = 0x0F72;
const uint LMEM_INVALID_HANDLE          = 0x8000;
const uint LHND                         = (LMEM_MOVEABLE | LMEM_ZEROINIT);
const uint LPTR                         = (LMEM_FIXED | LMEM_ZEROINIT);
const uint NONZEROLHND                  = LMEM_MOVEABLE;
const uint NONZEROLPTR                  = LMEM_FIXED;

// ============================================================
// Constants - virtual Memory
// ============================================================

const Dword MEM_COMMIT                  = 0x00001000;
const Dword MEM_RESERVE                 = 0x00002000;
const Dword MEM_DECOMMIT                = 0x00004000;
const Dword MEM_RELEASE                 = 0x00008000;
const Dword MEM_FREE                    = 0x00010000;
const Dword MEM_PRIVATE                 = 0x00020000;
const Dword MEM_MAPPED                  = 0x00040000;
const Dword MEM_RESET                   = 0x00080000;
const Dword MEM_TOP_DOWN                = 0x00100000;
const Dword MEM_WRITE_WATCH             = 0x00200000;
const Dword MEM_PHYSICAL                = 0x00400000;
const Dword MEM_ROTATE                  = 0x00800000;
const Dword MEM_LARGE_PAGES             = 0x20000000;
const Dword MEM_4MB_PAGES               = 0x80000000;
const Dword MEM_64K_PAGES               = (MEM_LARGE_PAGES | MEM_PHYSICAL);
const Dword MEM_RESET_UNDO              = 0x01000000;
const Dword MEM_UNMAP_WITH_TRANSIENT_BOOST = 0x00000001;
const Dword MEM_COALESCE_PLACEHOLDERS   = 0x00000001;
const Dword MEM_PRESERVE_PLACEHOLDER    = 0x00000002;
const Dword MEM_REPLACE_PLACEHOLDER     = 0x00004000;

// Page Protection
const Dword PAGE_NOACCESS               = 0x01;
const Dword PAGE_READONLY               = 0x02;
const Dword PAGE_READWRITE              = 0x04;
const Dword PAGE_WRITECOPY              = 0x08;
const Dword PAGE_EXECUTE                = 0x10;
const Dword PAGE_EXECUTE_READ           = 0x20;
const Dword PAGE_EXECUTE_READWRITE      = 0x40;
const Dword PAGE_EXECUTE_WRITECOPY      = 0x80;
const Dword PAGE_GUARD                  = 0x100;
const Dword PAGE_NOCACHE                = 0x200;
const Dword PAGE_WRITECOMBINE           = 0x400;
const Dword PAGE_TARGETS_INVALID        = 0x40000000;
const Dword PAGE_TARGETS_NO_UPDATE      = 0x40000000;

// ============================================================
// Constants - FormatMessage
// ============================================================

const Dword FORMAT_MESSAGE_ALLOCATE_BUFFER  = 0x00000100;
const Dword FORMAT_MESSAGE_IGNORE_INSERTS   = 0x00000200;
const Dword FORMAT_MESSAGE_FROM_STRING      = 0x00000400;
const Dword FORMAT_MESSAGE_FROM_HMODULE     = 0x00000800;
const Dword FORMAT_MESSAGE_FROM_SYSTEM      = 0x00001000;
const Dword FORMAT_MESSAGE_ARGUMENT_ARRAY   = 0x00002000;
const Dword FORMAT_MESSAGE_MAX_WIDTH_MASK   = 0x000000FF;

// ============================================================
// Constants - Process Creation Flags
// ============================================================

const Dword DEBUG_PROCESS                       = 0x00000001;
const Dword DEBUG_ONLY_THIS_PROCESS             = 0x00000002;
const Dword CREATE_SUSPENDED                    = 0x00000004;
const Dword DETACHED_PROCESS                    = 0x00000008;
const Dword CREATE_NEW_CONSOLE                  = 0x00000010;
const Dword NORMAL_PRIORITY_CLASS               = 0x00000020;
const Dword IDLE_PRIORITY_CLASS                 = 0x00000040;
const Dword HIGH_PRIORITY_CLASS                 = 0x00000080;
const Dword REALTIME_PRIORITY_CLASS             = 0x00000100;
const Dword CREATE_NEW_PROCESS_GROUP            = 0x00000200;
const Dword CREATE_UNICODE_ENVIRONMENT          = 0x00000400;
const Dword CREATE_SEPARATE_WOW_VDM             = 0x00000800;
const Dword CREATE_SHARED_WOW_VDM               = 0x00001000;
const Dword CREATE_FORCEDOS                     = 0x00002000;
const Dword BELOW_NORMAL_PRIORITY_CLASS         = 0x00004000;
const Dword ABOVE_NORMAL_PRIORITY_CLASS         = 0x00008000;
const Dword INHERIT_PARENT_AFFINITY             = 0x00010000;
const Dword INHERIT_CALLER_PRIORITY             = 0x00020000;
const Dword CREATE_PROTECTED_PROCESS            = 0x00040000;
const Dword EXTENDED_STARTUPINFO_PRESENT        = 0x00080000;
const Dword PROCESS_MODE_BACKGROUND_BEGIN       = 0x00100000;
const Dword PROCESS_MODE_BACKGROUND_END         = 0x00200000;
const Dword CREATE_SECURE_PROCESS               = 0x00400000;
const Dword CREATE_BREAKAWAY_FROM_JOB           = 0x01000000;
const Dword CREATE_PRESERVE_CODE_AUTHZ_LEVEL    = 0x02000000;
const Dword CREATE_DEFAULT_ERROR_MODE           = 0x04000000;
const Dword CREATE_NO_WINDOW                    = 0x08000000;
const Dword PROFILE_USER                        = 0x10000000;
const Dword PROFILE_KERNEL                      = 0x20000000;
const Dword PROFILE_SERVER                      = 0x40000000;
const Dword CREATE_IGNORE_SYSTEM_DEFAULT        = 0x80000000;

// ============================================================
// Constants - Thread Priority
// ============================================================

const int THREAD_PRIORITY_IDLE              = -15;
const int THREAD_PRIORITY_LOWEST            = -2;
const int THREAD_PRIORITY_BELOW_NORMAL      = -1;
const int THREAD_PRIORITY_NORMAL            = 0;
const int THREAD_PRIORITY_ABOVE_NORMAL      = 1;
const int THREAD_PRIORITY_HIGHEST           = 2;
const int THREAD_PRIORITY_TIME_CRITICAL     = 15;
const int THREAD_PRIORITY_ERROR_RETURN      = 0x7FFFFFFF;

// ============================================================
// Constants - Startup Info Flags
// ============================================================

const Dword STARTF_USESHOWWINDOW        = 0x00000001;
const Dword STARTF_USESIZE              = 0x00000002;
const Dword STARTF_USEPOSITION          = 0x00000004;
const Dword STARTF_USECOUNTCHARS        = 0x00000008;
const Dword STARTF_USEFILLATTRIBUTE     = 0x00000010;
const Dword STARTF_RUNFULLSCREEN        = 0x00000020;
const Dword STARTF_FORCEONFEEDBACK      = 0x00000040;
const Dword STARTF_FORCEOFFFEEDBACK     = 0x00000080;
const Dword STARTF_USESTDHANDLES        = 0x00000100;
const Dword STARTF_USEHOTKEY            = 0x00000200;
const Dword STARTF_TITLEISLINKNAME      = 0x00000800;
const Dword STARTF_TITLEISAPPID         = 0x00001000;
const Dword STARTF_PREVENTPINNING       = 0x00002000;
const Dword STARTF_UNTRUSTEDSOURCE      = 0x00008000;

// ============================================================
// Constants - Error Modes
// ============================================================

const Dword SEM_FAILCRITICALERRORS      = 0x0001;
const Dword SEM_NOGPFAULTERRORBOX       = 0x0002;
const Dword SEM_NOALIGNMENTFAULTEXCEPT  = 0x0004;
const Dword SEM_NOOPENFILEERRORBOX      = 0x8000;

// ============================================================
// Constants - Pipe
// ============================================================

const Dword PIPE_ACCESS_INBOUND         = 0x00000001;
const Dword PIPE_ACCESS_OUTBOUND        = 0x00000002;
const Dword PIPE_ACCESS_DUPLEX          = 0x00000003;

const Dword PIPE_TYPE_BYTE              = 0x00000000;
const Dword PIPE_TYPE_MESSAGE           = 0x00000004;
const Dword PIPE_READMODE_BYTE          = 0x00000000;
const Dword PIPE_READMODE_MESSAGE       = 0x00000002;
const Dword PIPE_WAIT                   = 0x00000000;
const Dword PIPE_NOWAIT                 = 0x00000001;
const Dword PIPE_ACCEPT_REMOTE_CLIENTS  = 0x00000000;
const Dword PIPE_REJECT_REMOTE_CLIENTS  = 0x00000008;

const Dword PIPE_UNLIMITED_INSTANCES    = 255;

const Dword NMPWAIT_WAIT_FOREVER        = 0xFFFFFFFF;
const Dword NMPWAIT_NOWAIT              = 0x00000001;
const Dword NMPWAIT_USE_DEFAULT_WAIT    = 0x00000000;

// ============================================================
// Constants - Drive Types
// ============================================================

const uint DRIVE_UNKNOWN                = 0;
const uint DRIVE_NO_ROOT_DIR            = 1;
const uint DRIVE_REMOVABLE              = 2;
const uint DRIVE_FIXED                  = 3;
const uint DRIVE_REMOTE                 = 4;
const uint DRIVE_CDROM                  = 5;
const uint DRIVE_RAMDISK                = 6;

// ============================================================
// Constants - File Type
// ============================================================

const Dword FILE_TYPE_UNKNOWN           = 0x0000;
const Dword FILE_TYPE_DISK              = 0x0001;
const Dword FILE_TYPE_CHAR              = 0x0002;
const Dword FILE_TYPE_PIPE              = 0x0003;
const Dword FILE_TYPE_REMOTE            = 0x8000;

// ============================================================
// Constants - File Mapping
// ============================================================

const Dword PAGE_READONLY_SECTION       = 0x02;
const Dword PAGE_READWRITE_SECTION      = 0x04;
const Dword PAGE_WRITECOPY_SECTION      = 0x08;
const Dword PAGE_EXECUTE_SECTION        = 0x10;
const Dword PAGE_EXECUTE_READ_SECTION   = 0x20;
const Dword PAGE_EXECUTE_READWRITE_SECTION = 0x40;

const Dword SEC_COMMIT                  = 0x08000000;
const Dword SEC_IMAGE                   = 0x01000000;
const Dword SEC_IMAGE_NO_EXECUTE        = 0x11000000;
const Dword SEC_LARGE_PAGES             = 0x80000000;
const Dword SEC_NOCACHE                 = 0x10000000;
const Dword SEC_RESERVE                 = 0x04000000;
const Dword SEC_WRITECOMBINE            = 0x40000000;

const Dword FILE_MAP_WRITE              = 0x0002;
const Dword FILE_MAP_READ               = 0x0004;
const Dword FILE_MAP_ALL_ACCESS         = 0x000F001F;
const Dword FILE_MAP_EXECUTE            = 0x0020;
const Dword FILE_MAP_COPY               = 0x00000001;
const Dword FILE_MAP_RESERVE            = 0x80000000;
const Dword FILE_MAP_TARGETS_INVALID    = 0x40000000;
const Dword FILE_MAP_LARGE_PAGES        = 0x20000000;

// ============================================================
// Constants - Mutex / Event / Semaphore
// ============================================================

const Dword MUTEX_MODIFY_STATE          = 0x0001;
const Dword MUTEX_ALL_ACCESS            = 0x1F0001;
const Dword EVENT_MODIFY_STATE          = 0x0002;
const Dword EVENT_ALL_ACCESS            = 0x1F0003;
const Dword SEMAPHORE_MODIFY_STATE      = 0x0002;
const Dword SEMAPHORE_ALL_ACCESS        = 0x1F0003;

// ============================================================
// Constants - CopyFile / MoveFile Flags
// ============================================================

const Dword MOVEFILE_REPLACE_EXISTING       = 0x00000001;
const Dword MOVEFILE_COPY_ALLOWED           = 0x00000002;
const Dword MOVEFILE_DELAY_UNTIL_REBOOT     = 0x00000004;
const Dword MOVEFILE_WRITE_THROUGH          = 0x00000008;
const Dword MOVEFILE_CREATE_HARDLINK        = 0x00000010;
const Dword MOVEFILE_FAIL_IF_NOT_TRACKABLE  = 0x00000020;

// ============================================================
// Constants - getTempPath / getTempFileName
// ============================================================

const Dword MAX_PATH                    = 260;

// ============================================================
// Constants - Console
// ============================================================

const Dword ATTACH_PARENT_PROCESS       = 0xFFFFFFFF;

// ============================================================
// Constants - Fiber
// ============================================================

const Dword FIBER_FLAG_FLOAT_SWITCH     = 0x1;

// ============================================================
// Typedefs - Basic Types (from wintypes)
// ============================================================

// These should be defined in your wintypes module, referenced here for clarity:
// Handle, Dword, Word, Bool, LPStr, LPWStr, LPCStr, LPCWStr, WChar, Char
// HModule, HInstance, HLocal, HGlobal, HFile

alias HFile   = Handle;

// ============================================================
// Structs - Security
// ============================================================

struct SecurityAttributes {
    Dword n_length;
    void*   lp_security_descriptor;
    Bool b_inherit_handle;
}

// ============================================================
// Structs - Overlapped I/O
// ============================================================

struct Overlapped {
    uptr    internal;
    uptr    internal_high;
    union {
        struct {
            Dword offset;
            Dword offset_high;
        }
        void*   pointer;
    }
    Handle  h_event;
}

struct OverlappedEntry {
    uptr        lp_completion_key;
    Overlapped* lp_overlapped;
    uptr        internal;
    Dword dw_number_of_bytes_transferred;
}

// ============================================================
// Structs - Filetime / System Time
// ============================================================

struct FileTime {
    Dword dw_low_date_time;
    Dword dw_high_date_time;
}

struct SystemTime {
    Word w_year;
    Word w_month;
    Word w_day_of_week;
    Word w_day;
    Word w_hour;
    Word w_minute;
    Word w_second;
    Word w_milliseconds;
}

struct TimeZoneInformation {
    int[32]  sz_standard_name;
    SystemTime st_standard_date;
    int     bias;
    int     standard_bias;
    int     daylight_bias;
    int[32]  sz_daylight_name;
    SystemTime st_daylight_date;
}

// ============================================================
// Structs - findData
// ============================================================

struct Win32FindDataA {
    Dword dw_file_attributes;
    FileTime ft_creation_time;
    FileTime ft_last_access_time;
    FileTime ft_last_write_time;
    Dword n_file_size_high;
    Dword n_file_size_low;
    Dword dw_reserved_0;
    Dword dw_reserved_1;
    char[MAX_PATH] c_file_name;
    char[14] c_alternate_file_name;
}

struct Win32FindDataW {
    Dword dw_file_attributes;
    FileTime ft_creation_time;
    FileTime ft_last_access_time;
    FileTime ft_last_write_time;
    Dword n_file_size_high;
    Dword n_file_size_low;
    Dword dw_reserved_0;
    Dword dw_reserved_1;
    WChar[MAX_PATH] c_file_name;
    WChar[14] c_alternate_file_name;
}

// ============================================================
// Structs - Startup Info
// ============================================================

struct StartupInfoA {
    Dword cb;
    char*   lp_reserved;
    char*   lp_desktop;
    char*   lp_title;
    Dword dw_x;
    Dword dw_y;
    Dword dw_x_size;
    Dword dw_y_size;
    Dword dw_x_count_chars;
    Dword dw_y_count_chars;
    Dword dw_fill_attribute;
    Dword dw_flags;
    Word    w_show_window;
    Word    cb_reserved_2;
    char*   lp_reserved_2;
    Handle  h_std_input;
    Handle  h_std_output;
    Handle  h_std_error;
}

struct StartupInfoW {
    Dword cb;
    WChar*  lp_reserved;
    WChar*  lp_desktop;
    WChar*  lp_title;
    Dword dw_x;
    Dword dw_y;
    Dword dw_x_size;
    Dword dw_y_size;
    Dword dw_x_count_chars;
    Dword dw_y_count_chars;
    Dword dw_fill_attribute;
    Dword dw_flags;
    Word    w_show_window;
    Word    cb_reserved_2;
    char*   lp_reserved_2;
    Handle  h_std_input;
    Handle  h_std_output;
    Handle  h_std_error;
}

// ============================================================
// Structs - Process Information
// ============================================================

struct ProcessInformation {
    Handle  h_process;
    Handle  h_thread;
    Dword dw_process_id;
    Dword dw_thread_id;
}

// ============================================================
// Structs - Memory
// ============================================================

struct MemoryBasicInformation {
    void*   base_address;
    void*   allocation_base;
    Dword allocation_protect;
    uptr    region_size;
    Dword state;
    Dword protect;
    Dword type;
}

struct MemoryBasicInformation32 {
    Dword base_address;
    Dword allocation_base;
    Dword allocation_protect;
    Dword region_size;
    Dword state;
    Dword protect;
    Dword type;
}

struct MemoryBasicInformation64 {
    ulong   base_address;
    ulong   allocation_base;
    Dword allocation_protect;
    Dword __alignment_1;
    ulong   region_size;
    Dword state;
    Dword protect;
    Dword type;
    Dword __alignment_2;
}

// ============================================================
// Structs - System Info
// ============================================================

struct SystemInfo {
    union {
        Dword dw_oem_id;
        struct {
            Word w_processor_architecture;
            Word w_reserved;
        }
    }
    Dword dw_page_size;
    void* lp_minimum_application_address;
    void* lp_maximum_application_address;
    uptr  dw_active_processor_mask;
    Dword dw_number_of_processors;
    Dword dw_processor_type;
    Dword dw_allocation_granularity;
    Word  w_processor_level;
    Word  w_processor_revision;
}

// ============================================================
// Structs - Pipe
// ============================================================

struct SecurityDescriptor {
    char    revision;
    char    sbz1;
    Word    control;
    void*   owner;
    void*   group;
    void*   sacl;
    void*   dacl;
}

// ============================================================
// Structs - File Notification
// ============================================================

struct FileNotifyInformation {
    Dword next_entry_offset;
    Dword action;
    Dword file_name_length;
    WChar   file_name; // variable length
}

// File Notify Actions
const Dword FILE_ACTION_ADDED               = 0x00000001;
const Dword FILE_ACTION_REMOVED             = 0x00000002;
const Dword FILE_ACTION_MODIFIED            = 0x00000003;
const Dword FILE_ACTION_RENAMED_OLD_NAME    = 0x00000004;
const Dword FILE_ACTION_RENAMED_NEW_NAME    = 0x00000005;

// File Notify Change Flags
const Dword FILE_NOTIFY_CHANGE_FILE_NAME    = 0x00000001;
const Dword FILE_NOTIFY_CHANGE_DIR_NAME     = 0x00000002;
const Dword FILE_NOTIFY_CHANGE_ATTRIBUTES   = 0x00000004;
const Dword FILE_NOTIFY_CHANGE_SIZE         = 0x00000008;
const Dword FILE_NOTIFY_CHANGE_LAST_WRITE   = 0x00000010;
const Dword FILE_NOTIFY_CHANGE_LAST_ACCESS  = 0x00000020;
const Dword FILE_NOTIFY_CHANGE_CREATION     = 0x00000040;
const Dword FILE_NOTIFY_CHANGE_SECURITY     = 0x00000100;

// ============================================================
// Structs - Condition Variable / Critical Section
// ============================================================

struct CriticalSection {
    void*   debug_info;
    int     lock_count;
    int     recursion_count;
    Handle  owning_thread;
    Handle  lock_semaphore;
    uptr    spin_count;
}

struct ConditionVariable {
    void*   ptr;
}

struct SRWLock {
    void*   ptr;
}

// ============================================================
// Callback Types
// ============================================================

alias LPThreadStartRoutine  = fn Dword (void* lp_parameter);
alias LPFiberStartRoutine = fn void (void* lp_fiber_parameter);
alias TimerAPCRoutine  = fn void (void* arg_to_completion_routine, Dword timer_low_value, Dword timer_high_value);
alias FileIOCompletionRoutine  = fn void (Dword dw_error_code, Dword dw_number_of_bytes_transferred, Overlapped* lp_overlapped);
alias HandlerRoutine  = fn Bool (Dword ctrl_type);

// ============================================================
// Functions - Error Handling
// ============================================================

extern fn Dword getLastError() @cname("GetLastError");
extern fn void setLastError(Dword dw_err_code) @cname("SetLastError");
extern fn Dword formatMessageA(Dword dw_flags, void* lp_source, Dword dw_message_id, Dword dw_language_id, char* lp_buffer, Dword n_size, void* arguments) @cname("FormatMessageA");
extern fn Dword formatMessageW(Dword dw_flags, void* lp_source, Dword dw_message_id, Dword dw_language_id, WChar* lp_buffer, Dword n_size, void* arguments) @cname("FormatMessageW");

// ============================================================
// Functions - Handle
// ============================================================

extern fn Bool closeHandle(Handle h_object) @cname("CloseHandle");
extern fn Bool duplicateHandle(Handle h_source_process_handle, Handle h_source_handle, Handle h_target_process_handle, Handle* lp_target_handle, Dword dw_desired_access, Bool b_inherit_handle, Dword dw_options) @cname("DuplicateHandle");
extern fn Bool setHandleInformation(Handle h_object, Dword dw_mask, Dword dw_flags) @cname("SetHandleInformation");
extern fn Bool getHandleInformation(Handle h_object, Dword* lp_flags) @cname("GetHandleInformation");
extern fn Bool compareObjectHandles(Handle h_first, Handle h_second) @cname("CompareObjectHandles");

// ============================================================
// Functions - File Operations
// ============================================================

extern fn Handle createFileA(char* lp_file_name, Dword dw_desired_access, Dword dw_share_mode, SecurityAttributes* lp_security_attributes, Dword dw_creation_disposition, Dword dw_flags_and_attributes, Handle h_template_file) @cname("CreateFileA");
extern fn Handle createFileW(WChar* lp_file_name, Dword dw_desired_access, Dword dw_share_mode, SecurityAttributes* lp_security_attributes, Dword dw_creation_disposition, Dword dw_flags_and_attributes, Handle h_template_file) @cname("CreateFileW");
extern fn Bool readFile(Handle h_file, void* lp_buffer, Dword n_number_of_bytes_to_read, Dword* lp_number_of_bytes_read, Overlapped* lp_overlapped) @cname("ReadFile");
extern fn Bool writeFile(Handle h_file, void* lp_buffer, Dword n_number_of_bytes_to_write, Dword* lp_number_of_bytes_written, Overlapped* lp_overlapped) @cname("WriteFile");
extern fn Bool readFileEx(Handle h_file, void* lp_buffer, Dword n_number_of_bytes_to_read, Overlapped* lp_overlapped, FileIOCompletionRoutine lp_completion_routine) @cname("ReadFileEx");
extern fn Bool writeFileEx(Handle h_file, void* lp_buffer, Dword n_number_of_bytes_to_write, Overlapped* lp_overlapped, FileIOCompletionRoutine lp_completion_routine) @cname("WriteFileEx");
extern fn Bool flushFileBuffers(Handle h_file) @cname("FlushFileBuffers");
extern fn Dword setFilePointer(Handle h_file, int l_distance_to_move, int* lp_distance_to_move_high, Dword dw_move_method) @cname("SetFilePointer");
extern fn Bool setFilePointerEx(Handle h_file, long li_distance_to_move, long* lp_new_file_pointer, Dword dw_move_method) @cname("SetFilePointerEx");
extern fn Bool setEndOfFile(Handle h_file) @cname("SetEndOfFile");
extern fn Bool fetFileSizeEx(Handle h_file, long* lp_file_size) @cname("GetFileSizeEx");
extern fn Dword getFileSize(Handle h_file, Dword* lp_file_size_high) @cname("GetFileSize");
extern fn Dword getFileType(Handle h_file) @cname("GetFileType");
extern fn Dword getFileAttributesA(char* lp_file_name) @cname("GetFileAttributesA");
extern fn Dword getFileAttributesW(WChar* lp_file_name) @cname("GetFileAttributesW");
extern fn Bool setFileAttributesA(char* lp_file_name, Dword dw_file_attributes) @cname("SetFileAttributesA");
extern fn Bool setFileAttributesW(WChar* lp_file_name, Dword dw_file_attributes) @cname("SetFileAttributesW");
extern fn Bool getFileTime(Handle h_file, FileTime* lp_creation_time, FileTime* lp_last_access_time, FileTime* lp_last_write_time) @cname("GetFileTime");
extern fn Bool setFileTime(Handle h_file, FileTime* lp_creation_time, FileTime* lp_last_access_time, FileTime* lp_last_write_time) @cname("SetFileTime");
extern fn Bool lockFile(Handle h_file, Dword dw_file_offset_low, Dword dw_file_offset_high, Dword n_number_of_bytes_to_lock_low, Dword n_number_of_bytes_to_lock_high) @cname("LockFile");
extern fn Bool unlockFile(Handle h_file, Dword dw_file_offset_low, Dword dw_file_offset_high, Dword n_number_of_bytes_to_unlock_low, Dword n_number_of_bytes_to_unlock_high) @cname("UnlockFile");
extern fn Bool lockFileEx(Handle h_file, Dword dw_flags, Dword dw_reserved, Dword n_number_of_bytes_to_lock_low, Dword n_number_of_bytes_to_lock_high, Overlapped* lp_overlapped) @cname("LockFileEx");
extern fn Bool unlockFileEx(Handle h_file, Dword dw_reserved, Dword n_number_of_bytes_to_unlock_low, Dword n_number_of_bytes_to_unlock_high, Overlapped* lp_overlapped) @cname("UnlockFileEx");
extern fn Bool deleteFileA(char* lp_file_name) @cname("DeleteFileA");
extern fn Bool deleteFileW(WChar* lp_file_name) @cname("DeleteFileW");
extern fn Bool copyFileA(char* lp_existing_file_name, char* lp_new_file_name, Bool b_fail_if_exists) @cname("CopyFileA");
extern fn Bool copyFileW(WChar* lp_existing_file_name, WChar* lp_new_file_name, Bool b_fail_if_exists) @cname("CopyFileW");
extern fn Bool moveFileA(char* lp_existing_file_name, char* lp_new_file_name) @cname("MoveFileA");
extern fn Bool moveFileW(WChar* lp_existing_file_name, WChar* lp_new_file_name) @cname("MoveFileW");
extern fn Bool moveFileExA(char* lp_existing_file_name, char* lp_new_file_name, Dword dw_flags) @cname("MoveFileExA");
extern fn Bool moveFileExW(WChar* lp_existing_file_name, WChar* lp_new_file_name, Dword dw_flags) @cname("MoveFileExW");
extern fn Bool createHardLinkA(char* lp_file_name, char* lp_existing_file_name, SecurityAttributes* lp_security_attributes) @cname("CreateHardLinkA");
extern fn Bool createHardLinkW(WChar* lp_file_name, WChar* lp_existing_file_name, SecurityAttributes* lp_security_attributes) @cname("CreateHardLinkW");

// ============================================================
// Functions - File Search / Directory
// ============================================================

extern fn Handle findFirstFileA(char* lp_file_name, Win32FindDataA* lp_find_file_data) @cname("FindFirstFileA");
extern fn Handle findFirstFileW(WChar* lp_file_name, Win32FindDataW* lp_find_file_data) @cname("FindFirstFileW");
extern fn Bool findNextFileA(Handle h_find_file, Win32FindDataA* lp_find_file_data) @cname("FindNextFileA");
extern fn Bool findNextFileW(Handle h_find_file, Win32FindDataW* lp_find_file_data) @cname("FindNextFileW");
extern fn Bool findClose(Handle h_find_file) @cname("FindClose");
extern fn Bool createDirectoryA(char* lp_path_name, SecurityAttributes* lp_security_attributes) @cname("CreateDirectoryA");
extern fn Bool createDirectoryW(WChar* lp_path_name, SecurityAttributes* lp_security_attributes) @cname("CreateDirectoryW");
extern fn Bool removeDirectoryA(char* lp_path_name) @cname("RemoveDirectoryA");
extern fn Bool removeDirectoryW(WChar* lp_path_name) @cname("RemoveDirectoryW");
extern fn Dword getCurrentDirectoryA(Dword n_buffer_length, char* lp_buffer) @cname("GetCurrentDirectoryA");
extern fn Dword getCurrentDirectoryW(Dword n_buffer_length, WChar* lp_buffer) @cname("GetCurrentDirectoryW");
extern fn Bool setCurrentDirectoryA(char* lp_path_name) @cname("SetCurrentDirectoryA");
extern fn Bool setCurrentDirectoryW(WChar* lp_path_name) @cname("SetCurrentDirectoryW");
extern fn Dword getTempPathA(Dword n_buffer_length, char* lp_buffer) @cname("GetTempPathA");
extern fn Dword getTempPathW(Dword n_buffer_length, WChar* lp_buffer) @cname("GetTempPathW");
extern fn uint getTempFileNameA(char* lp_path_name, char* lp_prefix_string, uint u_unique, char* lp_temp_file_name) @cname("GetTempFileNameA");
extern fn uint getTempFileNameW(WChar* lp_path_name, WChar* lp_prefix_string, uint u_unique, WChar* lp_temp_file_name) @cname("GetTempFileNameW");
extern fn Dword getFullPathNameA(char* lp_file_name, Dword n_buffer_length, char* lp_buffer, char** lp_file_part) @cname("GetFullPathNameA");
extern fn Dword getFullPathNameW(WChar* lp_file_name, Dword n_buffer_length, WChar* lp_buffer, WChar** lp_file_part) @cname("GetFullPathNameW");
extern fn Dword getShortPathNameA(char* lp_sz_long_path, char* lp_sz_short_path, Dword cch_buffer) @cname("GetShortPathNameA");
extern fn Dword getShortPathNameW(WChar* lp_sz_long_path, WChar* lp_sz_short_path, Dword cch_buffer) @cname("GetShortPathNameW");
extern fn Dword getLongPathNameA(char* lp_sz_short_path, char* lp_sz_long_path, Dword cch_buffer) @cname("GetLongPathNameA");
extern fn Dword getLongPathNameW(WChar* lp_sz_short_path, WChar* lp_sz_long_path, Dword cch_buffer) @cname("GetLongPathNameW");
extern fn Dword getDriveTypeA(char* lp_root_path_name) @cname("GetDriveTypeA");
extern fn Dword getDriveTypeW(WChar* lp_root_path_name) @cname("GetDriveTypeW");
extern fn Dword getLogicalDrives() @cname("GetLogicalDrives");
extern fn Dword getLogicalDriveStringsA(Dword n_buffer_length, char* lp_buffer) @cname("GetLogicalDriveStringsA");
extern fn Dword getLogicalDriveStringsW(Dword n_buffer_length, WChar* lp_buffer) @cname("GetLogicalDriveStringsW");
extern fn Bool getDiskFreeSpaceA(char* lp_root_path_name, Dword* lp_sectors_per_cluster, Dword* lp_bytes_per_sector, Dword* lp_number_of_free_clusters, Dword* lp_total_number_of_clusters) @cname("GetDiskFreeSpaceA");
extern fn Bool getDiskFreeSpaceW(WChar* lp_root_path_name, Dword* lp_sectors_per_cluster, Dword* lp_bytes_per_sector, Dword* lp_number_of_free_clusters, Dword* lp_total_number_of_clusters) @cname("GetDiskFreeSpaceW");
extern fn Bool getDiskFreeSpaceExA(char* lp_directory_name, ulong* lp_free_bytes_available, ulong* lp_total_number_of_bytes, ulong* lp_total_number_of_free_bytes) @cname("GetDiskFreeSpaceExA");
extern fn Bool getDiskFreeSpaceExW(WChar* lp_directory_name, ulong* lp_free_bytes_available, ulong* lp_total_number_of_bytes, ulong* lp_total_number_of_free_bytes) @cname("GetDiskFreeSpaceExW");

// ============================================================
// Functions - File Change Notification
// ============================================================

extern fn Handle findFirstChangeNotificationA(char* lp_path_name, Bool b_watch_subtree, Dword dw_notify_filter) @cname("FindFirstChangeNotificationA");
extern fn Handle findFirstChangeNotificationW(WChar* lp_path_name, Bool b_watch_subtree, Dword dw_notify_filter) @cname("FindFirstChangeNotificationW");
extern fn Bool findNextChangeNotification(Handle h_change_handle) @cname("FindNextChangeNotification");
extern fn Bool findCloseChangeNotification(Handle h_change_handle) @cname("FindCloseChangeNotification");
extern fn Bool readDirectoryChangesW(Handle h_directory, void* lp_buffer, Dword n_buffer_length, Bool b_watch_subtree, Dword dw_notify_filter, Dword* lp_bytes_returned, Overlapped* lp_overlapped, FileIOCompletionRoutine lp_completion_routine) @cname("ReadDirectoryChangesW");

// ============================================================
// Functions - Memory Management
// ============================================================

extern fn void*  virtualAlloc(void* lp_address, uptr dw_size, Dword fl_allocation_type, Dword fl_protect) @cname("VirtualAlloc");
extern fn void* virtualAllocEx(Handle h_process, void* lp_address, uptr dw_size, Dword fl_allocation_type, Dword fl_protect) @cname("VirtualAllocEx");
extern fn Bool virtualFree(void* lp_address, uptr dw_size, Dword dw_free_type) @cname("VirtualFree");
extern fn Bool virtualFreeEx(Handle h_process, void* lp_address, uptr dw_size, Dword dw_free_type) @cname("VirtualFreeEx");
extern fn Bool virtualProtect(void* lp_address, uptr dw_size, Dword fl_new_protect, Dword* lp_fl_old_protect) @cname("VirtualProtect");
extern fn Bool virtualProtectEx(Handle h_process, void* lp_address, uptr dw_size, Dword fl_new_protect, Dword* lp_fl_old_protect) @cname("VirtualProtectEx");
extern fn uptr virtualQuery(void* lp_address, MemoryBasicInformation* lp_buffer, uptr dw_length) @cname("VirtualQuery");
extern fn uptr virtualQueryEx(Handle h_process, void* lp_address, MemoryBasicInformation* lp_buffer, uptr dw_length) @cname("VirtualQueryEx");
extern fn Bool virtualLock(void* lp_address, uptr dw_size) @cname("VirtualLock");
extern fn Bool virtualUnlock(void* lp_address, uptr dw_size) @cname("VirtualUnlock");

extern fn HGlobal globalAlloc(uint u_flags, uptr dw_bytes) @cname("GlobalAlloc");
extern fn HGlobal globalReAlloc(HGlobal h_mem, uptr dw_bytes, uint u_flags) @cname("GlobalReAlloc");
extern fn HGlobal globalFree(HGlobal h_mem) @cname("GlobalFree");
extern fn void* globalLock(HGlobal h_mem) @cname("GlobalLock");
extern fn Bool globalUnlock(HGlobal h_mem) @cname("GlobalUnlock");
extern fn uptr globalSize(HGlobal h_mem) @cname("GlobalSize");

extern fn HLocal localAlloc(uint u_flags, uptr u_bytes) @cname("LocalAlloc");
extern fn HLocal localReAlloc(HLocal h_mem, uptr u_bytes, uint u_flags) @cname("LocalReAlloc");
extern fn HLocal localFree(HLocal h_mem) @cname("LocalFree");
extern fn void* localLock(HLocal h_mem) @cname("LocalLock");
extern fn Bool localUnlock(HLocal h_mem) @cname("LocalUnlock");
extern fn uptr localSize(HLocal h_mem) @cname("LocalSize");

extern fn uptr getLargePageMinimum() @cname("GetLargePageMinimum");

// ============================================================
// Functions - Memory Mapped Files
// ============================================================

extern fn Handle createFileMappingA(Handle h_file, SecurityAttributes* lp_file_mapping_attributes, Dword fl_protect, Dword dw_maximum_size_high, Dword dw_maximum_size_low, char* lp_name) @cname("CreateFileMappingA");
extern fn Handle createFileMappingW(Handle h_file, SecurityAttributes* lp_file_mapping_attributes, Dword fl_protect, Dword dw_maximum_size_high, Dword dw_maximum_size_low, WChar* lp_name) @cname("CreateFileMappingW");
extern fn Handle openFileMappingA(Dword dw_desired_access, Bool b_inherit_handle, char* lp_name) @cname("OpenFileMappingA");
extern fn Handle openFileMappingW(Dword dw_desired_access, Bool b_inherit_handle, WChar* lp_name) @cname("OpenFileMappingW");
extern fn void* mapViewOfFile(Handle h_file_mapping_object, Dword dw_desired_access, Dword dw_file_offset_high, Dword dw_file_offset_low, uptr dw_number_of_bytes_to_map) @cname("MapViewOfFile");
extern fn void* mapViewOfFileEx(Handle h_file_mapping_object, Dword dw_desired_access, Dword dw_file_offset_high, Dword dw_file_offset_low, uptr dw_number_of_bytes_to_map, void* lp_base_address) @cname("MapViewOfFileEx");
extern fn Bool unmapViewOfFile(void* lp_base_address) @cname("UnmapViewOfFile");
extern fn Bool flushViewOfFile(void* lp_base_address, uptr dw_number_of_bytes_to_flush) @cname("FlushViewOfFile");

// ============================================================
// Functions - Synchronization
// ============================================================

extern fn void sleep(Dword dw_milliseconds) @cname("Sleep");
extern fn Dword sleepEx(Dword dw_milliseconds, Bool b_alertable) @cname("SleepEx");
extern fn Dword waitForSingleObject(Handle h_handle, Dword dw_milliseconds) @cname("WaitForSingleObject");
extern fn Dword waitForSingleObjectEx(Handle h_handle, Dword dw_milliseconds, Bool b_alertable) @cname("WaitForSingleObjectEx");
extern fn Dword waitForMultipleObjects(Dword n_count, Handle* lp_handles, Bool b_wait_all, Dword dw_milliseconds) @cname("WaitForMultipleObjects");
extern fn Dword waitForMultipleObjectsEx(Dword n_count, Handle* lp_handles, Bool b_wait_all, Dword dw_milliseconds, Bool b_alertable) @cname("WaitForMultipleObjectsEx");

// Mutex
extern fn Handle createMutexA(SecurityAttributes* lp_mutex_attributes, Bool b_initial_owner, char* lp_name) @cname("CreateMutexA");
extern fn Handle createMutexW(SecurityAttributes* lp_mutex_attributes, Bool b_initial_owner, WChar* lp_name) @cname("CreateMutexW");
extern fn Handle openMutexA(Dword dw_desired_access, Bool b_inherit_handle, char* lp_name) @cname("OpenMutexA");
extern fn Handle openMutexW(Dword dw_desired_access, Bool b_inherit_handle, WChar* lp_name) @cname("OpenMutexW");
extern fn Bool releaseMutex(Handle h_mutex) @cname("ReleaseMutex");

// Event
extern fn Handle createEventA(SecurityAttributes* lp_event_attributes, Bool b_manual_reset, Bool b_initial_state, char* lp_name) @cname("CreateEventA");
extern fn Handle createEventW(SecurityAttributes* lp_event_attributes, Bool b_manual_reset, Bool b_initial_state, WChar* lp_name) @cname("CreateEventW");
extern fn Handle openEventA(Dword dw_desired_access, Bool b_inherit_handle, char* lp_name) @cname("OpenEventA");
extern fn Handle openEventW(Dword dw_desired_access, Bool b_inherit_handle, WChar* lp_name) @cname("OpenEventW");
extern fn Bool setEvent(Handle h_event) @cname("SetEvent");
extern fn Bool resetEvent(Handle h_event) @cname("ResetEvent");
extern fn Bool pulseEvent(Handle h_event) @cname("PulseEvent");

// Semaphore
extern fn Handle createSemaphoreA(SecurityAttributes* lp_semaphore_attributes, int l_initial_count, int l_maximum_count, char* lp_name) @cname("CreateSemaphoreA");
extern fn Handle createSemaphoreW(SecurityAttributes* lp_semaphore_attributes, int l_initial_count, int l_maximum_count, WChar* lp_name) @cname("CreateSemaphoreW");
extern fn Handle openSemaphoreA(Dword dw_desired_access, Bool b_inherit_handle, char* lp_name) @cname("OpenSemaphoreA");
extern fn Handle openSemaphoreW(Dword dw_desired_access, Bool b_inherit_handle, WChar* lp_name) @cname("OpenSemaphoreW");
extern fn Bool releaseSemaphore(Handle h_semaphore, int l_release_count, int* lp_previous_count) @cname("ReleaseSemaphore");

// Waitable Timer
extern fn Handle createWaitableTimerA(SecurityAttributes* lp_timer_attributes, Bool b_manual_reset, char* lp_timer_name) @cname("CreateWaitableTimerA");
extern fn Handle createWaitableTimerW(SecurityAttributes* lp_timer_attributes, Bool b_manual_reset, WChar* lp_timer_name) @cname("CreateWaitableTimerW");
extern fn Handle openWaitableTimerA(Dword dw_desired_access, Bool b_inherit_handle, char* lp_timer_name) @cname("OpenWaitableTimerA");
extern fn Handle openWaitableTimerW(Dword dw_desired_access, Bool b_inherit_handle, WChar* lp_timer_name) @cname("OpenWaitableTimerW");
extern fn Bool setWaitableTimer(Handle h_timer, long* lp_due_time, int l_period, TimerAPCRoutine pfn_completion_routine, void* lp_arg_to_completion_routine, Bool f_resume) @cname("SetWaitableTimer");
extern fn Bool cancelWaitableTimer(Handle h_timer) @cname("CancelWaitableTimer");

// Critical Section
extern fn void initializeCriticalSection(CriticalSection* lp_critical_section) @cname("InitializeCriticalSection");
extern fn Bool initializeCriticalSectionAndSpinCount( CriticalSection* lp_critical_section, Dword dw_spin_count) @cname("InitializeCriticalSectionAndSpinCount");
extern fn void deleteCriticalSection(CriticalSection* lp_critical_section) @cname("DeleteCriticalSection");
extern fn void enterCriticalSection(CriticalSection* lp_critical_section) @cname("EnterCriticalSection");
extern fn Bool tryEnterCriticalSection(CriticalSection* lp_critical_section) @cname("TryEnterCriticalSection");
extern fn void leaveCriticalSection(CriticalSection* lp_critical_section) @cname("LeaveCriticalSection");

// Slim reader/Writer Lock
extern fn void initializeSRWLock(SRWLock* srw_lock) @cname("InitializeSRWLock");
extern fn void acquireSRWLockExclusive(SRWLock* srw_lock) @cname("AcquireSRWLockExclusive");
extern fn void acquireSRWLockShared(SRWLock* srw_lock) @cname("AcquireSRWLockShared");
extern fn void releaseSRWLockExclusive(SRWLock* srw_lock) @cname("ReleaseSRWLockExclusive");
extern fn void releaseSRWLockShared(SRWLock* srw_lock) @cname("ReleaseSRWLockShared");
extern fn Bool tryAcquireSRWLockExclusive(SRWLock* srw_lock) @cname("TryAcquireSRWLockExclusive");
extern fn Bool tryAcquireSRWLockShared(SRWLock* srw_lock) @cname("TryAcquireSRWLockShared");

// Condition Variable
extern fn void initializeConditionVariable(ConditionVariable* condition_variable) @cname("InitializeConditionVariable");
extern fn Bool sleepConditionVariableCS(ConditionVariable* condition_variable, CriticalSection* critical_section, Dword dw_milliseconds) @cname("SleepConditionVariableCS");
extern fn Bool sleepConditionVariableSRW(ConditionVariable* condition_variable, SRWLock* srw_lock, Dword dw_milliseconds, ulong flags) @cname("SleepConditionVariableSRW");
extern fn void wakeConditionVariable(ConditionVariable* condition_variable) @cname("WakeConditionVariable");
extern fn void wakeAllConditionVariable(ConditionVariable* condition_variable) @cname("WakeAllConditionVariable");

// interlocked
extern fn int interlockedIncrement(int* lp_addend) @cname("InterlockedIncrement");
extern fn int interlockedDecrement(int* lp_addend) @cname("InterlockedDecrement");
extern fn int interlockedExchange(int* target, int value) @cname("InterlockedExchange");
extern fn int interlockedCompareExchange(int* destination, int exchange, int comperand) @cname("InterlockedCompareExchange");
extern fn long interlockedIncrement64(long* lp_addend) @cname("InterlockedIncrement64");
extern fn long interlockedDecrement64(long* lp_addend) @cname("InterlockedDecrement64");
extern fn long interlockedExchange64(long* target, long value) @cname("InterlockedExchange64");
extern fn long interlockedCompareExchange64(long* destination, long exchange, long comperand) @cname("InterlockedCompareExchange64");

// ============================================================
// Functions - Process and Thread
// ============================================================

extern fn Handle getCurrentProcess() @cname("GetCurrentProcess");
extern fn Dword getCurrentProcessId() @cname("GetCurrentProcessId");
extern fn Handle getCurrentThread() @cname("GetCurrentThread");
extern fn Dword getCurrentThreadId() @cname("GetCurrentThreadId");
extern fn void exitProcess(uint u_exit_code) @cname("ExitProcess") @noreturn;
extern fn void exitThread(Dword dw_exit_code) @cname("ExitThread") @noreturn;
extern fn Bool terminateProcess(Handle h_process, uint u_exit_code) @cname("TerminateProcess");
extern fn Bool terminateThread(Handle h_thread, Dword dw_exit_code) @cname("TerminateThread");
extern fn Bool getExitCodeProcess(Handle h_process, Dword* lp_exit_code) @cname("GetExitCodeProcess");
extern fn Bool getExitCodeThread(Handle h_thread, Dword* lp_exit_code) @cname("GetExitCodeThread");
extern fn Handle createThread(SecurityAttributes* lp_thread_attributes, uptr dw_stack_size, LPThreadStartRoutine lp_start_address, void* lp_parameter, Dword dw_creation_flags, Dword* lp_thread_id) @cname("CreateThread");
extern fn Handle createRemoteThread(Handle h_process, SecurityAttributes* lp_thread_attributes, uptr dw_stack_size, LPThreadStartRoutine lp_start_address, void* lp_parameter, Dword dw_creation_flags, Dword* lp_thread_id) @cname("CreateRemoteThread");
extern fn Bool createProcessA(char* lp_application_name, char* lp_command_line, SecurityAttributes* lp_process_attributes, SecurityAttributes* lp_thread_attributes, Bool b_inherit_handles, Dword dw_creation_flags, void* lp_environment, char* lp_current_directory, StartupInfoA* lp_startup_info,  ProcessInformation* lp_process_information) @cname("CreateProcessA");
extern fn Bool createProcessW(WChar* lp_application_name, WChar* lp_command_line, SecurityAttributes* lp_process_attributes, SecurityAttributes* lp_thread_attributes, Bool b_inherit_handles, Dword dw_creation_flags, void* lp_environment, WChar* lp_current_directory, StartupInfoW* lp_startup_info, ProcessInformation* lp_process_information) @cname("CreateProcessW");
extern fn Dword resumeThread(Handle h_thread) @cname("ResumeThread");
extern fn Dword suspendThread(Handle h_thread) @cname("SuspendThread");
extern fn Bool setThreadPriority(Handle h_thread, int n_priority) @cname("SetThreadPriority");
extern fn int getThreadPriority(Handle h_thread) @cname("GetThreadPriority");
extern fn void getStartupInfoA(StartupInfoA* lp_startup_info) @cname("GetStartupInfoA");
extern fn void getStartupInfoW(StartupInfoW* lp_startup_info) @cname("GetStartupInfoW");
extern fn char* getCommandLineA() @cname("GetCommandLineA");
extern fn WChar* getCommandLineW() @cname("GetCommandLineW");

// TLS (Thread local Storage)
extern fn Dword tlsAlloc() @cname("TlsAlloc");
extern fn void* tlsGetValue(Dword dw_tls_index) @cname("TlsGetValue");
extern fn Bool tlsSetValue(Dword dw_tls_index, void* lp_tls_value) @cname("TlsSetValue");
extern fn Bool tlsFree(Dword dw_tls_index) @cname("TlsFree");

// Fiber
extern fn void* convertThreadToFiber(void* lp_parameter) @cname("ConvertThreadToFiber");
extern fn void* createFiber(uptr dw_stack_size, LPFiberStartRoutine lp_start_address, void* lp_parameter) @cname("CreateFiber");
extern fn void deleteFiber(void* lp_fiber) @cname("DeleteFiber");
extern fn void switchToFiber(void* lp_fiber) @cname("SwitchToFiber");
extern fn void* getFiberData() @cname("GetFiberData");
extern fn void* getCurrentFiber() @cname("GetCurrentFiber");

// ============================================================
// Functions - Pipe
// ============================================================

extern fn Bool createPipe(Handle* h_read_pipe, Handle* h_write_pipe, SecurityAttributes* lp_pipe_attributes, Dword n_size) @cname("CreatePipe");
extern fn Handle createNamedPipeA(char* lp_name, Dword dw_open_mode, Dword dw_pipe_mode, Dword n_max_instances, Dword n_out_buffer_size, Dword n_in_buffer_size, Dword n_default_time_out, SecurityAttributes* lp_security_attributes) @cname("CreateNamedPipeA");
extern fn Handle createNamedPipeW(WChar* lp_name, Dword dw_open_mode, Dword dw_pipe_mode, Dword n_max_instances, Dword n_out_buffer_size, Dword n_in_buffer_size, Dword n_default_time_out, SecurityAttributes* lp_security_attributes) @cname("CreateNamedPipeW");
extern fn Bool connectNamedPipe(Handle h_named_pipe, Overlapped* lp_overlapped) @cname("ConnectNamedPipe");
extern fn Bool disconnectNamedPipe(Handle h_named_pipe) @cname("DisconnectNamedPipe");
extern fn Bool waitNamedPipeA(char* lp_named_pipe_name, Dword n_time_out) @cname("WaitNamedPipeA");
extern fn Bool waitNamedPipeW(WChar* lp_named_pipe_name, Dword n_time_out) @cname("WaitNamedPipeW");
extern fn Bool peekNamedPipe(Handle h_named_pipe, void* lp_buffer, Dword n_buffer_size, Dword* lp_bytes_read, Dword* lp_total_bytes_avail, Dword* lp_bytes_left_this_message) @cname("PeekNamedPipe");
extern fn Bool transactNamedPipe(Handle h_named_pipe, void* lp_in_buffer, Dword n_in_buffer_size, void* lp_out_buffer, Dword n_out_buffer_size, Dword* lp_bytes_read, Overlapped* lp_overlapped) @cname("TransactNamedPipe");
extern fn Bool getNamedPipeInfo(Handle h_named_pipe, Dword* lp_flags, Dword* lp_out_buffer_size, Dword* lp_in_buffer_size, Dword* lp_max_instances) @cname("GetNamedPipeInfo");
extern fn Bool setNamedPipeHandleState(Handle h_named_pipe, Dword* lp_mode, Dword* lp_max_collection_count, Dword* lp_collect_data_timeout) @cname("SetNamedPipeHandleState");

// ============================================================
// Functions - Console
// ============================================================

extern fn Handle getStdHandle(Dword n_std_handle) @cname("GetStdHandle");
extern fn Bool setStdHandle(Dword n_std_handle, Handle h_handle) @cname("SetStdHandle");
extern fn Bool allocConsole() @cname("AllocConsole");
extern fn Bool freeConsole() @cname("FreeConsole");
extern fn Bool attachConsole(Dword dw_process_id) @cname("AttachConsole");

// ============================================================
// Functions - Module / Library
// ============================================================

extern fn HModule loadLibraryA(char* lp_lib_file_name) @cname("LoadLibraryA");
extern fn HModule loadLibraryW(WChar* lp_lib_file_name) @cname("LoadLibraryW");
extern fn HModule loadLibraryExA(char* lp_lib_file_name, Handle h_file, Dword dw_flags) @cname("LoadLibraryExA");
extern fn HModule loadLibraryExW(WChar* lp_lib_file_name, Handle h_file, Dword dw_flags) @cname("LoadLibraryExW");
extern fn Bool freeLibrary(HModule h_lib_module) @cname("FreeLibrary");
extern fn void* getProcAddress(HModule h_module, char* lp_proc_name) @cname("GetProcAddress");
extern fn Dword getModuleFileNameA(HModule h_module, char* lp_filename, Dword n_size) @cname("GetModuleFileNameA");
extern fn Dword getModuleFileNameW(HModule h_module, WChar* lp_filename, Dword n_size) @cname("GetModuleFileNameW");
extern fn HModule getModuleHandleA(char* lp_module_name) @cname("GetModuleHandleA");
extern fn HModule getModuleHandleW(WChar* lp_module_name) @cname("GetModuleHandleW");

// ============================================================
// Functions - Time
// ============================================================

extern fn void getSystemTime(SystemTime* lp_system_time) @cname("GetSystemTime");
extern fn void getLocalTime(SystemTime* lp_system_time) @cname("GetLocalTime");
extern fn Bool setSystemTime(SystemTime* lp_system_time) @cname("SetSystemTime");
extern fn Bool setLocalTime(SystemTime* lp_system_time) @cname("SetLocalTime");
extern fn Dword getTickCount() @cname("GetTickCount");
extern fn ulong getTickCount64() @cname("GetTickCount64");
extern fn Bool queryPerformanceCounter(long* lp_performance_count) @cname("QueryPerformanceCounter");
extern fn Bool queryPerformanceFrequency(long* lp_frequency) @cname("QueryPerformanceFrequency");
extern fn void getSystemTimeAsFileTime(FileTime* lp_system_time_as_file_time) @cname("GetSystemTimeAsFileTime");
extern fn Bool systemTimeToFileTime(SystemTime* lp_system_time, FileTime* lp_file_time) @cname("SystemTimeToFileTime");
extern fn Bool fileTimeToSystemTime(FileTime* lp_file_time, SystemTime* lp_system_time) @cname("FileTimeToSystemTime");
extern fn Bool fileTimeToLocalFileTime(FileTime* lp_file_time, FileTime* lp_local_file_time) @cname("FileTimeToLocalFileTime");
extern fn Bool localFileTimeToFileTime(FileTime* lp_local_file_time, FileTime* lp_file_time) @cname("LocalFileTimeToFileTime");
extern fn int compareFileTime(FileTime* lp_file_time_1, FileTime* lp_file_time_2) @cname("CompareFileTime");
extern fn Bool getTimeZoneInformation(TimeZoneInformation* lp_time_zone_information) @cname("GetTimeZoneInformation");

// ============================================================
// Functions - System Info
// ============================================================

extern fn void getSystemInfo(SystemInfo* lp_system_info) @cname("GetSystemInfo");
extern fn void getNativeSystemInfo(SystemInfo* lp_system_info) @cname("GetNativeSystemInfo");
extern fn Dword getVersion() @cname("GetVersion");
extern fn Dword getWindowsDirectoryA(char* lp_buffer, uint u_size) @cname("GetWindowsDirectoryA");
extern fn Dword getWindowsDirectoryW(WChar* lp_buffer, uint u_size) @cname("GetWindowsDirectoryW");
extern fn Dword getSystemDirectoryA(char* lp_buffer, uint u_size) @cname("GetSystemDirectoryA");
extern fn Dword getSystemDirectoryW(WChar* lp_buffer, uint u_size) @cname("GetSystemDirectoryW");
extern fn Dword getSystemWindowsDirectoryA(char* lp_buffer, uint u_size) @cname("GetSystemWindowsDirectoryA");
extern fn Dword getSystemWindowsDirectoryW(WChar* lp_buffer, uint u_size) @cname("GetSystemWindowsDirectoryW");
extern fn Dword getComputerNameA(char* lp_buffer, Dword* n_size) @cname("GetComputerNameA");
extern fn Dword getComputerNameW(WChar* lp_buffer, Dword* n_size) @cname("GetComputerNameW");
extern fn Bool setComputerNameA(char* lp_computer_name) @cname("SetComputerNameA");
extern fn Bool setComputerNameW(WChar* lp_computer_name) @cname("SetComputerNameW");

// ============================================================
// Functions - Environment
// ============================================================

extern fn Dword getEnvironmentVariableA(char* lp_name, char* lp_buffer, Dword n_size) @cname("GetEnvironmentVariableA");
extern fn Dword getEnvironmentVariableW(WChar* lp_name, WChar* lp_buffer, Dword n_size) @cname("GetEnvironmentVariableW");
extern fn Bool setEnvironmentVariableA(char* lp_name, char* lp_value) @cname("SetEnvironmentVariableA");
extern fn Bool setEnvironmentVariableW(WChar* lp_name, WChar* lp_value) @cname("SetEnvironmentVariableW");
extern fn char*  getEnvironmentStringsA() @cname("GetEnvironmentStringsA");
extern fn WChar* getEnvironmentStringsW() @cname("GetEnvironmentStringsW");
extern fn Bool freeEnvironmentStringsA(char* lp_sz_environment_block) @cname("FreeEnvironmentStringsA");
extern fn Bool freeEnvironmentStringsW(WChar* lp_sz_environment_block) @cname("FreeEnvironmentStringsW");
extern fn Dword expandEnvironmentStringsA(char* lp_src, char* lp_dst, Dword n_size) @cname("ExpandEnvironmentStringsA");
extern fn Dword expandEnvironmentStringsW(WChar* lp_src, WChar* lp_dst, Dword n_size) @cname("ExpandEnvironmentStringsW");

// ============================================================
// Functions - I/O Completion Port
// ============================================================

extern fn Handle createIoCompletionPort(Handle h_file_handle, Handle h_existing_completion_port, uptr completion_key, Dword dw_number_of_concurrent_threads) @cname("CreateIoCompletionPort");
extern fn Bool getQueuedCompletionStatus(Handle h_completion_port, Dword* lp_number_of_bytes_transferred, uptr* lp_completion_key, Overlapped** lp_overlapped, Dword dw_milliseconds) @cname("GetQueuedCompletionStatus");
extern fn Bool postQueuedCompletionStatus(Handle h_completion_port, Dword dw_number_of_bytes_transferred, uptr dw_completion_key, Overlapped* lp_overlapped) @cname("PostQueuedCompletionStatus");
extern fn Bool getQueuedCompletionStatusEx(Handle h_completion_port, OverlappedEntry* lp_completion_port_entries,  ulong ul_count, ulong* ul_num_entries_removed, Dword dw_milliseconds, Bool f_alertable) @cname("GetQueuedCompletionStatusEx");
extern fn Bool cancelIo(Handle h_file) @cname("CancelIo");
extern fn Bool cancelIoEx(Handle h_file, Overlapped* lp_overlapped) @cname("CancelIoEx");
extern fn Bool cancelSynchronousIo(Handle h_thread) @cname("CancelSynchronousIo");

// ============================================================
// Functions - Misc
// ============================================================

extern fn void outputDebugStringA(char* lp_output_string) @cname("OutputDebugStringA");
extern fn void outputDebugStringW(WChar* lp_output_string) @cname("OutputDebugStringW");
extern fn Bool isDebuggerPresent() @cname("IsDebuggerPresent");
extern fn void debugBreak() @cname("DebugBreak");
extern fn Dword getErrorMode() @cname("GetErrorMode");
extern fn Dword setErrorMode(Dword u_mode) @cname("SetErrorMode"); 
extern fn Bool beep(Dword dw_freq, Dword dw_duration) @cname("Beep");
extern fn Bool queryFullProcessImageNameA(Handle h_process, Dword dw_flags, char* lp_exe_name, Dword* lp_size) @cname("QueryFullProcessImageNameA");
extern fn Bool queryFullProcessImageNameW(Handle h_process, Dword dw_flags, WChar* lp_exe_name, Dword* lp_size) @cname("QueryFullProcessImageNameW");
extern fn Bool setConsoleCtrlHandler(HandlerRoutine handler_routine, Bool add) @cname("SetConsoleCtrlHandler");
extern fn void raiseException(Dword dw_exception_code, Dword dw_exception_flags, Dword n_number_of_arguments, uptr* lp_arguments) @cname("RaiseException") @noreturn;
