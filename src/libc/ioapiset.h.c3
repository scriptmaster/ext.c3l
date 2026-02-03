// ioapiset.h.c3

module ioapiset @if(env::WIN32);

// Common Windows types
alias Handle = void*;
alias DWord = uint;
alias Bool = int;
alias PVoid = void*;
alias ULong = uint;
alias UShort = ushort;
alias UChar = char;
alias Socket = uptr;

// OVERLAPPED structure for asynchronous I/O
struct Overlapped
{
    CULong internal;
    CULong internal_high;
    union
    {
        struct
        {
            CUInt offset;
            CUInt offset_high;
        }
        void* pointer;
    }
    void* h_event;
}

// OVERLAPPED_ENTRY for GetQueuedCompletionStatusEx
struct OverlappedEntry
{
    CULong completion_key;
    Overlapped* overlapped;
    CULong internal;
    CUInt bytes_transferred;
}

const CUInt INVALID_HANDLE_VALUE = 0xFFFFFFFF;
const CUInt INFINITE = 0xFFFFFFFF;

// File flags for overlapped I/O
const CUInt FILE_FLAG_OVERLAPPED = 0x40000000;

// DeviceIoControl Related
const CUInt METHOD_BUFFERED   = 0;
const CUInt METHOD_IN_DIRECT  = 1;
const CUInt METHOD_OUT_DIRECT = 2;
const CUInt METHOD_NEITHER    = 3;

const CUInt FILE_ANY_ACCESS     = 0;
const CUInt FILE_READ_ACCESS    = 0x0001;
const CUInt FILE_WRITE_ACCESS   = 0x0002;

// Device types
const CUInt FILE_DEVICE_BEEP                = 0x00000001;
const CUInt FILE_DEVICE_CD_ROM              = 0x00000002;
const CUInt FILE_DEVICE_CD_ROM_FILE_SYSTEM  = 0x00000003;
const CUInt FILE_DEVICE_CONTROLLER          = 0x00000004;
const CUInt FILE_DEVICE_DATALINK            = 0x00000005;
const CUInt FILE_DEVICE_DFS                 = 0x00000006;
const CUInt FILE_DEVICE_DISK                = 0x00000007;
const CUInt FILE_DEVICE_DISK_FILE_SYSTEM    = 0x00000008;
const CUInt FILE_DEVICE_FILE_SYSTEM         = 0x00000009;
const CUInt FILE_DEVICE_INPORT_PORT         = 0x0000000a;
const CUInt FILE_DEVICE_KEYBOARD            = 0x0000000b;
const CUInt FILE_DEVICE_MAILSLOT            = 0x0000000c;
const CUInt FILE_DEVICE_MIDI_IN             = 0x0000000d;
const CUInt FILE_DEVICE_MIDI_OUT            = 0x0000000e;
const CUInt FILE_DEVICE_MOUSE               = 0x0000000f;
const CUInt FILE_DEVICE_MULTI_UNC_PROVIDER  = 0x00000010;
const CUInt FILE_DEVICE_NAMED_PIPE          = 0x00000011;
const CUInt FILE_DEVICE_NETWORK             = 0x00000012;
const CUInt FILE_DEVICE_NETWORK_BROWSER     = 0x00000013;
const CUInt FILE_DEVICE_NETWORK_FILE_SYSTEM = 0x00000014;
const CUInt FILE_DEVICE_NULL                = 0x00000015;
const CUInt FILE_DEVICE_PARALLEL_PORT       = 0x00000016;
const CUInt FILE_DEVICE_PHYSICAL_NETCARD    = 0x00000017;
const CUInt FILE_DEVICE_PRINTER             = 0x00000018;
const CUInt FILE_DEVICE_SCANNER             = 0x00000019;
const CUInt FILE_DEVICE_SERIAL_MOUSE_PORT   = 0x0000001a;
const CUInt FILE_DEVICE_SERIAL_PORT         = 0x0000001b;
const CUInt FILE_DEVICE_SCREEN              = 0x0000001c;
const CUInt FILE_DEVICE_SOUND               = 0x0000001d;
const CUInt FILE_DEVICE_STREAMS             = 0x0000001e;
const CUInt FILE_DEVICE_TAPE                = 0x0000001f;
const CUInt FILE_DEVICE_TAPE_FILE_SYSTEM    = 0x00000020;
const CUInt FILE_DEVICE_TRANSPORT           = 0x00000021;
const CUInt FILE_DEVICE_UNKNOWN             = 0x00000022;
const CUInt FILE_DEVICE_VIDEO               = 0x00000023;
const CUInt FILE_DEVICE_VIRTUAL_DISK        = 0x00000024;
const CUInt FILE_DEVICE_WAVE_IN             = 0x00000025;
const CUInt FILE_DEVICE_WAVE_OUT            = 0x00000026;

// Reparse point tags
const CUInt IO_REPARSE_TAG_MOUNT_POINT      = 0xA0000003;
const CUInt IO_REPARSE_TAG_HSM              = 0xC0000004;
const CUInt IO_REPARSE_TAG_SIS              = 0x80000007;
const CUInt IO_REPARSE_TAG_DFS              = 0x8000000A;
const CUInt IO_REPARSE_TAG_SYMLINK          = 0xA000000C;
const CUInt IO_REPARSE_TAG_DFSR             = 0x80000012;
const CUInt IO_REPARSE_TAG_DEDUP            = 0x80000013;
const CUInt IO_REPARSE_TAG_NFS              = 0x80000014;
const CUInt IO_REPARSE_TAG_FILE_PLACEHOLDER = 0x80000015;
const CUInt IO_REPARSE_TAG_WOF              = 0x80000017;
const CUInt IO_REPARSE_TAG_WCI              = 0x80000018;
const CUInt IO_REPARSE_TAG_GLOBAL_REPARSE   = 0xA0000019;
const CUInt IO_REPARSE_TAG_CLOUD            = 0x9000001A;
const CUInt IO_REPARSE_TAG_APPEXECLINK      = 0x8000001B;
const CUInt IO_REPARSE_TAG_PROJFS           = 0x9000001C;
const CUInt IO_REPARSE_TAG_STORAGE_SYNC     = 0x8000001E;
const CUInt IO_REPARSE_TAG_WCI_TOMBSTONE    = 0xA000001F;
const CUInt IO_REPARSE_TAG_UNHANDLED        = 0x80000020;
const CUInt IO_REPARSE_TAG_ONEDRIVE         = 0x80000021;
const CUInt IO_REPARSE_TAG_PROJFS_TOMBSTONE = 0xA0000022;
const CUInt IO_REPARSE_TAG_AF_UNIX          = 0x80000023;

// FSCTL codes (File System Control codes)
const CUInt FSCTL_GET_REPARSE_POINT         = 0x000900A8;
const CUInt FSCTL_SET_REPARSE_POINT         = 0x000900A4;
const CUInt FSCTL_DELETE_REPARSE_POINT      = 0x000900AC;

// CTL_CODE macro to function
fn CUInt ctl_code(CUInt device_type, CUInt function, CUInt method, CUInt access)
{
    return (device_type << 16) | (access << 14) | (function << 2) | method;
}

// General FSCTL code generation helper
fn CUInt fsctl_code(CUInt function, CUInt method, CUInt access)
{
    return ctl_code(FILE_DEVICE_FILE_SYSTEM, function, method, access);
}

// General IOCTL code generation helper
fn CUInt ioctl_disk_code(CUInt function, CUInt method, CUInt access)
{
    return ctl_code(FILE_DEVICE_DISK, function, method, access);
}

extern fn Bool deviceIoControl(
    void* device,
    CUInt io_control_code,
    void* in_buffer,
    CUInt in_buffer_size,
    void* out_buffer,
    CUInt out_buffer_size,
    CUInt* bytes_returned,
    Overlapped* overlapped
) @cname("DeviceIoControl");

extern fn Bool getOverlappedResult(
    void* file,
    Overlapped* overlapped,
    CUInt* bytes_transferred,
    Bool wait
) @cname("GetOverlappedResult");

extern fn Bool getOverlappedResultEx(
    void* file,
    Overlapped* overlapped,
    CUInt* bytes_transferred,
    CUInt milliseconds,
    Bool alertable
) @cname("GetOverlappedResultEx");

extern fn Bool cancelIo(
    void* file
) @cname("CancelIo");

extern fn Bool cancelIoEx(
    void* file,
    Overlapped* overlapped
) @cname("CancelIoEx");

extern fn Bool cancelSynchronousIo(
    void* thread
) @cname("CancelSynchronousIo");

extern fn void* createIoCompletionPort(
    void* file_handle,
    void* existing_completion_port,
    CULong completion_key,
    CUInt number_of_concurrent_threads
) @cname("CreateIoCompletionPort");

extern fn Bool getQueuedCompletionStatus(
    void* completion_port,
    CUInt* bytes_transferred,
    CULong* completion_key,
    Overlapped** overlapped,
    CUInt milliseconds
) @cname("GetQueuedCompletionStatus");

extern fn Bool getQueuedCompletionStatusEx(
    void* completion_port,
    OverlappedEntry* entries,
    CUInt count,
    CUInt* num_entries_removed,
    CUInt milliseconds,
    Bool alertable
) @cname("GetQueuedCompletionStatusEx");

extern fn Bool postQueuedCompletionStatus(
    void* completion_port,
    CUInt bytes_transferred,
    CULong completion_key,
    Overlapped* overlapped
) @cname("PostQueuedCompletionStatus");


// REPARSE_DATA_BUFFER for symbolic links and mount points
struct ReparseDataBuffer
{
    CUInt reparse_tag;
    ushort reparse_data_length;
    ushort reserved;
    union
    {
        // Symbolic link
        struct symlink
        {
            ushort substitute_name_offset;
            ushort substitute_name_length;
            ushort print_name_offset;
            ushort print_name_length;
            CUInt flags;
            ushort[1] path_buffer;
        }
        
        // Mount point (junction)
        struct mount
        {
            ushort substitute_name_offset;
            ushort substitute_name_length;
            ushort print_name_offset;
            ushort print_name_length;
            ushort[1] path_buffer;
        }
        
        // Generic buffer
        struct
        {
            char[1] data_buffer;
        }
    }
}

const CUInt MAXIMUM_REPARSE_DATA_BUFFER_SIZE = 16 * 1024;
const CUInt SYMLINK_FLAG_RELATIVE = 0x00000001;
