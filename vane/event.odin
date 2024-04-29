package vane

import mem "core:mem"

MAX_MESSAGE_CODES :: 16384

@(private = "file")
initialized := false

state: event_system_state

event_data :: struct #raw_union {
	i64: [2]i64,
	u64: [2]u64,
	f64: [2]f64,
	i32: [4]i32,
	u32: [4]u32,
	f32: [4]f32,
	i16: [8]i16,
	u16: [8]u16,
	i8:  [16]i8,
	u8:  [16]u8,
	c:   [16]byte,
}


event_context :: struct {
	data: event_data,
}

fn_on_event :: proc(code: u16, sender: rawptr, listener_inst: rawptr, data: event_context) -> bool

event_initialize :: proc() -> bool {
	if initialized == true {
		return false
	}

	initialized = false
	mem.zero(&state, size_of(state))
	initialized = true

	return true
}

event_shutdown :: proc() {
	for i in 1 ..< MAX_MESSAGE_CODES {
		if state.registered[i].events != nil {
			mem.delete_dynamic_array(state.registered[i].events)
			state.registered[i].events = nil
		}
	}
}


registered_event :: struct {
	listener: rawptr,
	callback: fn_on_event,
}

event_code_entry :: struct {
	events: [dynamic]registered_event,
}

event_system_state :: struct {
	registered: [MAX_MESSAGE_CODES]event_code_entry,
}

/*
  Register to listen for when events are sent with the provided code. Events with 
  duplicate listener/callback combos will not be registered again and will cause 
  this to return false.

  - code: The event code to listen for
  - listener: A pointer to a listener instance. Can be 0/nil
  - on_event: The callback procedure to be invoked when the event code is fired

  -- return: true if the event is successfully registered; false otherwise
*/
event_register :: proc(code: u16, listener: rawptr, on_event: fn_on_event) -> bool {
	if initialized == false {
		return false
	}

	if state.registered[code].events == nil {
		state.registered[code].events = make([dynamic]registered_event)
	}

	registered_count := len(state.registered[code].events)

	for i in 0 ..< registered_count {
		if state.registered[code].events[i].listener == listener {
			// TODO: warn
			return false
		}
	}

	// If no duplicate, proceed
	event: registered_event
	event.listener = listener
	event.callback = on_event

	append(&state.registered[code].events, event)

	return true
}

event_unregister :: proc(code: u16, listener: rawptr, on_event: fn_on_event) -> bool {
	if initialized == false {
		return false
	}

	if state.registered[code].events == nil {
		return false
	}

	registered_count := len(state.registered[code].events)
	for i in 0 ..< registered_count {
		e := state.registered[code].events[i]
		if e.listener == listener && e.callback == on_event {
			popped_event := state.registered[code].events[i]
			unordered_remove(&state.registered[code].events, i)
			return true
		}
	}

	// not found
	return false
}

event_fire :: proc(code: u16, sender: rawptr, ctx: event_context) -> bool {
	// TODO: implement
	return false
}

system_event_code :: enum {
	// Shuts the application down on the next frame
	EVENT_CODE_APPLICATION_QUIT = 0x01,

	/*
		key_code: u16 = data.u16[0]
	*/
	EVENT_CODE_KEY_PRESSED      = 0x02,
	/*
		key_code: u16 = data.u16[0]
	*/
	EVENT_CODE_KEY_RELEASED     = 0x03,
	/*
		button: u16 = data.u16[0]
	*/
	EVENT_CODE_BUTTON_PRESSED   = 0x04,
	/*
		button: u16 = data.u16[0]
	*/
	EVENT_CODE_BUTTON_RELEASED  = 0x05,
	/*
		x: u16 = data.u16[0]
		y: u16 = data.u16[1]
	*/
	EVENT_CODE_MOUSE_MOVED      = 0x06,
	/*
		z_delta: u8 = data.u8[0]
	*/
	EVENT_CODE_MOUSE_WHEEL      = 0x07,
	/*
		width: u16 = data.u16[0]
		height: u16 = data.u16[1]	
	*/
	EVENT_CODE_RESIZED          = 0x08,
	MAX_EVENT_CODE              = 0xFF,
}
