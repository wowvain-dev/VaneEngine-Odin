package core

import "../platform"

// Application configuration
application_config :: struct {
	// Window starting position x axis, if applicable.
	start_pos_x:  i16,
        // Window starting position y axis, if applicable.
	start_pos_y:  i16,

	// Window starting width, if applicable.
	start_width:  u16,
	// Window starting height, if applicable.
	start_height: u16,

	// The application name used in windowing
	name:         cstring,
}

// Application state
application_state :: struct {
	// The platform layer
	platform:     platform.platform_state,
    game_inst :   ^game,
	is_running:   bool,
	is_suspended: bool,
	width:        u16,
	height:       u16,
	last_time:    f64,
}

/* 
    Represents the basic game state in a game.
    Called for creation by the application.
*/
game :: struct {
    // The application configuration
    app_config: application_config,

    // Function pointer to game's initialize function
    initialize: proc(game_instance: ^game) -> bool,

    // Function pointer to game's update function
    update: proc(game_instance: ^game, delta_time: f32) -> bool,

    // Function pointer go game's render function
    render: proc(game_instance: ^game, delta_time: f32) -> bool,

    // Function pointer to handle resizes, if applicable
    on_resize: proc(game_instance: ^game, width: u16, height: u16) -> bool,

    // Game-specific game state. Created and managed by the game
    state: rawptr
}

initialized := false
app_state: application_state

application_create :: proc(game_inst: ^game) -> bool {
	using platform

	if initialized {
		VERROR("application_create called more than once.")
		return false
	}

    app_state.game_inst = game_inst

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
           app_state.game_inst.app_config.name,
		   app_state.game_inst.app_config.start_pos_x,
		   app_state.game_inst.app_config.start_pos_y,
		   app_state.game_inst.app_config.start_width,
		   app_state.game_inst.app_config.start_height,
	   ) {
		return false
	}

    if !app_state.game_inst->initialize() {
        VFATAL("Game failed to initialize")
        return false
    }

    app_state.game_inst->on_resize(app_state.width, app_state.height)

	initialized = true

	return true
}

application_run :: proc() -> bool {
	using platform

	for app_state.is_running {
		if !platform_pump_messages(&app_state.platform) {
			app_state.is_running = false
		}

        if !app_state.is_running {
            if !app_state.game_inst->update(0) {
                VFATAL("Game failed to update, shutting down")
                app_state.is_running = false
                break   
            }
        }
	}

	app_state.is_running = false
	platform_shutdown(&app_state.platform)

	return false
}
