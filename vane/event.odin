package vane

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

initialize_event :: proc() -> bool {return false}
shutdown_event :: proc() {}

registered_event :: struct {
	listener: rawptr,
	callback: fn_on_event,
}

event_code_entry :: struct {
	events: [^]registered_event,
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
	return false
}

event_unregister :: proc(code: u16, listener: rawptr, on_event: fn_on_event) -> bool {
	return false
}

event_fire :: proc(code: u16, sender: rawptr, ctx: event_context) -> bool {
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

