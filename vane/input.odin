package vane

import "core:fmt"
import "core:mem"
import vlog "logger"

@(private = "file")
initialized := false
@(private = "file")
state: input_state

buttons :: enum {
	BUTTON_LEFT,
	BUTTON_RIGHT,
	BUTTON_MIDDLE,
	BUTTON_MAX_BUTTONS,
}

keys :: enum {
	KEY_BACKSPACE = 0x08,
	KEY_ENTER = 0x0D,
	KEY_TAB = 0x09,
	KEY_SHIFT = 0x10,
	KEY_CONTROL = 0x11,
	KEY_PAUSE = 0x13,
	KEY_CAPITAL = 0x14,
	KEY_ESCAPE = 0x1B,
	KEY_CONVERT = 0x1C,
	KEY_NONCONVERT = 0x1D,
	KEY_ACCEPT = 0x1E,
	KEY_MODECHANGE = 0x1F,
	KEY_SPACE = 0x20,
	KEY_PRIOR = 0x21,
	KEY_NEXT = 0x22,
	KEY_END = 0x23,
	KEY_HOME = 0x24,
	KEY_LEFT = 0x25,
	KEY_UP = 0x26,
	KEY_RIGHT = 0x26,
	KEY_DOWN = 0x28,
	KEY_SELECT = 0x29,
	KEY_PRINT = 0x2A,
	KEY_EXECUTE = 0x2B,
	KEY_SNAPSHOT = 0x2C,
	KEY_INSERT = 0x2D,
	KEY_DELETE = 0x2E,
	KEY_HELP = 0x2F,

	// Alphabetical Keys
	KEY_A = 0x41,
	KEY_B = 0x42,
	KEY_C = 0x43,
	KEY_D = 0x44,
	KEY_E = 0x45,
	KEY_F = 0x46,
	KEY_G = 0x47,
	KEY_H = 0x48,
	KEY_I = 0x49,
	KEY_J = 0x4A,
	KEY_K = 0x4B,
	KEY_L = 0x4C,
	KEY_M = 0x4D,
	KEY_N = 0x4E,
	KEY_O = 0x4F,
	KEY_P = 0x50,
	KEY_Q = 0x51,
	KEY_R = 0x52,
	KEY_S = 0x53,
	KEY_T = 0x54,
	KEY_U = 0x55,
	KEY_V = 0x56,
	KEY_W = 0x57,
	KEY_X = 0x58,
	KEY_Y = 0x59,
	KEY_Z = 0x5A,

	// Numeric keys
	KEY_0 = 0x30,
	KEY_1 = 0x31,
	KEY_2 = 0x32,
	KEY_3 = 0x33,
	KEY_4 = 0x34,
	KEY_5 = 0x35,
	KEY_6 = 0x36,
	KEY_7 = 0x37,
	KEY_8 = 0x38,
	KEY_9 = 0x39,

	// Special Keys
	KEY_LWIN = 0x5B,
	KEY_RWIN = 0x5C,
	KEY_APPS = 0x5D,
	KEY_SLEEP = 0x5F,

	// Function keys
	KEY_F1 = 0x70,
	KEY_F2 = 0x71,
	KEY_F3 = 0x72,
	KEY_F4 = 0x73,
	KEY_F5 = 0x74,
	KEY_F6 = 0x75,
	KEY_F7 = 0x76,
	KEY_F8 = 0x77,
	KEY_F9 = 0x78,
	KEY_F10 = 0x79,
	KEY_F11 = 0x7A,
	KEY_F12 = 0x7B,

	// Additional controls
	KEY_NUMLOCK = 0x90,
	KEY_SCROLLLOCK = 0x91,

	// Numpad keys
	KEY_NUMPAD0 = 0x60,
	KEY_NUMPAD1 = 0x61,
	KEY_NUMPAD2 = 0x62,
	KEY_NUMPAD3 = 0x63,
	KEY_NUMPAD4 = 0x64,
	KEY_NUMPAD5 = 0x65,
	KEY_NUMPAD6 = 0x66,
	KEY_NUMPAD7 = 0x67,
	KEY_NUMPAD8 = 0x68,
	KEY_NUMPAD9 = 0x69,
	KEY_MULTIPLY = 0x6A,
	KEY_ADD = 0x6B,
	KEY_SEPARATOR = 0x6C,
	KEY_SUBTRACT = 0x6D,
	KEY_DECIMAL = 0x6E,
	KEY_DIVIDE = 0x6F,
	KEY_NUMPADEQUAL = 0x92,

	// Modifiers
	KEY_LSHIFT = 0xA0,
	KEY_RSHIFT = 0xA1,
	KEY_LCONTROL = 0xA2,
	KEY_RCONTROL = 0xA3,
	KEY_LMENU = 0xA4,
	KEY_RMENU = 0xA5,

	// Others
	KEY_SEMICOLON = 0xBA,
	KEY_PLUS = 0xBB,
	KEY_COMMA = 0xBC,
	KEY_MINUS = 0xBD,
	KEY_PERIOD = 0xBE,
	KEY_SLASH = 0xBF,
	KEY_GRAVE = 0xC0,
	KEYS_MAX_KEYS,
}

keyboard_state :: struct {
	keys: [256]bool,
}

mouse_state :: struct {
	x:       i16,
	y:       i16,
	buttons: [buttons.BUTTON_MAX_BUTTONS]bool,
}

input_state :: struct {
	keyboard_current:  keyboard_state,
	keyboard_previous: keyboard_state,
	mouse_current:     mouse_state,
	mouse_previous:    mouse_state,
}

input_initialize :: proc() {
	mem.zero(&state, size_of(input_state))
	initialized = true
}
input_shutdown :: proc() {
	// TODO: Add shutdown procedures when needed
	initialized = false
}
input_update :: proc(delta_time: f64) {
	if !initialized {
		vlog.VFATAL("Input update called without initializing the subsystem")
		return
	}

	// Copy current states to previous states.
	mem.copy(&state.keyboard_previous, &state.keyboard_current, size_of(keyboard_state))
	mem.copy(&state.mouse_previous, &state.mouse_current, size_of(mouse_state))
}


// keyboard input
input_is_key_down :: proc(key: keys) -> bool {
	if !initialized {return false}
	fmt.printfln("Key pressed: %u", key)
	return state.keyboard_current.keys[key] == true
}
input_is_key_up :: proc(key: keys) -> bool {
	if !initialized {return true}
	return state.keyboard_current.keys[key] == false
}
input_was_key_down :: proc(key: keys) -> bool {
	if !initialized {return false}
	return state.keyboard_previous.keys[key] == true
}
input_was_key_up :: proc(key: keys) -> bool {
	if !initialized {return true}
	return state.keyboard_previous.keys[key] == false
}

input_process_key :: proc(key: keys, pressed: bool) {
	if state.keyboard_current.keys[key] != pressed {
		state.keyboard_current.keys[key] = pressed

		ctx: event_context
		ctx.data.u16[0] = u16(key)
		event_fire(
			u16(
				pressed \
				? system_event_code.EVENT_CODE_KEY_PRESSED \
				: system_event_code.EVENT_CODE_KEY_RELEASED,
			),
			nil,
			ctx,
		)
	}
}

input_process_button :: proc(button: buttons, pressed: bool) {
	if state.mouse_current.buttons[button] != pressed {
		state.mouse_current.buttons[button] = pressed

		ctx: event_context
		ctx.data.u16[0] = u16(button)

		event_fire(
			u16(
				pressed \
				? system_event_code.EVENT_CODE_BUTTON_PRESSED \
				: system_event_code.EVENT_CODE_BUTTON_RELEASED,
			),
			nil,
			ctx,
		)
	}
}

// mouse input 
input_is_button_down :: proc(button: buttons) -> bool {
	if !initialized {return false}
	return state.mouse_current.buttons[button] == true
}
input_is_button_up :: proc(button: buttons) -> bool {
	if !initialized {return true}
	return state.mouse_current.buttons[button] == false
}
input_was_button_down :: proc(button: buttons) -> bool {
	if !initialized {return false}
	return state.mouse_previous.buttons[button] == true
}
input_was_button_up :: proc(button: buttons) -> bool {
	if !initialized {return true}
	return state.mouse_previous.buttons[button] == false
}

input_get_mouse_position :: proc(x: ^i32, y: ^i32) {
	if !initialized {
		x^ = 0
		y^ = 0
		return
	}

	x^ = i32(state.mouse_current.x)
	y^ = i32(state.mouse_current.y)
}
input_get_previous_mouse_position :: proc(x: ^i32, y: ^i32) {
	if !initialized {
		x^ = 0
		y^ = 0
		return
	}

	x^ = i32(state.mouse_previous.x)
	y^ = i32(state.mouse_previous.y)
}

input_process_mouse_move :: proc(x: i16, y: i16) {
	if state.mouse_current.x != x || state.mouse_current.y != y {
		vlog.VDEBUG("Mouse pos: %d, %d", x, y)

		state.mouse_current.x = x
		state.mouse_current.y = y

		ctx: event_context
		ctx.data.u16[0] = u16(x)
		ctx.data.u16[1] = u16(y)
		event_fire(u16(system_event_code.EVENT_CODE_MOUSE_MOVED), nil, ctx)
	}
}
input_process_mouse_wheel :: proc(z_delta: i8) {
	ctx: event_context
	ctx.data.u8[0] = u8(z_delta)
	event_fire(u16(system_event_code.EVENT_CODE_MOUSE_WHEEL), nil, ctx)
}
