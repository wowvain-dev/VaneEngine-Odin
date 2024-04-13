package core
import "core:fmt"

LOG_LEVEL :: enum {
    V_FATAL = 0,
    V_ERROR = 1,
    V_WARN = 2,
    V_INFO = 3,
    V_DEBUG = 4,
    V_TRACE = 5
};

when ODIN_DEBUG {
    LOG_WARN_ENABLED :: #config(LOG_WARN_ENABLED, true)
    LOG_INFO_ENABLED :: #config(LOG_INFO_ENABLED, true)
    LOG_DEBUG_ENABLED :: #config(LOG_DEBUG_ENABLED, true)
    LOG_TRACE_ENABLED :: #config(LOG_TRACE_ENABLED, true)
} else {
    LOG_WARN_ENABLED :: #config(LOG_WARN_ENABLED, true)
    LOG_INFO_ENABLED :: #config(LOG_INFO_ENABLED, true)
    LOG_DEBUG_ENABLED :: #config(LOG_DEBUG_ENABLED, false)
    LOG_TRACE_ENABLED :: #config(LOG_TRACE_ENABLED, false)
}


when ODIN_DEBUG == false {
}

// logger_system_state :: struct {} 

// state_ptr :: ^logger_system_state;

logging_initialize :: proc (
    memory_requirement: ^u64, 
    state: rawptr, 
    config: rawptr) -> bool {
    //     memory_requirement^ = size_of(logger_system_state);

    //     if state == nil {
    //         return true;
    //     }

    //     state_ptr := state;


    // TODO(wowvain): CREATE LOG FILE
    return true;
}

shutdown_logging :: proc () {
    // TODO(wowvain): CREATE SHUTDOWN LOGIC
}

log_output :: proc (level: LOG_LEVEL, message: string, args: ..any) {
    level_strings := []string{
        "[FATAL]: ",
        "[ERROR]: ",
        "[WARN]: ",
        "[INFO]: ",
        "[DEBUG]: ",
        "[TRACE]: "
    };
    is_error := u8(level) < 2
    final_message := fmt.aprintf(message, ..args)
    fmt.printfln("%s\t%s", level_strings[level], final_message)
}

VFATAL :: #force_inline proc (message: string, args: ..any) {
    log_output(.V_FATAL, message, ..args)
}
VERROR :: #force_inline proc (message: string, args: ..any) {
    log_output(.V_ERROR, message, ..args)
}

when LOG_WARN_ENABLED {
    VWARN :: #force_inline proc (message: string, args: ..any) {
        log_output(.V_WARN, message, ..args)
    }
} else {
    VWARN :: #force_inline proc (..any) {}
}

when LOG_INFO_ENABLED {
    VINFO :: #force_inline proc (message: string, args: ..any) {
        log_output(.V_INFO, message, ..args)
    }
} else {
    VINFO :: #force_inline proc (..any) {}
}

when LOG_DEBUG_ENABLED {
    VDEBUG :: #force_inline proc (message: string, args: ..any) {
        log_output(.V_DEBUG, message, ..args)
    }
} else {
    VDEBUG :: #force_inline proc (..any) {} 
}

when LOG_TRACE_ENABLED {
    VTRACE :: #force_inline proc (message: string, args: ..any) {
        log_output(.V_TRACE, message, ..args)
    }
} else {
    VTRACE :: #force_inline proc (..any) {}
}