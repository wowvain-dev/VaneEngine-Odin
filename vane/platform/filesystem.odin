package platform

import "core:fmt"

import "../core"

// filesystem_write :: proc (handle: ^file_handle, data_size: u64, data: rawptr, out_bytes_written: ^u64) -> bool;

/*
    Holds a handle to a file.
*/
file_handle :: struct {
    /*
        Opaque handle to internal file handle.
    */
    handle: rawptr,
    /*
        Indicates if this handle is valid.
    */
    is_valid: bool
}

/*
    File open modes. Can be combined.
*/
file_modes :: enum {
    /** Read mode */
    FILE_MODE_READ = 0x1,
    /** Write mode */
    FILE_MODE_WRITE = 0x2
}

logger_system_state :: struct {
    log_file_handle: file_handle
}

state_ptr : ^logger_system_state;

append_to_log_file :: proc (message: ^string) {
    if (state_ptr != nil && state_ptr.log_file_handle.is_valid) {
        length: u64 = u64(len(message));
        written: u64 = 0;

        if (!filesystem_write(&state_ptr.log_file_handle, length, rawptr(message), &written)) {
            fmt.eprint("ERROR writing to console.log.", core.LOG_LEVEL.V_ERROR)
        }
    }
}

/*
    If `func` is false, closes the provided file handle and logs an error.
*/
close_if_failed :: #force_inline proc (
    func: bool,
    handle: ^file_handle
) -> bool {
    if (!func) {
        //ERROR
        filesystem_close(handle);
        return false;
    }
    return true;
}

/*
    Checks if a file with the given path exists.
*/
filesystem_exists :: proc (
    path: string
) -> bool {
    return false;
}

/*
    Attempt to open file located at path.
*/
filesystem_open :: proc (
    path: string,
    mode: file_modes,
    binary: bool,
    out_handle: ^file_handle
) -> bool {
    return false;
}


/*
    Closes the provided handle to a file.
*/
filesystem_close :: proc (handle: ^file_handle) {

}

/*
    Attempts to read the size of the file to which handle is attached
*/
filesystem_size :: proc (handle: ^file_handle, out_size: ^u64) -> bool {
    return false;
}

filesystem_read_line :: proc (
    handle: ^file_handle,
    max_length: u64,
    line_buf: ^string,
    out_line_length: u64
) -> bool {
    return false;
}

filesystem_write_line :: proc (
    handle: ^file_handle,
    text: string
) -> bool {
    return false;
}

filesystem_read :: proc (
    handle: ^file_handle,
    data_size: u64,
    out_data: rawptr,
    out_bytes_read: ^u64
) -> bool {
    return false;
}

filesystem_read_all_bytes :: proc (
    handle: ^file_handle,
    out_bytes: ^u8,
    out_bytes_read: ^u64
) -> bool {
    return false;
}

filesystem_read_all_text :: proc ( 
    handle: ^file_handle,
    out_text: string,
    out_bytes_read: ^u64
) -> bool {
    return false;
}

filesystem_write :: proc (
    handle: ^file_handle,
    data_size: u64,
    data: rawptr, 
    out_bytes_written: ^u64
) -> bool {
    return false;
}
