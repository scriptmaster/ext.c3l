// fileapi.h.c3
module fileapi @if(env::WIN32);

// Import basic Windows types from windows module
import windows;

// =======================================
// Function Pointer Type Aliases
// =======================================

// Completion routine for asynchronous I/O operations
alias LpoverlappedCompletionRoutine = fn void(DWord dwErrorCode, DWord dwNumberOfBytesTransfered, Overlapped* lpOverlapped);

// Progress routine for file copy operations
alias LpprogressRoutine = fn DWord(LongLong totalFileSize, LongLong totalBytesTransferred, LongLong streamSize, LongLong streamBytesTransferred, DWord dwStreamNumber, DWord dwCallbackReason, Handle hSourceFile, Handle hDestinationFile, LPVoid lpData);

// =======================================
// File API Constants
// =======================================

// Maximum path length
const int MAX_PATH = 260;

// File access rights
const DWord FILE_READ_DATA = 0x0001;
const DWord FILE_LIST_DIRECTORY = 0x0001;
const DWord FILE_WRITE_DATA = 0x0002;
const DWord FILE_ADD_FILE = 0x0002;
const DWord FILE_APPEND_DATA = 0x0004;
const DWord FILE_ADD_SUBDIRECTORY = 0x0004;
const DWord FILE_CREATE_PIPE_INSTANCE = 0x0004;
const DWord FILE_READ_EA = 0x0008;
const DWord FILE_WRITE_EA = 0x0010;
const DWord FILE_EXECUTE = 0x0020;
const DWord FILE_TRAVERSE = 0x0020;
const DWord FILE_DELETE_CHILD = 0x0040;
const DWord FILE_READ_ATTRIBUTES = 0x0080;
const DWord FILE_WRITE_ATTRIBUTES = 0x0100;

// Standard access rights
const DWord DELETE = 0x00010000;
const DWord READ_CONTROL = 0x00020000;
const DWord WRITE_DAC = 0x00040000;
const DWord WRITE_OWNER = 0x00080000;
const DWord SYNCHRONIZE = 0x00100000;
const DWord STANDARD_RIGHTS_REQUIRED = 0x000F0000;
const DWord STANDARD_RIGHTS_READ = READ_CONTROL;
const DWord STANDARD_RIGHTS_WRITE = READ_CONTROL;
const DWord STANDARD_RIGHTS_EXECUTE = READ_CONTROL;
const DWord STANDARD_RIGHTS_ALL = 0x001F0000;

// File-specific access rights
const DWord FILE_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | 0x1FF;
const DWord FILE_GENERIC_READ = STANDARD_RIGHTS_READ | FILE_READ_DATA | FILE_READ_ATTRIBUTES | FILE_READ_EA | SYNCHRONIZE;
const DWord FILE_GENERIC_WRITE = STANDARD_RIGHTS_WRITE | FILE_WRITE_DATA | FILE_WRITE_ATTRIBUTES | FILE_WRITE_EA | FILE_APPEND_DATA | SYNCHRONIZE;
const DWord FILE_GENERIC_EXECUTE = STANDARD_RIGHTS_EXECUTE | FILE_READ_ATTRIBUTES | FILE_EXECUTE | SYNCHRONIZE;

// File notification flags
const DWord FILE_NOTIFY_CHANGE_FILE_NAME = 0x00000001;
const DWord FILE_NOTIFY_CHANGE_DIR_NAME = 0x00000002;
const DWord FILE_NOTIFY_CHANGE_ATTRIBUTES = 0x00000004;
const DWord FILE_NOTIFY_CHANGE_SIZE = 0x00000008;
const DWord FILE_NOTIFY_CHANGE_LAST_WRITE = 0x00000010;
const DWord FILE_NOTIFY_CHANGE_LAST_ACCESS = 0x00000020;
const DWord FILE_NOTIFY_CHANGE_CREATION = 0x00000040;
const DWord FILE_NOTIFY_CHANGE_SECURITY = 0x00000100;

// File action types
const DWord FILE_ACTION_ADDED = 0x00000001;
const DWord FILE_ACTION_REMOVED = 0x00000002;
const DWord FILE_ACTION_MODIFIED = 0x00000003;
const DWord FILE_ACTION_RENAMED_OLD_NAME = 0x00000004;
const DWord FILE_ACTION_RENAMED_NEW_NAME = 0x00000005;

// File type constants
const DWord FILE_TYPE_UNKNOWN = 0x0000;
const DWord FILE_TYPE_DISK = 0x0001;
const DWord FILE_TYPE_CHAR = 0x0002;
const DWord FILE_TYPE_PIPE = 0x0003;
const DWord FILE_TYPE_REMOTE = 0x8000;

// Volume flags
const DWord FILE_CASE_SENSITIVE_SEARCH = 0x00000001;
const DWord FILE_CASE_PRESERVED_NAMES = 0x00000002;
const DWord FILE_UNICODE_ON_DISK = 0x00000004;
const DWord FILE_PERSISTENT_ACLS = 0x00000008;
const DWord FILE_FILE_COMPRESSION = 0x00000010;
const DWord FILE_VOLUME_QUOTAS = 0x00000020;
const DWord FILE_SUPPORTS_SPARSE_FILES = 0x00000040;
const DWord FILE_SUPPORTS_REPARSE_POINTS = 0x00000080;
const DWord FILE_SUPPORTS_REMOTE_STORAGE = 0x00000100;
const DWord FILE_VOLUME_IS_COMPRESSED = 0x00008000;
const DWord FILE_SUPPORTS_OBJECT_IDS = 0x00010000;
const DWord FILE_SUPPORTS_ENCRYPTION = 0x00020000;
const DWord FILE_NAMED_STREAMS = 0x00040000;
const DWord FILE_READ_ONLY_VOLUME = 0x00080000;
const DWord FILE_SEQUENTIAL_WRITE_ONCE = 0x00100000;
const DWord FILE_SUPPORTS_TRANSACTIONS = 0x00200000;
const DWord FILE_SUPPORTS_HARD_LINKS = 0x00400000;
const DWord FILE_SUPPORTS_EXTENDED_ATTRIBUTES = 0x00800000;
const DWord FILE_SUPPORTS_OPEN_BY_FILE_ID = 0x01000000;
const DWord FILE_SUPPORTS_USN_JOURNAL = 0x02000000;

// Replace file flags
const DWord REPLACEFILE_WRITE_THROUGH = 0x00000001;
const DWord REPLACEFILE_IGNORE_MERGE_ERRORS = 0x00000002;
const DWord REPLACEFILE_IGNORE_ACL_ERRORS = 0x00000004;

// GetFinalPathNameByHandle flags
const DWord FILE_NAME_NORMALIZED = 0x0;
const DWord FILE_NAME_OPENED = 0x8;
const DWord VOLUME_NAME_DOS = 0x0;
const DWord VOLUME_NAME_GUID = 0x1;
const DWord VOLUME_NAME_NT = 0x2;
const DWord VOLUME_NAME_NONE = 0x4;

// =======================================
// File API Structures
// =======================================
struct Win32FileAttributeData {
    DWord dwFileAttributes;
    DWord ftCreationTime_low;
    DWord ftCreationTime_high;
    DWord ftLastAccessTime_low;
    DWord ftLastAccessTime_high;
    DWord ftLastWriteTime_low;
    DWord ftLastWriteTime_high;
    DWord nFileSizeHigh;
    DWord nFileSizeLow;
}

struct Win32FindDataW {
    DWord dwFileAttributes;
    DWord ftCreationTime_low;
    DWord ftCreationTime_high;
    DWord ftLastAccessTime_low;
    DWord ftLastAccessTime_high;
    DWord ftLastWriteTime_low;
    DWord ftLastWriteTime_high;
    DWord nFileSizeHigh;
    DWord nFileSizeLow;
    DWord dwReserved0;
    DWord dwReserved1;
    ushort[260] cFileName;
    ushort[14] cAlternateFileName;
}


// Overlapped structure for async I/O
struct Overlapped {
    DWordPtr internal;
    DWordPtr internalHigh;
    union {
        struct {
            DWord offset;
            DWord offsetHigh;
        }
        void* pointer;
    }
    Handle hEvent;
}

// File notify information
struct FileNotifyInformation {
    DWord nextEntryOffset;
    DWord action;
    DWord fileNameLength;
    WChar[1] fileName;
}

// File basic info
struct FileBasicInfo {
    LongLong creationTime;
    LongLong lastAccessTime;
    LongLong lastWriteTime;
    LongLong changeTime;
    DWord fileAttributes;
}

// File standard info
struct FileStandardInfo {
    LongLong allocationSize;
    LongLong endOfFile;
    DWord numberOfLinks;
    Bool deletePending;
    Bool directory;
}

// File name info
struct FileNameInfo {
    DWord fileNameLength;
    WChar[1] fileName;
}

// File rename info
struct FileRenameInfo {
    Bool replaceIfExists;
    Handle rootDirectory;
    DWord fileNameLength;
    WChar[1] fileName;
}

// File disposition info
struct FileDispositionInfo {
    Bool deleteFile;
}

// File allocation info
struct FileAllocationInfo {
    LongLong allocationSize;
}

// File end of file info
struct FileEndOfFileInfo {
    LongLong endOfFile;
}

// File stream info
struct FileStreamInfo {
    DWord nextEntryOffset;
    DWord streamNameLength;
    LongLong streamSize;
    LongLong streamAllocationSize;
    WChar[1] streamName;
}

// File compression info
struct FileCompressionInfo {
    LongLong compressedFileSize;
    Word compressionFormat;
    char compressionUnitShift;
    char chunkShift;
    char clusterShift;
    char[3] reserved;
}

// File attribute tag info
struct FileAttributeTagInfo {
    DWord fileAttributes;
    DWord reparseTag;
}

// File ID both directory info
struct FileIdBothDirInfo {
    DWord nextEntryOffset;
    DWord fileIndex;
    LongLong creationTime;
    LongLong lastAccessTime;
    LongLong lastWriteTime;
    LongLong changeTime;
    LongLong endOfFile;
    LongLong allocationSize;
    DWord fileAttributes;
    DWord fileNameLength;
    DWord eaSize;
    char shortNameLength;
    WChar[12] shortName;
    LongLong fileId;
    WChar[1] fileName;
}

// File info by handle class enumeration
enum FileInfoByHandleClass : int {
    FILE_BASIC_INFO ,
    FILE_STANDARD_INFO ,
    FILE_NAME_INFO ,
    FILE_RENAME_INFO ,
    FILE_DISPOSITION_INFO ,
    FILE_ALLOCATION_INFO ,
    FILE_END_OF_FILE_INFO ,
    FILE_STREAM_INFO ,
    FILE_COMPRESSION_INFO ,
    FILE_ATTRIBUTE_TAG_INFO ,
    FILE_ID_BOTH_DIR_INFO ,
    FILE_ID_BOTH_DIR_RESTART_INFO ,
    FILE_IO_PRIORITY_HINT_INFO ,
    FILE_REMOTE_PROTOCOL_INFO ,
    FILE_FULL_DIR_INFO ,
    FILE_FULL_DIR_RESTART_INFO ,
    FILE_STORAGE_INFO ,
    FILE_ALIGNMENT_INFO ,
    FILE_ID_INFO ,
    FILE_ID_EXTD_DIR_INFO ,
    FILE_ID_EXTD_DIR_RESTART_INFO ,
    MAX_FILE_INFO_BY_HANDLE_CLASS ,
}

// =======================================
// File API Functions
// =======================================

// File creation and opening
extern fn Handle createFileA(
    LPCStr lpFileName, 
    DWord dwDesiredAccess, 
    DWord dwShareMode,
    void* lpSecurityAttributes, 
    DWord dwCreationDisposition,
    DWord dwFlagsAndAttributes, 
    Handle hTemplateFile
) @cname("CreateFileA");

extern fn Handle createFileW(
    LPCWStr lpFileName, 
    DWord dwDesiredAccess, 
    DWord dwShareMode,
    void* lpSecurityAttributes, 
    DWord dwCreationDisposition,
    DWord dwFlagsAndAttributes, 
    Handle hTemplateFile
) @cname("CreateFileW");

extern fn Handle createFile2(
    LPCWStr lpFileName, 
    DWord dwDesiredAccess, 
    DWord dwShareMode,
    DWord dwCreationDisposition, 
    void* pCreateExParams
) @cname("CreateFile2");

extern fn Handle reopenFile(
    Handle hOriginalFile, 
    DWord dwDesiredAccess, 
    DWord dwShareMode,
    DWord dwFlags
) @cname("ReOpenFile");

// File reading and writing
extern fn Bool readFile(
    Handle hFile, 
    LPVoid lpBuffer, 
    DWord nNumberOfBytesToRead,
    DWord* lpNumberOfBytesRead, 
    Overlapped* lpOverlapped
) @cname("ReadFile");

extern fn Bool readFileEx(
    Handle hFile, 
    LPVoid lpBuffer, 
    DWord nNumberOfBytesToRead,
    Overlapped* lpOverlapped, 
    LpoverlappedCompletionRoutine lpCompletionRoutine
) @cname("ReadFileEx");

extern fn Bool writeFile(
    Handle hFile, 
    LPCVoid lpBuffer, 
    DWord nNumberOfBytesToWrite,
    DWord* lpNumberOfBytesWritten, 
    Overlapped* lpOverlapped
) @cname("WriteFile");

extern fn Bool writeFileEx(
    Handle hFile, 
    LPCVoid lpBuffer, 
    DWord nNumberOfBytesToWrite,
    Overlapped* lpOverlapped,
    LpoverlappedCompletionRoutine lpCompletionRoutine
) @cname("WriteFileEx");

// File pointer manipulation
extern fn DWord setFilePointer(
    Handle hFile, 
    Long lDistanceToMove, 
    Long* lpDistanceToMoveHigh,
    DWord dwMoveMethod
) @cname("SetFilePointer");

extern fn Bool setFilePointerEx(
    Handle hFile, 
    LongLong liDistanceToMove,
    LongLong* lpNewFilePointer, 
    DWord dwMoveMethod
) @cname("SetFilePointerEx");

// File size
extern fn DWord getFileSize(
    Handle hFile, 
    DWord* lpFileSizeHigh
) @cname("GetFileSize");

extern fn Bool getFileSizeEx(
    Handle hFile, LongLong* lpFileSize
) @cname("GetFileSizeEx");

extern fn Bool setEndOfFile(
    Handle hFile
) @cname("SetEndOfFile");

extern fn Bool setFileValidData(
    Handle hFile, 
    LongLong validDataLength
) @cname("SetFileValidData");

// File type
extern fn DWord getFileType(
    Handle hFile
) @cname("GetFileType");

// File attributes
extern fn DWord getFileAttributesA(
    LPCStr lpFileName
) @cname("GetFileAttributesA");

extern fn DWord getFileAttributesW(
    LPCWStr lpFileName
) @cname("GetFileAttributesW");

extern fn Bool getFileAttributesExA(
    LPCStr lpFileName, 
    int fInfoLevelId, 
    LPVoid lpFileInformation
) @cname("GetFileAttributesExA");

extern fn Bool getFileAttributesExW(
    LPCWStr lpFileName, 
    int fInfoLevelId, 
    LPVoid lpFileInformation
) @cname("GetFileAttributesExW");

extern fn Bool setFileAttributesA(
    LPCStr lpFileName, 
    DWord dwFileAttributes
) @cname("SetFileAttributesA");

extern fn Bool setFileAttributesW(
    LPCWStr lpFileName, 
    DWord dwFileAttributes
) @cname("SetFileAttributesW");

// File time
extern fn Bool getFileTime(
    Handle hFile, 
    FileTime* lpCreationTime, 
    FileTime* lpLastAccessTime,
    FileTime* lpLastWriteTime
) @cname("GetFileTime");

extern fn Bool setFileTime(
    Handle hFile, 
    FileTime* lpCreationTime, 
    FileTime* lpLastAccessTime,
    FileTime* lpLastWriteTime
) @cname("SetFileTime");

// File information
extern fn Bool getFileInformationByHandle(
    Handle hFile, 
    ByHandleFileInformation* lpFileInformation
) @cname("GetFileInformationByHandle");

extern fn Bool getFileInformationByHandleEx(
    Handle hFile, 
    FileInfoByHandleClass fileInformationClass,
    LPVoid lpFileInformation, 
    DWord dwBufferSize
) @cname("GetFileInformationByHandleEx");

extern fn Bool setFileInformationByHandle(
    Handle hFile, 
    FileInfoByHandleClass fileInformationClass,
    LPVoid lpFileInformation, 
    DWord dwBufferSize
) @cname("SetFileInformationByHandle");

// File operations
extern fn Bool deleteFileA(
    LPCStr lpFileName
) @cname("DeleteFileA");

extern fn Bool deleteFileW(
    LPCWStr lpFileName
) @cname("DeleteFileW");

extern fn Bool copyFileA(
    LPCStr lpExistingFileName, 
    LPCStr lpNewFileName, 
    Bool bFailIfExists
) @cname("CopyFileA");

extern fn Bool copyFileW(
    LPCWStr lpExistingFileName, 
    LPCWStr lpNewFileName, 
    Bool bFailIfExists
) @cname("CopyFileW");

extern fn Bool copyFileExA(
    LPCStr lpExistingFileName, 
    LPCStr lpNewFileName,
    LpprogressRoutine lpProgressRoutine,
    LPVoid lpData, 
    Bool* pbCancel, 
    DWord dwCopyFlags
) @cname("CopyFileExA");

extern fn Bool copyFileExW(
    LPCWStr lpExistingFileName, 
    LPCWStr lpNewFileName,
    LpprogressRoutine lpProgressRoutine,
    LPVoid lpData, 
    Bool* pbCancel, 
    DWord dwCopyFlags
) @cname("CopyFileExW");

extern fn Bool moveFileA(
    LPCStr lpExistingFileName, 
    LPCStr lpNewFileName
) @cname("MoveFileA");

extern fn Bool moveFileW(
    LPCWStr lpExistingFileName, 
    LPCWStr lpNewFileName
) @cname("MoveFileW");

extern fn Bool moveFileExA(
    LPCStr lpExistingFileName, 
    LPCStr lpNewFileName, 
    DWord dwFlags
) @cname("MoveFileExA");

extern fn Bool moveFileExW(
    LPCWStr lpExistingFileName, 
    LPCWStr lpNewFileName, 
    DWord dwFlags
) @cname("MoveFileExW");

extern fn Bool replaceFileA(
    LPCStr lpReplacedFileName, 
    LPCStr lpReplacementFileName,
    LPCStr lpBackupFileName, 
    DWord dwReplaceFlags,
    LPVoid lpExclude, 
    LPVoid lpReserved
) @cname("ReplaceFileA");

extern fn Bool replaceFileW(
    LPCWStr lpReplacedFileName, 
    LPCWStr lpReplacementFileName,
    LPCWStr lpBackupFileName, 
    DWord dwReplaceFlags,
    LPVoid lpExclude, 
    LPVoid lpReserved
) @cname("ReplaceFileW");

// File locking
extern fn Bool lockFile(
    Handle hFile, 
    DWord dwFileOffsetLow, 
    DWord dwFileOffsetHigh,
    DWord nNumberOfBytesToLockLow, 
    DWord nNumberOfBytesToLockHigh
) @cname("LockFile");

extern fn Bool unlockFile(
    Handle hFile, 
    DWord dwFileOffsetLow, 
    DWord dwFileOffsetHigh,
    DWord nNumberOfBytesToUnlockLow, 
    DWord nNumberOfBytesToUnlockHigh
) @cname("UnlockFile");

extern fn Bool lockFileEx(
    Handle hFile, 
    DWord dwFlags, 
    DWord dwReserved,
    DWord nNumberOfBytesToLockLow, 
    DWord nNumberOfBytesToLockHigh,
    Overlapped* lpOverlapped
) @cname("LockFileEx");

extern fn Bool unlockFileEx(
    Handle hFile, 
    DWord dwReserved,
    DWord nNumberOfBytesToUnlockLow, 
    DWord nNumberOfBytesToUnlockHigh,
    Overlapped* lpOverlapped
) @cname("UnlockFileEx");

// File flushing
extern fn Bool flushFileBuffers(Handle hFile) @cname("FlushFileBuffers");

// File path operations
extern fn DWord getFullPathNameA(
    LPCStr lpFileName, 
    DWord nBufferLength, 
    LPStr lpBuffer,
    LPStr* lpFilePart
) @cname("GetFullPathNameA");

extern fn DWord getFullPathNameW(
    LPCWStr lpFileName, 
    DWord nBufferLength, 
    LPWStr lpBuffer,
    LPWStr* lpFilePart
) @cname("GetFullPathNameW");

extern fn DWord getFinalPathNameByHandleA(
    Handle hFile, 
    LPStr lpszFilePath, 
    DWord cchFilePath,
    DWord dwFlags
) @cname("GetFinalPathNameByHandleA");

extern fn DWord getFinalPathNameByHandleW(
    Handle hFile, 
    LPWStr lpszFilePath, 
    DWord cchFilePath,
    DWord dwFlags
) @cname("GetFinalPathNameByHandleW");

extern fn DWord getLongPathNameA(LPCStr lpszShortPath, LPStr lpszLongPath, DWord cchBuffer) @cname("GetLongPathNameA");
extern fn DWord getLongPathNameW(LPCWStr lpszShortPath, LPWStr lpszLongPath, DWord cchBuffer) @cname("GetLongPathNameW");

extern fn DWord getShortPathNameA(LPCStr lpszLongPath, LPStr lpszShortPath, DWord cchBuffer) @cname("GetShortPathNameA");
extern fn DWord getShortPathNameW(LPCWStr lpszLongPath, LPWStr lpszShortPath, DWord cchBuffer) @cname("GetShortPathNameW");

// Directory operations
extern fn Bool createDirectoryA(LPCStr lpPathName, void* lpSecurityAttributes) @cname("CreateDirectoryA");
extern fn Bool createDirectoryW(LPCWStr lpPathName, void* lpSecurityAttributes) @cname("CreateDirectoryW");

extern fn Bool createDirectoryExA(
    LPCStr lpTemplateDirectory, 
    LPCStr lpNewDirectory,
    void* lpSecurityAttributes
) @cname("CreateDirectoryExA");

extern fn Bool createDirectoryExW(
    LPCWStr lpTemplateDirectory, 
    LPCWStr lpNewDirectory,
    void* lpSecurityAttributes
) @cname("CreateDirectoryExW");

extern fn Bool removeDirectoryA(LPCStr lpPathName) @cname("RemoveDirectoryA");
extern fn Bool removeDirectoryW(LPCWStr lpPathName) @cname("RemoveDirectoryW");

extern fn DWord getCurrentDirectoryA(DWord nBufferLength, LPStr lpBuffer) @cname("GetCurrentDirectoryA");
extern fn DWord getCurrentDirectoryW(DWord nBufferLength, LPWStr lpBuffer) @cname("GetCurrentDirectoryW");

extern fn Bool setCurrentDirectoryA(LPCStr lpPathName) @cname("SetCurrentDirectoryA");
extern fn Bool setCurrentDirectoryW(LPCWStr lpPathName) @cname("SetCurrentDirectoryW");

// File search operations
extern fn Handle findFirstFileA(
    LPCStr lpFileName, 
    Win32FindDataA* lpFindFileData
) @cname("FindFirstFileA");

extern fn Handle findFirstFileW(
    LPCWStr lpFileName, 
    Win32FindDataW* lpFindFileData
) @cname("FindFirstFileW");

extern fn Handle findFirstFileExA(
    LPCStr lpFileName, 
    int fInfoLevelId, 
    LPVoid lpFindFileData,
    int fSearchOp, 
    LPVoid lpSearchFilter, 
    DWord dwAdditionalFlags
) @cname("FindFirstFileExA");

extern fn Handle findFirstFileExW(
    LPCWStr lpFileName, 
    int fInfoLevelId, 
    LPVoid lpFindFileData,
    int fSearchOp, 
    LPVoid lpSearchFilter, 
    DWord dwAdditionalFlags
) @cname("FindFirstFileExW");

extern fn Bool findNextFileA(
    Handle hFindFile, 
    Win32FindDataA* lpFindFileData
) @cname("FindNextFileA");

extern fn Bool findNextFileW(
    Handle hFindFile,
    Win32FindDataW* lpFindFileData
) @cname("FindNextFileW");

extern fn Bool findClose(Handle hFindFile) @cname("FindClose");

// Change notification
extern fn Handle findFirstChangeNotificationA(
    LPCStr lpPathName, 
    Bool bWatchSubtree,
    DWord dwNotifyFilter
) @cname("FindFirstChangeNotificationA");

extern fn Handle findFirstChangeNotificationW(
    LPCWStr lpPathName, 
    Bool bWatchSubtree,
    DWord dwNotifyFilter
) @cname("FindFirstChangeNotificationW");

extern fn Bool findNextChangeNotification(
    Handle hChangeHandle
) @cname("FindNextChangeNotification");

extern fn Bool findCloseChangeNotification(
    Handle hChangeHandle
) @cname("FindCloseChangeNotification");

extern fn Bool readDirectoryChangesW(
    Handle hDirectory, 
    LPVoid lpBuffer, 
    DWord nBufferLength,
    Bool bWatchSubtree, 
    DWord dwNotifyFilter,
    DWord* lpBytesReturned, 
    Overlapped* lpOverlapped,
    LpoverlappedCompletionRoutine lpCompletionRoutine
) @cname("ReadDirectoryChangesW");

// Volume operations
extern fn Bool getVolumeInformationA(
    LPCStr lpRootPathName, 
    LPStr lpVolumeNameBuffer,
    DWord nVolumeNameSize, 
    DWord* lpVolumeSerialNumber,
    DWord* lpMaximumComponentLength, 
    DWord* lpFileSystemFlags,
    LPStr lpFileSystemNameBuffer, 
    DWord nFileSystemNameSize
) @cname("GetVolumeInformationA");

extern fn Bool getVolumeInformationW(
    LPCWStr lpRootPathName, 
    LPWStr lpVolumeNameBuffer,
    DWord nVolumeNameSize, 
    DWord* lpVolumeSerialNumber,
    DWord* lpMaximumComponentLength, 
    DWord* lpFileSystemFlags,
    LPWStr lpFileSystemNameBuffer, 
    DWord nFileSystemNameSize
) @cname("GetVolumeInformationW");

extern fn Bool getVolumeInformationByHandleW(
    Handle hFile, 
    LPWStr lpVolumeNameBuffer,
    DWord nVolumeNameSize, 
    DWord* lpVolumeSerialNumber,
    DWord* lpMaximumComponentLength, 
    DWord* lpFileSystemFlags,
    LPWStr lpFileSystemNameBuffer, 
    DWord nFileSystemNameSize
) @cname("GetVolumeInformationByHandleW");

extern fn Bool getVolumePathNameA(
    LPCStr lpszFileName, 
    LPStr lpszVolumePathName, 
    DWord cchBufferLength
) @cname("GetVolumePathNameA");

extern fn Bool getVolumePathNameW(
    LPCWStr lpszFileName, 
    LPWStr lpszVolumePathName, 
    DWord cchBufferLength
) @cname("GetVolumePathNameW");

extern fn Bool getVolumeNameForVolumeMountPointA(
    LPCStr lpszVolumeMountPoint, 
    LPStr lpszVolumeName,
    DWord cchBufferLength
) @cname("GetVolumeNameForVolumeMountPointA");

extern fn Bool getVolumeNameForVolumeMountPointW(
    LPCWStr lpszVolumeMountPoint, 
    LPWStr lpszVolumeName,
    DWord cchBufferLength
) @cname("GetVolumeNameForVolumeMountPointW");

extern fn Bool getVolumePathNamesForVolumeNameA(
    LPCStr lpszVolumeName, 
    LPStr lpszVolumePathNames,
    DWord cchBufferLength, 
    DWord* lpcchReturnLength
) @cname("GetVolumePathNamesForVolumeNameA");

extern fn Bool getVolumePathNamesForVolumeNameW(
    LPCWStr lpszVolumeName, 
    LPWStr lpszVolumePathNames,
    DWord cchBufferLength, 
    DWord* lpcchReturnLength
) @cname("GetVolumePathNamesForVolumeNameW");

// Disk space information
extern fn Bool getDiskFreeSpaceA(
    LPCStr lpRootPathName, 
    DWord* lpSectorsPerCluster,
    DWord* lpBytesPerSector, 
    DWord* lpNumberOfFreeClusters,
    DWord* lpTotalNumberOfClusters
) @cname("GetDiskFreeSpaceA");

extern fn Bool getDiskFreeSpaceW(
    LPCWStr lpRootPathName, 
    DWord* lpSectorsPerCluster,
    DWord* lpBytesPerSector, 
    DWord* lpNumberOfFreeClusters,
    DWord* lpTotalNumberOfClusters
) @cname("GetDiskFreeSpaceW");

extern fn Bool getDiskFreeSpaceExA(
    LPCStr lpDirectoryName, 
    ULongLong* lpFreeBytesAvailableToCaller,
    ULongLong* lpTotalNumberOfBytes, 
    ULongLong* lpTotalNumberOfFreeBytes
) @cname("GetDiskFreeSpaceExA");
                                   
extern fn Bool getDiskFreeSpaceExW(
    LPCWStr lpDirectoryName, 
    ULongLong* lpFreeBytesAvailableToCaller,
    ULongLong* lpTotalNumberOfBytes, 
    ULongLong* lpTotalNumberOfFreeBytes
) @cname("GetDiskFreeSpaceExW");

// Drive type
extern fn uint getDriveTypeA(
    LPCStr lpRootPathName
) @cname("GetDriveTypeA");

extern fn uint getDriveTypeW(
    LPCWStr lpRootPathName
) @cname("GetDriveTypeW");

// Logical drives
extern fn DWord getLogicalDrives() @cname("GetLogicalDrives");

extern fn DWord getLogicalDriveStringsA(
    DWord nBufferLength, 
    LPStr lpBuffer
) @cname("GetLogicalDriveStringsA");

extern fn DWord getLogicalDriveStringsW(
    DWord nBufferLength, 
    LPWStr lpBuffer
) @cname("GetLogicalDriveStringsW");

// Temporary files
extern fn uint getTempPathA(
    DWord nBufferLength, 
    LPStr lpBuffer
) @cname("GetTempPathA");

extern fn uint getTempPathW(
    DWord nBufferLength, 
    LPWStr lpBuffer
) @cname("GetTempPathW");

extern fn uint getTempFileNameA(
    LPCStr lpPathName,
    LPCStr lpPrefixString, 
    uint uUnique, 
    LPStr lpTempFileName
) @cname("GetTempFileNameA");

extern fn uint getTempFileNameW(
    LPCWStr lpPathName, 
    LPCWStr lpPrefixString, 
    uint uUnique, 
    LPWStr lpTempFileName
) @cname("GetTempFileNameW");

// File comparison
extern fn Bool areFileApisANSI() @cname("AreFileApisANSI");
extern fn void setFileApisToOEM() @cname("SetFileApisToOEM");
extern fn void setFileApisToANSI() @cname("SetFileApisToANSI");

// Definition file for file streams
extern fn Handle openFileById(
    Handle hVolumeHint, 
    void* lpFileId, 
    DWord dwDesiredAccess,
    DWord dwShareMode, 
    void* lpSecurityAttributes, 
    DWord dwFlagsAndAttributes
) @cname("OpenFileById");

// ====================================
// Drive Type Constants
// ===================================


const uint DRIVE_UNKNOWN = 0;
const uint DRIVE_NO_ROOT_DIR = 1;
const uint DRIVE_REMOVABLE = 2;
const uint DRIVE_FIXED = 3;
const uint DRIVE_REMOTE = 4;
const uint DRIVE_CDROM = 5;
const uint DRIVE_RAMDISK = 6;

// =====================================
// MoveFile Flags
// =====================================

const DWord MOVEFILE_REPLACE_EXISTING = 0x00000001;
const DWord MOVEFILE_COPY_ALLOWED = 0x00000002;
const DWord MOVEFILE_DELAY_UNTIL_REBOOT = 0x00000004;
const DWord MOVEFILE_WRITE_THROUGH = 0x00000008;
const DWord MOVEFILE_CREATE_HARDLINK = 0x00000010;
const DWord MOVEFILE_FAIL_IF_NOT_TRACKABLE = 0x00000020;

// =======================================
// CopyFile Flags
// =======================================

const DWord COPY_FILE_FAIL_IF_EXISTS = 0x00000001;
const DWord COPY_FILE_RESTARTABLE = 0x00000002;
const DWord COPY_FILE_OPEN_SOURCE_FOR_WRITE = 0x00000004;
const DWord COPY_FILE_ALLOW_DECRYPTED_DESTINATION = 0x00000008;
const DWord COPY_FILE_COPY_SYMLINK = 0x00000800;
const DWord COPY_FILE_NO_BUFFERING = 0x00001000;

// =======================================
// LockFile Flags
// =======================================

const DWord LOCKFILE_FAIL_IMMEDIATELY = 0x00000001;
const DWord LOCKFILE_EXCLUSIVE_LOCK = 0x00000002;
