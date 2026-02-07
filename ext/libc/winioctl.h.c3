// winioctl.h.c3 

module winioctl;


// Common Windows types
alias Handle = void*;
alias DWord = uint;
alias Bool = int;
alias PVoid = void*;
alias ULong = uint;
alias UShort = ushort;
alias UChar = char;
alias Socket = uptr;


const CUInt FILE_DEVICE_BEEP = 0x00000001;
const CUInt FILE_DEVICE_CD_ROM = 0x00000002;
const CUInt FILE_DEVICE_CD_ROM_FILE_SYSTEM = 0x00000003;
const CUInt FILE_DEVICE_CONTROLLER = 0x00000004;
const CUInt FILE_DEVICE_DATALINK = 0x00000005;
const CUInt FILE_DEVICE_DFS = 0x00000006;
const CUInt FILE_DEVICE_DISK = 0x00000007;
const CUInt FILE_DEVICE_DISK_FILE_SYSTEM = 0x00000008;
const CUInt FILE_DEVICE_FILE_SYSTEM = 0x00000009;
const CUInt FILE_DEVICE_INPORT_PORT = 0x0000000a;
const CUInt FILE_DEVICE_KEYBOARD = 0x0000000b;
const CUInt FILE_DEVICE_MAILSLOT = 0x0000000c;
const CUInt FILE_DEVICE_MIDI_IN = 0x0000000d;
const CUInt FILE_DEVICE_MIDI_OUT = 0x0000000e;
const CUInt FILE_DEVICE_MOUSE = 0x0000000f;
const CUInt FILE_DEVICE_MULTI_UNC_PROVIDER = 0x00000010;
const CUInt FILE_DEVICE_NAMED_PIPE = 0x00000011;
const CUInt FILE_DEVICE_NETWORK = 0x00000012;
const CUInt FILE_DEVICE_NETWORK_BROWSER = 0x00000013;
const CUInt FILE_DEVICE_NETWORK_FILE_SYSTEM = 0x00000014;
const CUInt FILE_DEVICE_NULL = 0x00000015;
const CUInt FILE_DEVICE_PARALLEL_PORT = 0x00000016;
const CUInt FILE_DEVICE_PHYSICAL_NETCARD = 0x00000017;
const CUInt FILE_DEVICE_PRINTER = 0x00000018;
const CUInt FILE_DEVICE_SCANNER = 0x00000019;
const CUInt FILE_DEVICE_SERIAL_MOUSE_PORT = 0x0000001a;
const CUInt FILE_DEVICE_SERIAL_PORT = 0x0000001b;
const CUInt FILE_DEVICE_SCREEN = 0x0000001c;
const CUInt FILE_DEVICE_SOUND = 0x0000001d;
const CUInt FILE_DEVICE_STREAMS = 0x0000001e;
const CUInt FILE_DEVICE_TAPE = 0x0000001f;
const CUInt FILE_DEVICE_TAPE_FILE_SYSTEM = 0x00000020;
const CUInt FILE_DEVICE_TRANSPORT = 0x00000021;
const CUInt FILE_DEVICE_UNKNOWN = 0x00000022;
const CUInt FILE_DEVICE_VIDEO = 0x00000023;
const CUInt FILE_DEVICE_VIRTUAL_DISK = 0x00000024;
const CUInt FILE_DEVICE_WAVE_IN = 0x00000025;
const CUInt FILE_DEVICE_WAVE_OUT = 0x00000026;
const CUInt FILE_DEVICE_8042_PORT = 0x00000027;
const CUInt FILE_DEVICE_NETWORK_REDIRECTOR = 0x00000028;
const CUInt FILE_DEVICE_BATTERY = 0x00000029;
const CUInt FILE_DEVICE_BUS_EXTENDER = 0x0000002a;
const CUInt FILE_DEVICE_MODEM = 0x0000002b;
const CUInt FILE_DEVICE_VDM = 0x0000002c;
const CUInt FILE_DEVICE_MASS_STORAGE = 0x0000002d;
const CUInt FILE_DEVICE_SMB = 0x0000002e;
const CUInt FILE_DEVICE_KS = 0x0000002f;
const CUInt FILE_DEVICE_CHANGER = 0x00000030;
const CUInt FILE_DEVICE_SMARTCARD = 0x00000031;
const CUInt FILE_DEVICE_ACPI = 0x00000032;
const CUInt FILE_DEVICE_DVD = 0x00000033;
const CUInt FILE_DEVICE_FULLSCREEN_VIDEO = 0x00000034;
const CUInt FILE_DEVICE_DFS_FILE_SYSTEM = 0x00000035;
const CUInt FILE_DEVICE_DFS_VOLUME = 0x00000036;
const CUInt FILE_DEVICE_SERENUM = 0x00000037;
const CUInt FILE_DEVICE_TERMSRV = 0x00000038;
const CUInt FILE_DEVICE_KSEC = 0x00000039;
const CUInt FILE_DEVICE_FIPS = 0x0000003a;
const CUInt FILE_DEVICE_INFINIBAND = 0x0000003b;
const CUInt FILE_DEVICE_VMBUS = 0x0000003e;
const CUInt FILE_DEVICE_CRYPT_PROVIDER = 0x0000003f;
const CUInt FILE_DEVICE_WPD = 0x00000040;
const CUInt FILE_DEVICE_BLUETOOTH = 0x00000041;
const CUInt FILE_DEVICE_MT_COMPOSITE = 0x00000042;
const CUInt FILE_DEVICE_MT_TRANSPORT = 0x00000043;
const CUInt FILE_DEVICE_BIOMETRIC = 0x00000044;
const CUInt FILE_DEVICE_PMI = 0x00000045;
const CUInt FILE_DEVICE_EHSTOR = 0x00000046;
const CUInt FILE_DEVICE_DEVAPI = 0x00000047;
const CUInt FILE_DEVICE_GPIO = 0x00000048;
const CUInt FILE_DEVICE_USBEX = 0x00000049;
const CUInt FILE_DEVICE_CONSOLE = 0x00000050;
const CUInt FILE_DEVICE_NFP = 0x00000051;
const CUInt FILE_DEVICE_SYSENV = 0x00000052;
const CUInt FILE_DEVICE_VIRTUAL_BLOCK = 0x00000053;
const CUInt FILE_DEVICE_POINT_OF_SERVICE = 0x00000054;
const CUInt FILE_DEVICE_STORAGE_REPLICATION = 0x00000055;
const CUInt FILE_DEVICE_TRUST_ENV = 0x00000056;
const CUInt FILE_DEVICE_UCM = 0x00000057;
const CUInt FILE_DEVICE_UCMTCPCI = 0x00000058;
const CUInt FILE_DEVICE_PERSISTENT_MEMORY = 0x00000059;
const CUInt FILE_DEVICE_NVDIMM = 0x0000005a;
const CUInt FILE_DEVICE_HOLOGRAPHIC = 0x0000005b;
const CUInt FILE_DEVICE_SDFXHCI = 0x0000005c;

const CUInt METHOD_BUFFERED = 0;
const CUInt METHOD_IN_DIRECT = 1;
const CUInt METHOD_OUT_DIRECT = 2;
const CUInt METHOD_NEITHER = 3;

const CUInt FILE_ANY_ACCESS = 0;
const CUInt FILE_READ_ACCESS = 0x0001;
const CUInt FILE_WRITE_ACCESS = 0x0002;

fn CUInt ctl_code(CUInt device_type, CUInt function, CUInt method, CUInt access)
{
    return (device_type << 16) | (access << 14) | (function << 2) | method;
}

const CUInt IOCTL_STORAGE_BASE = FILE_DEVICE_MASS_STORAGE;
const CUInt IOCTL_STORAGE_CHECK_VERIFY = 0x002D4800;
const CUInt IOCTL_STORAGE_CHECK_VERIFY2 = 0x002D0800;
const CUInt IOCTL_STORAGE_MEDIA_REMOVAL = 0x002D4804;
const CUInt IOCTL_STORAGE_EJECT_MEDIA = 0x002D4808;
const CUInt IOCTL_STORAGE_LOAD_MEDIA = 0x002D480C;
const CUInt IOCTL_STORAGE_LOAD_MEDIA2 = 0x002D080C;
const CUInt IOCTL_STORAGE_RESERVE = 0x002D4810;
const CUInt IOCTL_STORAGE_RELEASE = 0x002D4814;
const CUInt IOCTL_STORAGE_FIND_NEW_DEVICES = 0x002D4818;
const CUInt IOCTL_STORAGE_EJECTION_CONTROL = 0x002D0940;
const CUInt IOCTL_STORAGE_MCN_CONTROL = 0x002D0944;
const CUInt IOCTL_STORAGE_GET_MEDIA_TYPES = 0x002D0C00;
const CUInt IOCTL_STORAGE_GET_MEDIA_TYPES_EX = 0x002D0C04;
const CUInt IOCTL_STORAGE_GET_MEDIA_SERIAL_NUMBER = 0x002D0C08;
const CUInt IOCTL_STORAGE_GET_HOTPLUG_INFO = 0x002D0C14;
const CUInt IOCTL_STORAGE_SET_HOTPLUG_INFO = 0x002DC018;
const CUInt IOCTL_STORAGE_RESET_BUS = 0x002D4C00;
const CUInt IOCTL_STORAGE_RESET_DEVICE = 0x002D4C04;
const CUInt IOCTL_STORAGE_BREAK_RESERVATION = 0x002D4C05;
const CUInt IOCTL_STORAGE_PERSISTENT_RESERVE_IN = 0x002D4C06;
const CUInt IOCTL_STORAGE_PERSISTENT_RESERVE_OUT = 0x002D4C07;
const CUInt IOCTL_STORAGE_GET_DEVICE_NUMBER = 0x002D1080;

const CUInt IOCTL_DISK_BASE = FILE_DEVICE_DISK;
const CUInt IOCTL_DISK_GET_DRIVE_GEOMETRY = 0x00070000;
const CUInt IOCTL_DISK_GET_PARTITION_INFO = 0x00074004;
const CUInt IOCTL_DISK_SET_PARTITION_INFO = 0x0007C008;
const CUInt IOCTL_DISK_GET_DRIVE_LAYOUT = 0x0007400C;
const CUInt IOCTL_DISK_SET_DRIVE_LAYOUT = 0x0007C010;
const CUInt IOCTL_DISK_VERIFY = 0x00070014;
const CUInt IOCTL_DISK_FORMAT_TRACKS = 0x0007C018;
const CUInt IOCTL_DISK_REASSIGN_BLOCKS = 0x0007C01C;
const CUInt IOCTL_DISK_PERFORMANCE = 0x00070020;
const CUInt IOCTL_DISK_IS_WRITABLE = 0x00070024;
const CUInt IOCTL_DISK_LOGGING = 0x00070028;
const CUInt IOCTL_DISK_FORMAT_TRACKS_EX = 0x0007C02C;
const CUInt IOCTL_DISK_HISTOGRAM_STRUCTURE = 0x00070030;
const CUInt IOCTL_DISK_HISTOGRAM_DATA = 0x00070034;
const CUInt IOCTL_DISK_HISTOGRAM_RESET = 0x00070038;
const CUInt IOCTL_DISK_REQUEST_STRUCTURE = 0x0007003C;
const CUInt IOCTL_DISK_REQUEST_DATA = 0x00070040;
const CUInt IOCTL_DISK_GET_PARTITION_INFO_EX = 0x00070048;
const CUInt IOCTL_DISK_SET_PARTITION_INFO_EX = 0x0007C04C;
const CUInt IOCTL_DISK_GET_DRIVE_LAYOUT_EX = 0x00070050;
const CUInt IOCTL_DISK_SET_DRIVE_LAYOUT_EX = 0x0007C054;
const CUInt IOCTL_DISK_CREATE_DISK = 0x0007C058;
const CUInt IOCTL_DISK_GET_LENGTH_INFO = 0x0007405C;
const CUInt IOCTL_DISK_GET_DRIVE_GEOMETRY_EX = 0x000700A0;
const CUInt IOCTL_DISK_UPDATE_PROPERTIES = 0x00070140;
const CUInt IOCTL_DISK_DELETE_DRIVE_LAYOUT = 0x00070180;

const CUInt IOCTL_VOLUME_BASE = 0x00000056;
const CUInt IOCTL_VOLUME_GET_VOLUME_DISK_EXTENTS = 0x00560000;
const CUInt IOCTL_VOLUME_ONLINE = 0x0056C008;
const CUInt IOCTL_VOLUME_OFFLINE = 0x0056C00C;
const CUInt IOCTL_VOLUME_IS_CLUSTERED = 0x00560012;
const CUInt IOCTL_VOLUME_GET_GPT_ATTRIBUTES = 0x00560014;

const CUInt FSCTL_REQUEST_OPLOCK_LEVEL_1 = 0x00090000;
const CUInt FSCTL_REQUEST_OPLOCK_LEVEL_2 = 0x00090004;
const CUInt FSCTL_REQUEST_BATCH_OPLOCK = 0x00090008;
const CUInt FSCTL_OPLOCK_BREAK_ACKNOWLEDGE = 0x0009000C;
const CUInt FSCTL_OPBATCH_ACK_CLOSE_PENDING = 0x00090010;
const CUInt FSCTL_OPLOCK_BREAK_NOTIFY = 0x00090014;
const CUInt FSCTL_LOCK_VOLUME = 0x00090018;
const CUInt FSCTL_UNLOCK_VOLUME = 0x0009001C;
const CUInt FSCTL_DISMOUNT_VOLUME = 0x00090020;
const CUInt FSCTL_IS_VOLUME_MOUNTED = 0x00090028;
const CUInt FSCTL_IS_PATHNAME_VALID = 0x0009002C;
const CUInt FSCTL_MARK_VOLUME_DIRTY = 0x00090030;
const CUInt FSCTL_QUERY_RETRIEVAL_POINTERS = 0x0009003B;
const CUInt FSCTL_GET_COMPRESSION = 0x0009003C;
const CUInt FSCTL_SET_COMPRESSION = 0x0009C040;
const CUInt FSCTL_SET_BOOTLOADER_ACCESSED = 0x0009C04C;
const CUInt FSCTL_MARK_AS_SYSTEM_HIVE = 0x0009004F;
const CUInt FSCTL_OPLOCK_BREAK_ACK_NO_2 = 0x00090050;
const CUInt FSCTL_INVALIDATE_VOLUMES = 0x00090054;
const CUInt FSCTL_QUERY_FAT_BPB = 0x00090058;
const CUInt FSCTL_REQUEST_FILTER_OPLOCK = 0x0009005C;
const CUInt FSCTL_FILESYSTEM_GET_STATISTICS = 0x00090060;
const CUInt FSCTL_GET_NTFS_VOLUME_DATA = 0x00090064;
const CUInt FSCTL_GET_NTFS_FILE_RECORD = 0x00090068;
const CUInt FSCTL_GET_VOLUME_BITMAP = 0x0009006F;
const CUInt FSCTL_GET_RETRIEVAL_POINTERS = 0x00090073;
const CUInt FSCTL_MOVE_FILE = 0x00090074;
const CUInt FSCTL_IS_VOLUME_DIRTY = 0x00090078;
const CUInt FSCTL_ALLOW_EXTENDED_DASD_IO = 0x00090083;
const CUInt FSCTL_FIND_FILES_BY_SID = 0x0009008F;
const CUInt FSCTL_SET_OBJECT_ID = 0x00090098;
const CUInt FSCTL_GET_OBJECT_ID = 0x0009009C;
const CUInt FSCTL_DELETE_OBJECT_ID = 0x000900A0;
const CUInt FSCTL_SET_REPARSE_POINT = 0x000900A4;
const CUInt FSCTL_GET_REPARSE_POINT = 0x000900A8;
const CUInt FSCTL_DELETE_REPARSE_POINT = 0x000900AC;
const CUInt FSCTL_ENUM_USN_DATA = 0x000900B3;
const CUInt FSCTL_SECURITY_ID_CHECK = 0x000900B7;
const CUInt FSCTL_READ_USN_JOURNAL = 0x000900BB;
const CUInt FSCTL_SET_OBJECT_ID_EXTENDED = 0x000900BC;
const CUInt FSCTL_CREATE_OR_GET_OBJECT_ID = 0x000900C0;
const CUInt FSCTL_SET_SPARSE = 0x000900C4;
const CUInt FSCTL_SET_ZERO_DATA = 0x000980C8;
const CUInt FSCTL_QUERY_ALLOCATED_RANGES = 0x000940CF;
const CUInt FSCTL_ENABLE_UPGRADE = 0x000980D0;
const CUInt FSCTL_SET_ENCRYPTION = 0x000900D7;
const CUInt FSCTL_ENCRYPTION_FSCTL_IO = 0x000900DB;
const CUInt FSCTL_WRITE_RAW_ENCRYPTED = 0x000900DF;
const CUInt FSCTL_READ_RAW_ENCRYPTED = 0x000900E3;
const CUInt FSCTL_CREATE_USN_JOURNAL = 0x000900E7;
const CUInt FSCTL_READ_FILE_USN_DATA = 0x000900EB;
const CUInt FSCTL_WRITE_USN_CLOSE_RECORD = 0x000900EF;
const CUInt FSCTL_EXTEND_VOLUME = 0x000900F0;
const CUInt FSCTL_QUERY_USN_JOURNAL = 0x000900F4;
const CUInt FSCTL_DELETE_USN_JOURNAL = 0x000900F8;
const CUInt FSCTL_MARK_HANDLE = 0x000900FC;
const CUInt FSCTL_SIS_COPYFILE = 0x00090100;
const CUInt FSCTL_SIS_LINK_FILES = 0x0009C104;
const CUInt FSCTL_RECALL_FILE = 0x00090117;
const CUInt FSCTL_READ_FROM_PLEX = 0x0009411E;
const CUInt FSCTL_FILE_PREFETCH = 0x00090120;

const CUInt IO_REPARSE_TAG_RESERVED_ZERO = 0x00000000;
const CUInt IO_REPARSE_TAG_RESERVED_ONE = 0x00000001;
const CUInt IO_REPARSE_TAG_MOUNT_POINT = 0xA0000003;
const CUInt IO_REPARSE_TAG_HSM = 0xC0000004;
const CUInt IO_REPARSE_TAG_DRIVE_EXTENDER = 0x80000005;
const CUInt IO_REPARSE_TAG_HSM2 = 0x80000006;
const CUInt IO_REPARSE_TAG_SIS = 0x80000007;
const CUInt IO_REPARSE_TAG_WIM = 0x80000008;
const CUInt IO_REPARSE_TAG_CSV = 0x80000009;
const CUInt IO_REPARSE_TAG_DFS = 0x8000000A;
const CUInt IO_REPARSE_TAG_FILTER_MANAGER = 0x8000000B;
const CUInt IO_REPARSE_TAG_SYMLINK = 0xA000000C;
const CUInt IO_REPARSE_TAG_IIS_CACHE = 0xA0000010;
const CUInt IO_REPARSE_TAG_DFSR = 0x80000012;
const CUInt IO_REPARSE_TAG_DEDUP = 0x80000013;
const CUInt IO_REPARSE_TAG_APPXSTRM = 0xC0000014;
const CUInt IO_REPARSE_TAG_NFS = 0x80000014;
const CUInt IO_REPARSE_TAG_FILE_PLACEHOLDER = 0x80000015;
const CUInt IO_REPARSE_TAG_DFM = 0x80000016;
const CUInt IO_REPARSE_TAG_WOF = 0x80000017;
const CUInt IO_REPARSE_TAG_WCI = 0x80000018;
const CUInt IO_REPARSE_TAG_WCI_1 = 0x90001018;
const CUInt IO_REPARSE_TAG_GLOBAL_REPARSE = 0xA0000019;
const CUInt IO_REPARSE_TAG_CLOUD = 0x9000001A;
const CUInt IO_REPARSE_TAG_CLOUD_1 = 0x9000101A;
const CUInt IO_REPARSE_TAG_CLOUD_2 = 0x9000201A;
const CUInt IO_REPARSE_TAG_CLOUD_3 = 0x9000301A;
const CUInt IO_REPARSE_TAG_CLOUD_4 = 0x9000401A;
const CUInt IO_REPARSE_TAG_CLOUD_5 = 0x9000501A;
const CUInt IO_REPARSE_TAG_CLOUD_6 = 0x9000601A;
const CUInt IO_REPARSE_TAG_CLOUD_7 = 0x9000701A;
const CUInt IO_REPARSE_TAG_CLOUD_8 = 0x9000801A;
const CUInt IO_REPARSE_TAG_CLOUD_9 = 0x9000901A;
const CUInt IO_REPARSE_TAG_CLOUD_A = 0x9000A01A;
const CUInt IO_REPARSE_TAG_CLOUD_B = 0x9000B01A;
const CUInt IO_REPARSE_TAG_CLOUD_C = 0x9000C01A;
const CUInt IO_REPARSE_TAG_CLOUD_D = 0x9000D01A;
const CUInt IO_REPARSE_TAG_CLOUD_E = 0x9000E01A;
const CUInt IO_REPARSE_TAG_CLOUD_F = 0x9000F01A;
const CUInt IO_REPARSE_TAG_APPEXECLINK = 0x8000001B;
const CUInt IO_REPARSE_TAG_PROJFS = 0x9000001C;
const CUInt IO_REPARSE_TAG_LX_SYMLINK = 0xA000001D;
const CUInt IO_REPARSE_TAG_STORAGE_SYNC = 0x8000001E;
const CUInt IO_REPARSE_TAG_WCI_TOMBSTONE = 0xA000001F;
const CUInt IO_REPARSE_TAG_UNHANDLED = 0x80000020;
const CUInt IO_REPARSE_TAG_ONEDRIVE = 0x80000021;
const CUInt IO_REPARSE_TAG_PROJFS_TOMBSTONE = 0xA0000022;
const CUInt IO_REPARSE_TAG_AF_UNIX = 0x80000023;
const CUInt IO_REPARSE_TAG_LX_FIFO = 0x80000024;
const CUInt IO_REPARSE_TAG_LX_CHR = 0x80000025;
const CUInt IO_REPARSE_TAG_LX_BLK = 0x80000026;

const CUInt MAXIMUM_REPARSE_DATA_BUFFER_SIZE = 16384;
const CUInt SYMLINK_FLAG_RELATIVE = 0x00000001;

struct ReparseDataBuffer
{
    CUInt reparse_tag;
    ushort reparse_data_length;
    ushort reserved;
    union
    {
        struct symlink
        {
            ushort substitute_name_offset;
            ushort substitute_name_length;
            ushort print_name_offset;
            ushort print_name_length;
            CUInt flags;
            ushort[1] path_buffer;
        }
        
        struct mount
        {
            ushort substitute_name_offset;
            ushort substitute_name_length;
            ushort print_name_offset;
            ushort print_name_length;
            ushort[1] path_buffer;
        }
        
        struct
        {
            char[1] data_buffer;
        }
    }
}

struct ReparseGuidDataBuffer
{
    CUInt reparse_tag;
    ushort reparse_data_length;
    ushort reserved;
    char[16] reparse_guid;
    struct
    {
        char[1] data_buffer;
    }
}

struct DiskGeometry
{
    CLong cylinders;
    CUInt media_type;
    CUInt tracks_per_cylinder;
    CUInt sectors_per_track;
    CUInt bytes_per_sector;
}

struct DiskGeometryEx
{
    DiskGeometry geometry;
    CLong disk_size;
    char[1] data;
}

struct PartitionInformation
{
    CLong starting_offset;
    CLong partition_length;
    CUInt hidden_sectors;
    CUInt partition_number;
    char partition_type;
    char boot_indicator;
    char recognized_partition;
    char rewrite_partition;
}

struct PartitionInformationEx
{
    CUInt partition_style;
    CLong starting_offset;
    CLong partition_length;
    CUInt partition_number;
    char rewrite_partition;
    union
    {
        struct mbr
        {
            char partition_type;
            char boot_indicator;
            char recognized_partition;
            CUInt hidden_sectors;
        } 
        
        struct gpt
        {
            char[16] partition_type;
            char[16] partition_id;
            CULong attributes;
            ushort[36] name;
        }
    }
}

struct DriveLayoutInformation
{
    CUInt partition_count;
    CUInt signature;
    PartitionInformation[1] partition_entry;
}

struct DriveLayoutInformationEx
{
    CUInt partition_style;
    CUInt partition_count;
    union
    {
        struct mbr 
        {
            CUInt signature;
        } 
        
        struct gpt
        {
            char[16] disk_id;
            CLong starting_usable_offset;
            CLong usable_length;
            CUInt max_partition_count;
        }
    }
    PartitionInformationEx[1] partition_entry;
}

struct GetLengthInformation
{
    CLong length;
}

struct StorageDeviceNumber
{
    CUInt device_type;
    CUInt device_number;
    CUInt partition_number;
}

struct DiskEvent
{
    CUInt disk_number;
    CLong starting_offset;
    CLong extent_length;
}

struct VolumeDiskExtents
{
    CUInt number_of_disk_extents;
    DiskEvent[1] extents;
}

struct StoragePropertyQuery
{
    CUInt property_id;
    CUInt query_type;
    char[1] additional_parameters;
}

struct StorageDeviceDescriptor
{
    CUInt version;
    CUInt size;
    char device_type;
    char device_type_modifier;
    char removable_media;
    char command_queueing;
    CUInt vendor_id_offset;
    CUInt product_id_offset;
    CUInt product_revision_offset;
    CUInt serial_number_offset;
    CUInt bus_type;
    CUInt raw_properties_length;
    char[1] raw_device_properties;
}

struct StorageAdapterDescriptor
{
    CUInt version;
    CUInt size;
    CUInt max_transfer_length;
    CUInt max_physical_pages;
    CUInt alignment_mask;
    char adapter_use_pio;
    char adapter_scans_down;
    char command_queueing;
    char accelerated_transfer;
    char bus_type;
    ushort bus_major_version;
    ushort bus_minor_version;
}

struct NtfsVolumeDataBuffer
{
    CLong volume_serial_number;
    CLong number_sectors;
    CLong total_clusters;
    CLong free_clusters;
    CLong total_reserved;
    CUInt bytes_per_sector;
    CUInt bytes_per_cluster;
    CUInt bytes_per_file_record_segment;
    CUInt clusters_per_file_record_segment;
    CLong mft_valid_data_length;
    CLong mft_start_lcn;
    CLong mft2_start_lcn;
    CLong mft_zone_start;
    CLong mft_zone_end;
}

struct NtfsExtendedVolumeData
{
    CUInt bytes_per_physical_sector;
    ushort lfs_major_version;
    ushort lfs_minor_version;
}

struct FileFsFullSizeInformation
{
    CLong total_allocation_units;
    CLong caller_available_allocation_units;
    CLong actual_available_allocation_units;
    CUInt sectors_per_allocation_unit;
    CUInt bytes_per_sector;
}

struct BinRange
{
    CLong starting_offset;
    CLong length;
}

struct Extent
{
    CLong next_vcn;
    CLong lcn;
}

struct RetrievalPointersBuffer
{
    CUInt extent_count;
    CLong starting_vcn;
    Extent[1] extents;
}

struct FileAllocatedRangeBuffer
{
    CLong file_offset;
    CLong length;
}

struct FileZeroDataInformation
{
    CLong file_offset;
    CLong beyond_final_zero;
}

struct FileLevelTrimRange
{
    CULong offset;
    CULong length;
}

struct FileLevelTrim
{
    CUInt key;
    CUInt num_ranges;
    FileLevelTrimRange[1] ranges;
}

struct MoveFileData
{
    void* file_handle;
    CLong starting_vcn;
    CLong starting_lcn;
    CUInt cluster_count;
}

struct FindBySidData
{
    CUInt restart;
    void* sid;
    CUInt num_entries;
    CUInt used;
}

struct FileObjectIdBuffer
{
    char[16] object_id;
    union
    {
        struct
        {
            char[16] birth_volume_id;
            char[16] birth_object_id;
            char[16] domain_id;
        }
        char[48] extended_info;
    }
}

const CInt COMPRESSION_FORMAT_NONE = 0x0000;
const CInt COMPRESSION_FORMAT_DEFAULT = 0x0001;
const CInt COMPRESSION_FORMAT_LZNT1 = 0x0002;

struct UsnRecordV2
{
    CUInt record_length;
    ushort major_version;
    ushort minor_version;
    CULong file_reference_number;
    CULong parent_file_reference_number;
    CLong usn;
    CLong time_stamp;
    CUInt reason;
    CUInt source_info;
    CUInt security_id;
    CUInt file_attributes;
    ushort file_name_length;
    ushort file_name_offset;
    ushort[1] file_name;
}

struct UsnRecordV3
{
    CUInt record_length;
    ushort major_version;
    ushort minor_version;
    char[16] file_reference_number;
    char[16] parent_file_reference_number;
    CLong usn;
    CLong time_stamp;
    CUInt reason;
    CUInt source_info;
    CUInt security_id;
    CUInt file_attributes;
    ushort file_name_length;
    ushort file_name_offset;
    ushort[1] file_name;
}

struct MftEnumDataV0
{
    CULong start_file_reference_number;
    CLong low_usn;
    CLong high_usn;
}

struct MftEnumDataV1
{
    CULong start_file_reference_number;
    CLong low_usn;
    CLong high_usn;
    ushort min_major_version;
    ushort max_major_version;
}

struct CreateUsnJournalData
{
    CULong maximum_size;
    CULong allocation_delta;
}

struct ReadUsnJournalDataV0
{
    CLong start_usn;
    CUInt reason_mask;
    CUInt return_only_on_close;
    CULong timeout;
    CULong bytes_to_wait_for;
    CULong usn_journal_id;
}

struct ReadUsnJournalDataV1
{
    CLong start_usn;
    CUInt reason_mask;
    CUInt return_only_on_close;
    CULong timeout;
    CULong bytes_to_wait_for;
    CULong usn_journal_id;
    ushort min_major_version;
    ushort max_major_version;
}

struct UsnJournalDataV0
{
    CULong usn_journal_id;
    CLong first_usn;
    CLong next_usn;
    CLong lowest_valid_usn;
    CLong max_usn;
    CULong maximum_size;
    CULong allocation_delta;
}

struct UsnJournalDataV1
{
    CULong usn_journal_id;
    CLong first_usn;
    CLong next_usn;
    CLong lowest_valid_usn;
    CLong max_usn;
    CULong maximum_size;
    CULong allocation_delta;
    ushort min_supported_major_version;
    ushort max_supported_major_version;
}

struct DeleteUsnJournalData
{
    CULong usn_journal_id;
    CUInt delete_flags;
}

struct MarkHandleInfo
{
    CUInt usn_source_info;
    void* volume_handle;
    CUInt handle_info;
}

const CUInt PARTITION_BASIC_DATA_GUID = 0;
const CUInt PARTITION_SYSTEM_GUID = 1;
const CUInt PARTITION_MSFT_RESERVED_GUID = 2;
const CUInt PARTITION_LDM_METADATA_GUID = 3;
const CUInt PARTITION_LDM_DATA_GUID = 4;
const CUInt PARTITION_MSFT_RECOVERY_GUID = 5;

const CUInt PARTITION_ENTRY_UNUSED = 0x00;
const CUInt PARTITION_FAT_12 = 0x01;
const CUInt PARTITION_XENIX_1 = 0x02;
const CUInt PARTITION_XENIX_2 = 0x03;
const CUInt PARTITION_FAT_16 = 0x04;
const CUInt PARTITION_EXTENDED = 0x05;
const CUInt PARTITION_HUGE = 0x06;
const CUInt PARTITION_IFS = 0x07;
const CUInt PARTITION_OS2BOOTMGR = 0x0A;
const CUInt PARTITION_FAT32 = 0x0B;
const CUInt PARTITION_FAT32_XINT13 = 0x0C;
const CUInt PARTITION_XINT13 = 0x0E;
const CUInt PARTITION_XINT13_EXTENDED = 0x0F;
const CUInt PARTITION_PREP = 0x41;
const CUInt PARTITION_LDM = 0x42;
const CUInt PARTITION_UNIX = 0x63;
const CUInt PARTITION_NTFT = 0x80;
const CUInt VALID_NTFT = 0xC0;

const CUInt PARTITION_STYLE_MBR = 0;
const CUInt PARTITION_STYLE_GPT = 1;
const CUInt PARTITION_STYLE_RAW = 2;

struct CreateDisk
{
    CUInt partition_style;
    union
    {
        struct mbr
        {
            CUInt signature;
        }
        
        struct gpt 
        {
            char[16] disk_id;
            CUInt max_partition_count;
        }
    }
}

struct VerifyInformation
{
    CLong starting_offset;
    CUInt length;
}

struct ReassignBlocks
{
    ushort reserved;
    ushort count;
    CUInt[1] block_number;
}

extern fn Bool deviceIoControl(
    void* device,
    CUInt io_control_code,
    void* in_buffer,
    CUInt in_buffer_size,
    void* out_buffer,
    CUInt out_buffer_size,
    CUInt* bytes_returned,
    void* overlapped
) @cname("DeviceIoControl");
