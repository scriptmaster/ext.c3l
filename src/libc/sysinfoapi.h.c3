// sysinfoapi.h.c3

module sysinfoapi @if(env::WIN32);

alias Handle = void*;
alias UIntPtr = uint*;

const ushort PROCESSOR_ARCHITECTURE_INTEL = 0;
const ushort PROCESSOR_ARCHITECTURE_MIPS = 1;
const ushort PROCESSOR_ARCHITECTURE_ALPHA = 2;
const ushort PROCESSOR_ARCHITECTURE_PPC = 3;
const ushort PROCESSOR_ARCHITECTURE_SHX = 4;
const ushort PROCESSOR_ARCHITECTURE_ARM = 5;
const ushort PROCESSOR_ARCHITECTURE_IA64 = 6;
const ushort PROCESSOR_ARCHITECTURE_ALPHA64 = 7;
const ushort PROCESSOR_ARCHITECTURE_MSIL = 8;
const ushort PROCESSOR_ARCHITECTURE_AMD64 = 9;
const ushort PROCESSOR_ARCHITECTURE_IA32_ON_WIN64 = 10;
const ushort PROCESSOR_ARCHITECTURE_NEUTRAL = 11;
const ushort PROCESSOR_ARCHITECTURE_ARM64 = 12;
const ushort PROCESSOR_ARCHITECTURE_ARM32_ON_WIN64 = 13;
const ushort PROCESSOR_ARCHITECTURE_IA32_ON_ARM64 = 14;
const ushort PROCESSOR_ARCHITECTURE_UNKNOWN = 0xFFFF;

const uint PROCESSOR_INTEL_386 = 386;
const uint PROCESSOR_INTEL_486 = 486;
const uint PROCESSOR_INTEL_PENTIUM = 586;
const uint PROCESSOR_INTEL_IA64 = 2200;
const uint PROCESSOR_AMD_X8664 = 8664;
const uint PROCESSOR_MIPS_R4000 = 4000;
const uint PROCESSOR_ALPHA_21064 = 21064;
const uint PROCESSOR_PPC_601 = 601;
const uint PROCESSOR_PPC_603 = 603;
const uint PROCESSOR_PPC_604 = 604;
const uint PROCESSOR_PPC_620 = 620;
const uint PROCESSOR_HITACHI_SH3 = 10003;
const uint PROCESSOR_HITACHI_SH3E = 10004;
const uint PROCESSOR_HITACHI_SH4 = 10005;
const uint PROCESSOR_MOTOROLA_821 = 821;
const uint PROCESSOR_SHX_SH3 = 103;
const uint PROCESSOR_SHX_SH4 = 104;
const uint PROCESSOR_STRONGARM = 2577;
const uint PROCESSOR_ARM720 = 1824;
const uint PROCESSOR_ARM820 = 2080;
const uint PROCESSOR_ARM920 = 2336;
const uint PROCESSOR_ARM_7TDMI = 70001;
const uint PROCESSOR_OPTIL = 0x494f;

const uint ACPI = 0x41435049;
const uint FIRM = 0x4649524D;
const uint RSMB = 0x52534D42;

struct SystemInfo {
    union {
        uint dw_oem_id;
        struct {
            ushort w_processor_architecture;
            ushort w_reserved;
        }
    }
    uint dw_page_size;
    void* lp_minimum_application_address;
    void* lp_maximum_application_address;
    UIntPtr dw_active_processor_mask;
    uint dw_number_of_processors;
    uint dw_processor_type;
    uint dw_allocation_granularity;
    ushort w_processor_level;
    ushort w_processor_revision;
}

struct SystemTime {
    ushort w_year;
    ushort w_month;
    ushort w_day_of_week;
    ushort w_day;
    ushort w_hour;
    ushort w_minute;
    ushort w_second;
    ushort w_milliseconds;
}

struct MemoryStatusEx {
    uint dw_length;
    uint dw_memory_load;
    ulong ull_total_phys;
    ulong ull_avail_phys;
    ulong ull_total_page_file;
    ulong ull_avail_page_file;
    ulong ull_total_virtual;
    ulong ull_avail_virtual;
    ulong ull_avail_extended_virtual;
}

struct OsVersionInfoExW {
    uint dw_os_version_info_size;
    uint dw_major_version;
    uint dw_minor_version;
    uint dw_build_number;
    uint dw_platform_id;
    ushort[128] sz_csd_version;
    ushort w_service_pack_major;
    ushort w_service_pack_minor;
    ushort w_suite_mask;
    char product_type;
    char reserved;
}

struct SystemLogicalProcessorInformation {
    UIntPtr processor_mask;
    LogicalProcessorRelationship relationship;
    union {
        struct processor_core {
            char flags;
        }
        struct numa_node {
            uint node_number;
        } 
        struct cache {
            char level;
            char associativity;
            ushort line_size;
            uint size;
            ProcessorCacheType type;
        } 
        ulong[2] reserved;
    }
}

struct SystemLogicalProcessorInformationEx {
    LogicalProcessorRelationship relationship;
    uint size;
    union {
        struct processor {
            char flags;
            char efficiency_class;
            char[20] reserved;
            ushort group_count;
            GroupAffinity[1] group_mask;
        } 
        struct numa_node {
            uint node_number;
            char[20] reserved;
            GroupAffinity group_mask;
        } 
        struct cache {
            char level;
            char associativity;
            ushort line_size;
            uint cache_size;
            ProcessorCacheType type;
            char[20] reserved;
            GroupAffinity group_mask;
        } 
        struct group {
            ulong maximum_group_count;
            ulong active_group_count;
            char[20] reserved;
            ProcessorGroupInfo[1] group_info;
        } 
    }
}

struct GroupAffinity {
    UIntPtr mask;
    ushort group;
    ushort[3] reserved;
}

struct ProcessorGroupInfo {
    char maximum_processor_count;
    char active_processor_count;
    char[38] reserved;
    UIntPtr active_processor_mask;
}

struct SystemCpuSetInformation {
    uint size;
    CpuSetInformationType type;
    union {
        struct cpu_set {
            uint id;
            ushort group;
            char logical_processor_index;
            char core_index;
            char last_level_cache_index;
            char numa_node_index;
            char efficiency_class;
            union {
                char all_flags;
                bitstruct: char {
                    char parked : 0..0;
                    char allocated : 1..1;
                    char allocated_to_target_process : 2..2;
                    char real_time : 3..3;
                    char reserved_flags : 4..7;
                }
            }
            union {
                uint reserved;
                char scheduling_class;
            }
            ulong allocation_tag;
        } 
    }
}

struct TimeZoneInformation {
    int bias;
    ushort[32] standard_name;
    SystemTime standard_date;
    int standard_bias;
    ushort[32] daylight_name;
    SystemTime daylight_date;
    int daylight_bias;
}

struct FileTime {
    uint dw_low_date_time;
    uint dw_high_date_time;
}

enum ComputerNameFormat : int {
    NET_BIOS,
    DNS_HOSTNAME,
    DNS_DOMAIN,
    DNS_FULLY_QUALIFIED,
    PHYSICAL_NET_BIOS,
    PHYSICAL_DNS_HOSTNAME,
    PHYSICAL_DNS_DOMAIN,
    PHYSICAL_DNS_FULLY_QUALIFIED,
    MAX
}

enum LogicalProcessorRelationship: const ushort {
    PROCESSOR_CORE,
    NUMA_NODE,
    CACHE,
    PROCESSOR_PACKAGE,
    GROUP,
    ALL = 0xFFFF
}

enum ProcessorCacheType {
    UNIFIED,
    INSTRUCTION,
    DATA,
    TRACE
}

enum CpuSetInformationType {
    CPU_SET_INFORMATION
}

extern fn void getSystemInfo(SystemInfo* lp_system_info) @cname("GetSystemInfo");
extern fn void getNativeSystemInfo(SystemInfo* lp_system_info) @cname("GetNativeSystemInfo");

extern fn void getSystemTime(SystemTime* lp_system_time) @cname("GetSystemTime");
extern fn void getSystemTimeAsFileTime(FileTime* lp_system_time_as_file_time) @cname("GetSystemTimeAsFileTime");
extern fn void getLocalTime(SystemTime* lp_system_time) @cname("GetLocalTime");
extern fn void getSystemTimePreciseAsFileTime(FileTime* lp_system_time_as_file_time) @cname("GetSystemTimePreciseAsFileTime");

extern fn bool setSystemTime(SystemTime* lp_system_time) @cname("SetSystemTime");
extern fn bool setLocalTime(SystemTime* lp_system_time) @cname("SetLocalTime");

extern fn bool systemTimeToFileTime(SystemTime* lp_system_time, FileTime* lp_file_time) @cname("SystemTimeToFileTime");
extern fn bool fileTimeToSystemTime(FileTime* lp_file_time, SystemTime* lp_system_time) @cname("FileTimeToSystemTime");

extern fn bool systemTimeToTzSpecificLocalTime(
    TimeZoneInformation* lp_time_zone_information,
    SystemTime* lp_universal_time,
    SystemTime* lp_local_time
) @cname("SystemTimeToTzSpecificLocalTime");

extern fn bool tzSpecificLocalTimeToSystemTime(
    TimeZoneInformation* lp_time_zone_information,
    SystemTime* lp_local_time,
    SystemTime* lp_universal_time
) @cname("TzSpecificLocalTimeToSystemTime");

extern fn uint getTickCount() @cname("GetTickCount");
extern fn ulong getTickCount64() @cname("GetTickCount64");

extern fn bool getComputerNameExW(
    ComputerNameFormat name_type,
    ushort* lp_buffer,
    uint* n_size
) @cname("GetComputerNameExW");

extern fn bool setComputerNameExW(
    ComputerNameFormat name_type,
    ushort* lp_name
) @cname("SetComputerNameExW");

extern fn uint getSystemDirectoryW(ushort* lp_buffer, uint u_size) @cname("GetSystemDirectoryW");
extern fn uint getWindowsDirectoryW(ushort* lp_buffer, uint u_size) @cname("GetWindowsDirectoryW");
extern fn uint getSystemWindowsDirectoryW(ushort* lp_buffer, uint u_size) @cname("GetSystemWindowsDirectoryW");

extern fn uint getSystemFirmwareTable(
    uint firmware_table_provider_signature,
    uint firmware_table_id,
    void* p_firmware_table_buffer,
    uint buffer_size
) @cname("GetSystemFirmwareTable");

extern fn uint enumSystemFirmwareTables(
    uint firmware_table_provider_signature,
    void* p_firmware_table_enum_buffer,
    uint buffer_size
) @cname("EnumSystemFirmwareTables");

extern fn bool getVersionExW(OsVersionInfoExW* lp_version_information) @cname("GetVersionExW");

extern fn bool globalMemoryStatusEx(MemoryStatusEx* lp_buffer) @cname("GlobalMemoryStatusEx");

extern fn bool getLogicalProcessorInformation(
    SystemLogicalProcessorInformation* buffer,
    uint* returned_length
) @cname("GetLogicalProcessorInformation");

extern fn bool getLogicalProcessorInformationEx(
    LogicalProcessorRelationship relationship_type,
    SystemLogicalProcessorInformationEx* buffer,
    uint* returned_length
) @cname("GetLogicalProcessorInformationEx");

extern fn bool getSystemCpuSetInformation(
    SystemCpuSetInformation* information,
    ulong buffer_length,
    ulong* returned_length,
    Handle process,
    ulong flags
) @cname("GetSystemCpuSetInformation");

extern fn bool getProductInfo(
    uint dw_os_major_version,
    uint dw_os_minor_version,
    uint dw_sp_major_version,
    uint dw_sp_minor_version,
    uint* pdw_returned_product_type
) @cname("GetProductInfo");

extern fn bool getIntegratedDisplaySize(double* size_in_inches) @cname("GetIntegratedDisplaySize");

extern fn uint getSystemWow64Directory2W(ushort* lp_buffer, uint u_size, ushort image_file_machine_type) @cname("GetSystemWow64Directory2W");

extern fn bool isProcessorFeaturePresent(uint processor_feature) @cname("IsProcessorFeaturePresent");

extern fn bool dnsHostnameToComputerNameW(ushort* hostname, ushort* computer_name, uint* n_size) @cname("DnsHostnameToComputerNameW");

extern fn bool getPhysicallyInstalledSystemMemory(ulong* total_memory_in_kilobytes) @cname("GetPhysicallyInstalledSystemMemory");
