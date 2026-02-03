module synchapi @if(env::WIN32);

// Windows Synchronization API
// C3 mapping for synchapi.h

// Common Windows types
alias Handle = void*;
alias DWord = uint;
alias Bool = int;
alias PVoid = void*;
alias Long = int;
alias ULong = uint;
alias LongPtr = iptr;
alias ULongPtr = uptr;

// Wait result constants
const uint WAIT_OBJECT_0 = 0x00000000;
const uint WAIT_ABANDONED = 0x00000080;
const uint WAIT_TIMEOUT = 0x00000102;
const uint WAIT_FAILED = 0xFFFFFFFF;
const uint WAIT_IO_COMPLETION = 0x000000C0;

// Infinite timeout
const uint INFINITE = 0xFFFFFFFF;

// Mutex access rights
const uint MUTEX_ALL_ACCESS = 0x001F0001;
const uint MUTEX_MODIFY_STATE = 0x0001;

// Semaphore access rights
const uint SEMAPHORE_ALL_ACCESS = 0x001F0003;
const uint SEMAPHORE_MODIFY_STATE = 0x0002;

// Event access rights
const uint EVENT_ALL_ACCESS = 0x001F0003;
const uint EVENT_MODIFY_STATE = 0x0002;

// Timer access rights
const uint TIMER_ALL_ACCESS = 0x001F0003;
const uint TIMER_MODIFY_STATE = 0x0002;
const uint TIMER_QUERY_STATE = 0x0001;

// Synchronization barrier flags
const uint SYNCHRONIZATION_BARRIER_FLAGS_SPIN_ONLY = 0x01;
const uint SYNCHRONIZATION_BARRIER_FLAGS_BLOCK_ONLY = 0x02;
const uint SYNCHRONIZATION_BARRIER_FLAGS_NO_DELETE = 0x04;

// Critical section spin count
const uint CRITICAL_SECTION_NO_DEBUG_INFO = 0x01000000;

// Structures
struct CriticalSection {
    PVoid debug_info;
    Long lock_count;
    Long recursion_count;
    Handle owning_thread;
    Handle lock_semaphore;
    ULongPtr spin_count;
}

struct CriticalSectionAndSpinCount {
    CriticalSection critical_section;
    DWord spin_count;
}

struct SRWLock {
    PVoid ptr;
}

struct ConditionVariable {
    PVoid ptr;
}

struct SynchronizationBarrier {
    DWord reserved1;
    DWord reserved2;
    ULongPtr[2] reserved3;
    DWord reserved4;
    DWord reserved5;
}

struct SecurityAttributes {
    DWord length;
    PVoid security_descriptor;
    Bool inherit_handle;
}

struct Reason {
    DWord flags;
    union reason {
        struct detailed {
            Handle resource_file_name_module;
            short* resource_reason_id;
        } 
        char* simple_reason_string;
    }
}

// Critical Section Functions
extern fn void initialize_critical_section(CriticalSection* critical_section) @cname("InitializeCriticalSection");

extern fn void initialize_critical_section_and_spin_count(
    CriticalSection* critical_section,
    DWord spin_count
) @cname("InitializeCriticalSectionAndSpinCount");

extern fn Bool initialize_critical_section_ex(
    CriticalSection* critical_section,
    DWord spin_count,
    DWord flags
) @cname("InitializeCriticalSectionEx");

extern fn DWord set_critical_section_spin_count(
    CriticalSection* critical_section,
    DWord spin_count
) @cname("SetCriticalSectionSpinCount");

extern fn void enter_critical_section(CriticalSection* critical_section) @cname("EnterCriticalSection");

extern fn Bool try_enter_critical_section(CriticalSection* critical_section) @cname("TryEnterCriticalSection");

extern fn void leave_critical_section(CriticalSection* critical_section) @cname("LeaveCriticalSection");

extern fn void delete_critical_section(CriticalSection* critical_section) @cname("DeleteCriticalSection");

// SRW Lock Functions
extern fn void initialize_srw_lock(SRWLock* srw_lock) @cname("InitializeSRWLock");

extern fn void acquire_srw_lock_exclusive(SRWLock* srw_lock) @cname("AcquireSRWLockExclusive");

extern fn Bool try_acquire_srw_lock_exclusive(SRWLock* srw_lock) @cname("TryAcquireSRWLockExclusive");

extern fn void release_srw_lock_exclusive(SRWLock* srw_lock) @cname("ReleaseSRWLockExclusive");

extern fn void acquire_srw_lock_shared(SRWLock* srw_lock) @cname("AcquireSRWLockShared");

extern fn Bool try_acquire_srw_lock_shared(SRWLock* srw_lock) @cname("TryAcquireSRWLockShared");

extern fn void release_srw_lock_shared(SRWLock* srw_lock) @cname("ReleaseSRWLockShared");

// Condition Variable Functions
extern fn void initialize_condition_variable(ConditionVariable* condition_variable) @cname("InitializeConditionVariable");

extern fn void wake_condition_variable(ConditionVariable* condition_variable) @cname("WakeConditionVariable");

extern fn void wake_all_condition_variable(ConditionVariable* condition_variable) @cname("WakeAllConditionVariable");

extern fn Bool sleep_condition_variable_cs(
    ConditionVariable* condition_variable,
    CriticalSection* critical_section,
    DWord milliseconds
) @cname("SleepConditionVariableCS");

extern fn Bool sleep_condition_variable_srw(
    ConditionVariable* condition_variable,
    SRWLock* srw_lock,
    DWord milliseconds,
    ULong flags
) @cname("SleepConditionVariableSRW");

// Mutex Functions
extern fn Handle create_mutex_a(
    SecurityAttributes* mutex_attributes,
    Bool initial_owner,
    char* name
) @cname("CreateMutexA");

extern fn Handle create_mutex_w(
    SecurityAttributes* mutex_attributes,
    Bool initial_owner,
    short* name
) @cname("CreateMutexW");

extern fn Handle create_mutex_ex_a(
    SecurityAttributes* mutex_attributes,
    char* name,
    DWord flags,
    DWord desired_access
) @cname("CreateMutexExA");

extern fn Handle create_mutex_ex_w(
    SecurityAttributes* mutex_attributes,
    short* name,
    DWord flags,
    DWord desired_access
) @cname("CreateMutexExW");

extern fn Handle open_mutex_a(
    DWord desired_access,
    Bool inherit_handle,
    char* name
) @cname("OpenMutexA");

extern fn Handle open_mutex_w(
    DWord desired_access,
    Bool inherit_handle,
    short* name
) @cname("OpenMutexW");

extern fn Bool release_mutex(Handle mutex) @cname("ReleaseMutex");

// Semaphore Functions
extern fn Handle create_semaphore_a(
    SecurityAttributes* semaphore_attributes,
    Long initial_count,
    Long maximum_count,
    char* name
) @cname("CreateSemaphoreA");

extern fn Handle create_semaphore_w(
    SecurityAttributes* semaphore_attributes,
    Long initial_count,
    Long maximum_count,
    short* name
) @cname("CreateSemaphoreW");

extern fn Handle create_semaphore_ex_a(
    SecurityAttributes* semaphore_attributes,
    Long initial_count,
    Long maximum_count,
    char* name,
    DWord flags,
    DWord desired_access
) @cname("CreateSemaphoreExA");

extern fn Handle create_semaphore_ex_w(
    SecurityAttributes* semaphore_attributes,
    Long initial_count,
    Long maximum_count,
    short* name,
    DWord flags,
    DWord desired_access
) @cname("CreateSemaphoreExW");

extern fn Handle open_semaphore_a(
    DWord desired_access,
    Bool inherit_handle,
    char* name
) @cname("OpenSemaphoreA");

extern fn Handle open_semaphore_w(
    DWord desired_access,
    Bool inherit_handle,
    short* name
) @cname("OpenSemaphoreW");

extern fn Bool release_semaphore(
    Handle semaphore,
    Long release_count,
    Long* previous_count
) @cname("ReleaseSemaphore");

// Event Functions
extern fn Handle create_event_a(
    SecurityAttributes* event_attributes,
    Bool manual_reset,
    Bool initial_state,
    char* name
) @cname("CreateEventA");

extern fn Handle create_event_w(
    SecurityAttributes* event_attributes,
    Bool manual_reset,
    Bool initial_state,
    short* name
) @cname("CreateEventW");

extern fn Handle create_event_ex_a(
    SecurityAttributes* event_attributes,
    char* name,
    DWord flags,
    DWord desired_access
) @cname("CreateEventExA");

extern fn Handle create_event_ex_w(
    SecurityAttributes* event_attributes,
    short* name,
    DWord flags,
    DWord desired_access
) @cname("CreateEventExW");

extern fn Handle open_event_a(
    DWord desired_access,
    Bool inherit_handle,
    char* name
) @cname("OpenEventA");

extern fn Handle open_event_w(
    DWord desired_access,
    Bool inherit_handle,
    short* name
) @cname("OpenEventW");

extern fn Bool set_event(Handle event) @cname("SetEvent");

extern fn Bool reset_event(Handle event) @cname("ResetEvent");

extern fn Bool pulse_event(Handle event) @cname("PulseEvent");

// Waitable Timer Functions
extern fn Handle create_waitable_timer_a(
    SecurityAttributes* timer_attributes,
    Bool manual_reset,
    char* timer_name
) @cname("CreateWaitableTimerA");

extern fn Handle create_waitable_timer_w(
    SecurityAttributes* timer_attributes,
    Bool manual_reset,
    short* timer_name
) @cname("CreateWaitableTimerW");

extern fn Handle create_waitable_timer_ex_a(
    SecurityAttributes* timer_attributes,
    char* timer_name,
    DWord flags,
    DWord desired_access
) @cname("CreateWaitableTimerExA");

extern fn Handle create_waitable_timer_ex_w(
    SecurityAttributes* timer_attributes,
    short* timer_name,
    DWord flags,
    DWord desired_access
) @cname("CreateWaitableTimerExW");

extern fn Handle open_waitable_timer_a(
    DWord desired_access,
    Bool inherit_handle,
    char* timer_name
) @cname("OpenWaitableTimerA");

extern fn Handle open_waitable_timer_w(
    DWord desired_access,
    Bool inherit_handle,
    short* timer_name
) @cname("OpenWaitableTimerW");

extern fn Bool set_waitable_timer(
    Handle timer,
    long* due_time,
    Long period,
    void* completion_routine,
    PVoid arg_to_completion_routine,
    Bool resume
) @cname("SetWaitableTimer");

extern fn Bool set_waitable_timer_ex(
    Handle timer,
    long* due_time,
    Long period,
    void* completion_routine,
    PVoid arg_to_completion_routine,
    Reason* wake_context,
    ULong tolerable_delay
) @cname("SetWaitableTimerEx");

extern fn Bool cancel_waitable_timer(Handle timer) @cname("CancelWaitableTimer");

// Wait Functions
extern fn DWord wait_for_single_object(Handle handle, DWord milliseconds) @cname("WaitForSingleObject");

extern fn DWord wait_for_single_object_ex(
    Handle handle,
    DWord milliseconds,
    Bool alertable
) @cname("WaitForSingleObjectEx");

extern fn DWord wait_for_multiple_objects(
    DWord count,
    Handle* handles,
    Bool wait_all,
    DWord milliseconds
) @cname("WaitForMultipleObjects");

extern fn DWord wait_for_multiple_objects_ex(
    DWord count,
    Handle* handles,
    Bool wait_all,
    DWord milliseconds,
    Bool alertable
) @cname("WaitForMultipleObjectsEx");

extern fn DWord signal_object_and_wait(
    Handle object_to_signal,
    Handle object_to_wait_on,
    DWord milliseconds,
    Bool alertable
) @cname("SignalObjectAndWait");

extern fn DWord wait_on_address(
    void* address,
    PVoid compare_address,
    ulong address_size,
    DWord milliseconds
) @cname("WaitOnAddress");

extern fn void wake_by_address_all(PVoid address) @cname("WakeByAddressAll");

extern fn void wake_by_address_single(PVoid address) @cname("WakeByAddressSingle");

// Synchronization Barrier Functions
extern fn Bool initialize_synchronization_barrier(
    SynchronizationBarrier* barrier,
    Long total_threads,
    Long spin_count
) @cname("InitializeSynchronizationBarrier");

extern fn Bool enter_synchronization_barrier(
    SynchronizationBarrier* barrier,
    DWord flags
) @cname("EnterSynchronizationBarrier");

extern fn Bool delete_synchronization_barrier(SynchronizationBarrier* barrier) @cname("DeleteSynchronizationBarrier");

// Sleep Functions
extern fn void sleep(DWord milliseconds) @cname("Sleep");

extern fn DWord sleep_ex(DWord milliseconds, Bool alertable) @cname("SleepEx");

// Interlocked Functions (basic ones in synchapi)
extern fn Long interlocked_increment(Long* addend) @cname("InterlockedIncrement");

extern fn Long interlocked_decrement(Long* addend) @cname("InterlockedDecrement");

extern fn Long interlocked_exchange(Long* target, Long value) @cname("InterlockedExchange");

extern fn Long interlocked_exchange_add(Long* addend, Long value) @cname("InterlockedExchangeAdd");

extern fn Long interlocked_compare_exchange(
    Long* destination,
    Long exchange,
    Long comparand
) @cname("InterlockedCompareExchange");

extern fn PVoid interlocked_compare_exchange_pointer(
    PVoid* destination,
    PVoid exchange,
    PVoid comparand
) @cname("InterlockedCompareExchangePointer");

extern fn PVoid interlocked_exchange_pointer(
    PVoid* target,
    PVoid value
) @cname("InterlockedExchangePointer");

// Once initialization
struct InitOnce {
    PVoid ptr;
}

alias InitOnceCallback = fn Bool(InitOnce*, PVoid, PVoid*);

extern fn void init_once_initialize(InitOnce* init_once) @cname("InitOnceInitialize");

extern fn Bool init_once_execute_once(
    InitOnce* init_once,
    InitOnceCallback init_fn,
    PVoid parameter,
    PVoid* context
) @cname("InitOnceExecuteOnce");

extern fn Bool init_once_begin_initialize(
    InitOnce* init_once,
    DWord flags,
    Bool* pending,
    PVoid* context
) @cname("InitOnceBeginInitialize");

extern fn Bool init_once_complete(
    InitOnce* init_once,
    DWord flags,
    PVoid context
) @cname("InitOnceComplete");

// InitOnce flags
const uint INIT_ONCE_STATIC_INIT = 0;
const uint INIT_ONCE_CHECK_ONLY = 0x00000001;
const uint INIT_ONCE_ASYNC = 0x00000002;
const uint INIT_ONCE_INIT_FAILED = 0x00000004;
const uint INIT_ONCE_CTX_RESERVED_BITS = 2;

// Event flags
const uint CREATE_EVENT_INITIAL_SET = 0x00000002;
const uint CREATE_EVENT_MANUAL_RESET = 0x00000001;

// Mutex flags
const uint CREATE_MUTEX_INITIAL_OWNER = 0x00000001;

// Condition Variable flags
const uint CONDITION_VARIABLE_LOCKMODE_SHARED = 0x00000001;

// Maximum wait objects
const uint MAXIMUM_WAIT_OBJECTS = 64;
