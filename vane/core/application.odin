package core

import "../platform"

// Application configuration
application_config :: struct {
    // Window starting position x axis, if applicable.
    start_pos_x: i16, 
    // Window starting position y axis, if applicable.
    start_pos_y: i16,

    // Window starting width, if applicable.
    start_width: i16,
    // Window starting height, if applicable.
    start_height: i16,
    
    // The application name used in windowing
    name: cstring
}

// Application state
application_state :: struct {
    // The platform layer
    platform: platform.platform_state,
    is_running: bool,
    is_suspended: bool,
    width: i16,
    height: i16,
    last_time: f64
}

initialized := false
app_state: application_state

application_create :: proc (config: application_config) -> bool {
    using platform

    if initialized {
        VERROR("application_create called more than once.")
        return false
    }

    initialize_logging()

    // TODO: Remove this
    VFATAL("This is a %s, %.2f", "test", 3.2413)
    VERROR("This is a %s, %.2f", "test", 3.2413)
    VWARN("This is a %s, %.2f", "test", 3.2413)
    VINFO("This is a %s, %.2f", "test", 3.2413)
    VDEBUG("This is a %s, %.2f", "test", 3.2413)
    VTRACE("This is a %s, %.2f", "test", 3.2413)

    app_state.is_running = true
    app_state.is_suspended = false
    
    if !platform_startup(
        &app_state.platform, 
        config.name, 
        config.start_pos_x, 
        config.start_pos_y, 
        config.start_width, 
        config.start_height) {
            return false;
    }

    initialized = true

    return true
}

application_run :: proc () -> bool {
    using platform

    for app_state.is_running {
        if !platform_pump_messages(&app_state.platform) {
            app_state.is_running = false
        }
    }

    app_state.is_running = false
    platform_shutdown(&app_state.platform)

    return false
}