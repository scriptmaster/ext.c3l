// stddef.h.c3
module stddef;

alias Size = usz;
alias Ssize = isz;

alias UintPtr = uptr;
alias PtrDiff = isz;
alias Wchar = uint;

alias Uint8 = char;
alias Uint16 = ushort;
alias Uint32 = uint;
alias Uint64 = ulong;

alias Int8 = ichar;
alias Int16 = short;
alias Int32 = int;
alias Int64 = long;

macro offsetof($Type, $member) {
    $Type.$member.offset;
}
