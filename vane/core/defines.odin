package core

u_size      :: uint;
u_ptr       :: uintptr;
u_ptr_diff  :: int;

// Used for byte sizes
KB :: #force_inline proc (x: u64) -> u64 { return 1024 * x }
MB :: #force_inline proc (x: u64) -> u64 { return 1024 * 1024 * x }
GB :: #force_inline proc (x: u64) -> u64 { return 1024 * 1024 * 1024 * x }

// Used for bit masking
BIT :: #force_inline proc (x: u64) -> u64 { return 1 << x }

