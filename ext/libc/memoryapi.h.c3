module memoryapi @if(env::WIN32);

// Windows Memory API
// C3 mapping for memoryapi.h

// Common Windows types
alias Handle = void*;
alias DWord = uint;
alias Bool = int;
alias PVoid = void*;
alias Size = ulong;
alias ULongPtr = uptr;
alias LongPtr = iptr;
alias ULong = ulong;

// Memory allocation types
const uint MEM_COMMIT = 0x00001000;
const uint MEM_RESERVE = 0x00002000;
const uint MEM_RESET = 0x00080000;
const uint MEM_RESET_UNDO = 0x01000000;
const uint MEM_LARGE_PAGES = 0x20000000;
const uint MEM_PHYSICAL = 0x00400000;
const uint MEM_TOP_DOWN = 0x00100000;
const uint MEM_WRITE_WATCH = 0x00200000;

// Memory deallocation types
const uint MEM_DECOMMIT = 0x00004000;
const uint MEM_RELEASE = 0x00008000;
const uint MEM_COALESCE_PLACEHOLDERS = 0x00000001;
const uint MEM_PRESERVE_PLACEHOLDER = 0x00000002;

// Memory protection constants
const uint PAGE_NOACCESS = 0x01;
const uint PAGE_READONLY = 0x02;
const uint PAGE_READWRITE = 0x04;
const uint PAGE_WRITECOPY = 0x08;
const uint PAGE_EXECUTE = 0x10;
const uint PAGE_EXECUTE_READ = 0x20;
const uint PAGE_EXECUTE_READWRITE = 0x40;
const uint PAGE_EXECUTE_WRITECOPY = 0x80;
const uint PAGE_GUARD = 0x100;
const uint PAGE_NOCACHE = 0x200;
const uint PAGE_WRITECOMBINE = 0x400;
const uint PAGE_GRAPHICS_NOACCESS = 0x0800;
const uint PAGE_GRAPHICS_READONLY = 0x1000;
const uint PAGE_GRAPHICS_READWRITE = 0x2000;
const uint PAGE_GRAPHICS_EXECUTE = 0x4000;
const uint PAGE_GRAPHICS_EXECUTE_READ = 0x8000;
const uint PAGE_GRAPHICS_EXECUTE_READWRITE = 0x10000;
const uint PAGE_GRAPHICS_COHERENT = 0x20000;
const uint PAGE_ENCLAVE_THREAD_CONTROL = 0x80000000;
const uint PAGE_REVERT_TO_FILE_MAP = 0x80000000;
const uint PAGE_TARGETS_NO_UPDATE = 0x40000000;
const uint PAGE_TARGETS_INVALID = 0x40000000;
const uint PAGE_ENCLAVE_UNVALIDATED = 0x20000000;
const uint PAGE_ENCLAVE_DECOMMIT = 0x10000000;

// Section access flags
const uint SECTION_QUERY = 0x0001;
const uint SECTION_MAP_WRITE = 0x0002;
const uint SECTION_MAP_READ = 0x0004;
const uint SECTION_MAP_EXECUTE = 0x0008;
const uint SECTION_EXTEND_SIZE = 0x0010;
const uint SECTION_MAP_EXECUTE_EXPLICIT = 0x0020;
const uint SECTION_ALL_ACCESS = 0x000F001F;

// File mapping flags
const uint FILE_MAP_WRITE = SECTION_MAP_WRITE;
const uint FILE_MAP_READ = SECTION_MAP_READ;
const uint FILE_MAP_ALL_ACCESS = SECTION_ALL_ACCESS;
const uint FILE_MAP_EXECUTE = SECTION_MAP_EXECUTE_EXPLICIT;
const uint FILE_MAP_COPY = 0x00000001;
const uint FILE_MAP_RESERVE = 0x80000000;
const uint FILE_MAP_TARGETS_INVALID = 0x40000000;
const uint FILE_MAP_LARGE_PAGES = 0x20000000;

// Memory state flags
const uint MEM_FREE = 0x00010000;
const uint MEM_PRIVATE = 0x00020000;
const uint MEM_MAPPED = 0x00040000;
const uint MEM_IMAGE = 0x01000000;

// Heap flags
const uint HEAP_NO_SERIALIZE = 0x00000001;
const uint HEAP_GROWABLE = 0x00000002;
const uint HEAP_GENERATE_EXCEPTIONS = 0x00000004;
const uint HEAP_ZERO_MEMORY = 0x00000008;
const uint HEAP_REALLOC_IN_PLACE_ONLY = 0x00000010;
const uint HEAP_TAIL_CHECKING_ENABLED = 0x00000020;
const uint HEAP_FREE_CHECKING_ENABLED = 0x00000040;
const uint HEAP_DISABLE_COALESCE_ON_FREE = 0x00000080;
const uint HEAP_CREATE_ALIGN_16 = 0x00010000;
const uint HEAP_CREATE_ENABLE_TRACING = 0x00020000;
const uint HEAP_CREATE_ENABLE_EXECUTE = 0x00040000;
const uint HEAP_MAXIMUM_TAG = 0x0FFF;
const uint HEAP_PSEUDO_TAG_FLAG = 0x8000;
const uint HEAP_TAG_SHIFT = 18;

// Structures
struct MemoryBasicInformation {
    PVoid base_address;
    PVoid allocation_base;
    DWord allocation_protect;
    ushort partition_id;
    Size region_size;
    DWord state;
    DWord protect;
    DWord type;
}

struct Win32MemoryRangeEntry {
    PVoid virtual_address;
    Size number_of_bytes;
}

struct Win32MemoryRegionInformation {
    PVoid allocation_base;
    DWord allocation_protect;
    DWord region_type;
    Size region_size;
}

// Memory management functions
extern fn PVoid virtual_alloc(
    PVoid address,
    Size size,
    DWord allocation_type,
    DWord protect
) @cname("VirtualAlloc");

extern fn PVoid virtual_alloc_ex(
    Handle process,
    PVoid address,
    Size size,
    DWord allocation_type,
    DWord protect
) @cname("VirtualAllocEx");

extern fn Bool virtual_free(
    PVoid address,
    Size size,
    DWord free_type
) @cname("VirtualFree");

extern fn Bool virtual_free_ex(
    Handle process,
    PVoid address,
    Size size,
    DWord free_type
) @cname("VirtualFreeEx");

extern fn Bool virtual_protect(
    PVoid address,
    Size size,
    DWord new_protect,
    DWord* old_protect
) @cname("VirtualProtect");

extern fn Bool virtual_protect_ex(
    Handle process,
    PVoid address,
    Size size,
    DWord new_protect,
    DWord* old_protect
) @cname("VirtualProtectEx");

extern fn Size virtual_query(
    PVoid address,
    MemoryBasicInformation* buffer,
    Size length
) @cname("VirtualQuery");

extern fn Size virtual_query_ex(
    Handle process,
    PVoid address,
    MemoryBasicInformation* buffer,
    Size length
) @cname("VirtualQueryEx");

extern fn Bool virtual_lock(
    PVoid address,
    Size size
) @cname("VirtualLock");

extern fn Bool virtual_unlock(
    PVoid address,
    Size size
) @cname("VirtualUnlock");

extern fn PVoid virtual_alloc_2(
    Handle process,
    PVoid base_address,
    Size size,
    DWord allocation_type,
    DWord page_protection,
    void* extended_parameters,
    ULong parameter_count
) @cname("VirtualAlloc2");

extern fn PVoid map_view_of_file_3(
    Handle file_mapping_object,
    Handle process,
    PVoid base_address,
    ulong offset,
    Size view_size,
    DWord allocation_type,
    DWord page_protection,
    void* extended_parameters,
    ULong parameter_count
) @cname("MapViewOfFile3");

extern fn Bool virtual_unlock_ex(
    Handle process,
    PVoid address,
    Size size
) @cname("VirtualUnlockEx");

extern fn ULong get_write_watch(
    DWord flags,
    PVoid base_address,
    Size region_size,
    PVoid* addresses,
    ULongPtr* count,
    DWord* granularity
) @cname("GetWriteWatch");

extern fn ULong reset_write_watch(
    PVoid base_address,
    Size region_size
) @cname("ResetWriteWatch");

extern fn Bool read_process_memory(
    Handle process,
    PVoid base_address,
    PVoid buffer,
    Size size,
    Size* number_of_bytes_read
) @cname("ReadProcessMemory");

extern fn Bool write_process_memory(
    Handle process,
    PVoid base_address,
    PVoid buffer,
    Size size,
    Size* number_of_bytes_written
) @cname("WriteProcessMemory");

// File mapping functions
extern fn Handle create_file_mapping_a(
    Handle file,
    void* file_mapping_attributes,
    DWord protect,
    DWord maximum_size_high,
    DWord maximum_size_low,
    char* name
) @cname("CreateFileMappingA");

extern fn Handle create_file_mapping_w(
    Handle file,
    void* file_mapping_attributes,
    DWord protect,
    DWord maximum_size_high,
    DWord maximum_size_low,
    short* name
) @cname("CreateFileMappingW");

extern fn Handle open_file_mapping_a(
    DWord desired_access,
    Bool inherit_handle,
    char* name
) @cname("OpenFileMappingA");

extern fn Handle open_file_mapping_w(
    DWord desired_access,
    Bool inherit_handle,
    short* name
) @cname("OpenFileMappingW");

extern fn PVoid map_view_of_file(
    Handle file_mapping_object,
    DWord desired_access,
    DWord file_offset_high,
    DWord file_offset_low,
    Size number_of_bytes_to_map
) @cname("MapViewOfFile");

extern fn PVoid map_view_of_file_ex(
    Handle file_mapping_object,
    DWord desired_access,
    DWord file_offset_high,
    DWord file_offset_low,
    Size number_of_bytes_to_map,
    PVoid base_address
) @cname("MapViewOfFileEx");

extern fn Bool unmap_view_of_file(PVoid base_address) @cname("UnmapViewOfFile");

extern fn Bool unmap_view_of_file_ex(PVoid base_address, DWord unmap_flags) @cname("UnmapViewOfFileEx");

extern fn Bool flush_view_of_file(
    PVoid base_address,
    Size number_of_bytes_to_flush
) @cname("FlushViewOfFile");

// Heap functions
extern fn Handle get_process_heap() @cname("GetProcessHeap");

extern fn DWord get_process_heaps(DWord number_of_heaps, Handle* process_heaps) @cname("GetProcessHeaps");

extern fn Handle heap_create(
    DWord options,
    Size initial_size,
    Size maximum_size
) @cname("HeapCreate");

extern fn Bool heap_destroy(Handle heap) @cname("HeapDestroy");

extern fn PVoid heap_alloc(
    Handle heap,
    DWord flags,
    Size bytes
) @cname("HeapAlloc");

extern fn PVoid heap_realloc(
    Handle heap,
    DWord flags,
    PVoid mem,
    Size bytes
) @cname("HeapReAlloc");

extern fn Bool heap_free(
    Handle heap,
    DWord flags,
    PVoid mem
) @cname("HeapFree");

extern fn Size heap_size(
    Handle heap,
    DWord flags,
    PVoid mem
) @cname("HeapSize");

extern fn Bool heap_validate(
    Handle heap,
    DWord flags,
    PVoid mem
) @cname("HeapValidate");

extern fn Size heap_compact(
    Handle heap,
    DWord flags
) @cname("HeapCompact");

extern fn Bool heap_lock(Handle heap) @cname("HeapLock");

extern fn Bool heap_unlock(Handle heap) @cname("HeapUnlock");

extern fn Bool heap_walk(
    Handle heap,
    void* entry
) @cname("HeapWalk");

extern fn Bool heap_set_information(
    Handle heap,
    int heap_information_class,
    PVoid heap_information,
    Size heap_information_length
) @cname("HeapSetInformation");

extern fn Bool heap_query_information(
    Handle heap,
    int heap_information_class,
    PVoid heap_information,
    Size heap_information_length,
    Size* return_length
) @cname("HeapQueryInformation");

// Global and Local memory functions (legacy, but still available)
extern fn Handle global_alloc(DWord flags, Size bytes) @cname("GlobalAlloc");

extern fn Handle global_realloc(Handle mem, Size bytes, DWord flags) @cname("GlobalReAlloc");

extern fn Size global_size(Handle mem) @cname("GlobalSize");

extern fn PVoid global_lock(Handle mem) @cname("GlobalLock");

extern fn Bool global_unlock(Handle mem) @cname("GlobalUnlock");

extern fn Handle global_free(Handle mem) @cname("GlobalFree");

extern fn Handle local_alloc(DWord flags, Size bytes) @cname("LocalAlloc");

extern fn Handle local_realloc(Handle mem, Size bytes, DWord flags) @cname("LocalReAlloc");

extern fn Size local_size(Handle mem) @cname("LocalSize");

extern fn PVoid local_lock(Handle mem) @cname("LocalLock");

extern fn Bool local_unlock(Handle mem) @cname("LocalUnlock");

extern fn Handle local_free(Handle mem) @cname("LocalFree");

// Memory mapped file information
extern fn Bool get_mapped_file_name_a(
    Handle process,
    PVoid address,
    char* filename,
    DWord size
) @cname("GetMappedFileNameA");

extern fn Bool get_mapped_file_name_w(
    Handle process,
    PVoid address,
    short* filename,
    DWord size
) @cname("GetMappedFileNameW");

// Additional memory management
extern fn Bool allocate_user_physical_pages(
    Handle process,
    ULongPtr* number_of_pages,
    ULongPtr* page_array
) @cname("AllocateUserPhysicalPages");

extern fn Bool free_user_physical_pages(
    Handle process,
    ULongPtr* number_of_pages,
    ULongPtr* page_array
) @cname("FreeUserPhysicalPages");

extern fn Bool map_user_physical_pages(
    PVoid virtual_address,
    ULongPtr number_of_pages,
    ULongPtr* page_array
) @cname("MapUserPhysicalPages");

extern fn Bool map_user_physical_pages_scatter(
    PVoid* virtual_addresses,
    ULongPtr number_of_pages,
    ULongPtr* page_array
) @cname("MapUserPhysicalPagesScatter");

extern fn Bool prefetch_virtual_memory(
    Handle process,
    ULongPtr number_of_entries,
    Win32MemoryRangeEntry* virtual_addresses,
    DWord flags
) @cname("PrefetchVirtualMemory");

extern fn Bool offer_virtual_memory(
    PVoid virtual_address,
    Size size,
    int priority
) @cname("OfferVirtualMemory");

extern fn Bool reclaim_virtual_memory(
    PVoid virtual_address,
    Size size
) @cname("ReclaimVirtualMemory");

extern fn Bool discard_virtual_memory(
    PVoid virtual_address,
    Size size
) @cname("DiscardVirtualMemory");

extern fn Bool set_process_valid_call_targets(
    Handle process,
    PVoid virtual_address,
    Size region_size,
    DWord number_of_offsets,
    void* offset_information
) @cname("SetProcessValidCallTargets");

// Memory notification
extern fn Handle create_memory_resource_notification(int notification_type) @cname("CreateMemoryResourceNotification");

extern fn Bool query_memory_resource_notification(
    Handle resource_notification_handle,
    Bool* resource_state
) @cname("QueryMemoryResourceNotification");

// Constants for memory notifications
const int LOW_MEMORY_RESOURCE_NOTIFICATION = 0;
const int HIGH_MEMORY_RESOURCE_NOTIFICATION = 1;

// Invalid handle value
const ulong INVALID_HANDLE_VALUE = 0xFFFFFFFFFFFFFFFF;

// Global/Local memory flags
const uint GMEM_FIXED = 0x0000;
const uint GMEM_MOVEABLE = 0x0002;
const uint GMEM_ZEROINIT = 0x0040;
const uint GPTR = 0x0040;
const uint GHND = 0x0042;

const uint LMEM_FIXED = 0x0000;
const uint LMEM_MOVEABLE = 0x0002;
const uint LMEM_ZEROINIT = 0x0040;
const uint LPTR = 0x0040;
const uint LHND = 0x0042;
