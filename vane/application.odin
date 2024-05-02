package vane

import v_log "logger"

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
	platform:     platform_state,
	game_inst:    ^game,
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
	update:     proc(game_instance: ^game, delta_time: f32) -> bool,

	// Function pointer go game's render function
	render:     proc(game_instance: ^game, delta_time: f32) -> bool,

	// Function pointer to handle resizes, if applicable
	on_resize:  proc(game_instance: ^game, width: u16, height: u16) -> bool,

	// Game-specific game state. Created and managed by the game
	state:      rawptr,
}

@(private = "file")
app_initialized := false
app_state: application_state

app_on_event :: proc(
	code: u16,
	sender: rawptr,
	listener_inst: rawptr,
	ctx: event_context,
) -> bool {
	#partial switch system_event_code(code) {
	case .EVENT_CODE_APPLICATION_QUIT:
		{
			v_log.VINFO("EVENT_CODE_APPLICATION_QUIT received, shutting down. \n")
			app_state.is_running = false
			return true
		}
	}

	return false
}
app_on_key :: proc(code: u16, sender: rawptr, listener_inst: rawptr, ctx: event_context) -> bool {
	if code == u16(system_event_code.EVENT_CODE_KEY_PRESSED) {
		key_code := ctx.data.u16[0]
		if keys(key_code) == keys.KEY_ESCAPE {
			data: event_context
			event_fire(u16(system_event_code.EVENT_CODE_APPLICATION_QUIT), nil, data)

			return true
		} else if key_code == u16(keys.KEY_A) {
			v_log.VDEBUG("Explicit - A key pressed!")
		} else {
			v_log.VDEBUG("'%c' key pressed in window.", key_code)
		}
	} else if code == u16(system_event_code.EVENT_CODE_KEY_RELEASED) {
		key_code := ctx.data.u16[0]
		if key_code == u16(keys.KEY_B) {
			v_log.VDEBUG("Explicit - B key released!")
		} else {
			v_log.VDEBUG("'%c' key released in window.", key_code)
		}
	}
	return false
}

application_create :: proc(game_inst: ^game) -> bool {
	using v_log

	if app_initialized {
		VERROR("application_create called more than once.")
		return false
	}

	app_state.game_inst = game_inst

	// TODO: fix name convention to be consistent
	initialize_logging()
	VDEBUG("Logging subsystem initialized")
	input_initialize()
	VDEBUG("Input subsystem initialized")

	app_state.is_running = true
	app_state.is_suspended = false

	if !event_initialize() {
		VERROR("Event system failed initialization. Application cannot continue")
		return false
	}
	VDEBUG("Event subsystem initialized")

	event_register(u16(system_event_code.EVENT_CODE_APPLICATION_QUIT), nil, app_on_event)
	VDEBUG("Event registered: EVENT_CODE_APPLICATION_QUIT")
	event_register(u16(system_event_code.EVENT_CODE_KEY_PRESSED), nil, app_on_key)
	VDEBUG("Event registered: EVENT_CODE_KEY_PRESSED")
	event_register(u16(system_event_code.EVENT_CODE_KEY_RELEASED), nil, app_on_key)
	VDEBUG("Event registered: EVENT_CODE_KEY_RELEASED")

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

	app_initialized = true

	return true
}

application_run :: proc() -> bool {
	using v_log

	for app_state.is_running {
		if !platform_pump_messages(&app_state.platform) {
			app_state.is_running = false
		}

		if !app_state.is_suspended {
			if !app_state.game_inst->update(0) {
				VFATAL("Game failed to update, shutting down")
				app_state.is_running = false
				break
			}

			if !app_state.game_inst->render(0) {
				VFATAL("Game render failed, shutting down")
				app_state.is_running = false
				break
			}

			// NOTE: Input update/state copying should always be handled 
			// after any input should be recorded; I.E. before this line.
			// As a safety, input is the last thing to be updated before the
			// frame ends.
			input_update(0)
		}
	}

	app_state.is_running = false

	event_unregister(u16(system_event_code.EVENT_CODE_APPLICATION_QUIT), nil, app_on_event)
	event_unregister(u16(system_event_code.EVENT_CODE_KEY_PRESSED), nil, app_on_key)
	event_unregister(u16(system_event_code.EVENT_CODE_KEY_RELEASED), nil, app_on_key)

	event_shutdown()
	input_shutdown()

	platform_shutdown(&app_state.platform)

	return true
}
