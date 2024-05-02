package vane

import "core:fmt"
import "vendor:sdl2"

platform_state :: struct {
	window:   ^sdl2.Window,
	renderer: ^sdl2.Renderer,
}

platform_startup :: proc(
	plat_state: ^platform_state,
	application_name: cstring,
	x: i16,
	y: i16,
	width: u16,
	height: u16,
) -> bool {
	sdl2.Init(sdl2.INIT_VIDEO)

	window_flags := sdl2.WINDOW_SHOWN
	window := sdl2.CreateWindow(
		application_name,
		i32(x),
		i32(y),
		i32(width),
		i32(height),
		window_flags,
	)
	if window == nil {
		return false
	}

	renderer_flags := sdl2.RENDERER_ACCELERATED | sdl2.RENDERER_PRESENTVSYNC
	renderer := sdl2.CreateRenderer(window, -1, renderer_flags)
	if renderer == nil {
		// Handle error
		return false
	}

	plat_state.window = window
	plat_state.renderer = renderer

	return true
}

platform_shutdown :: proc(plat_state: ^platform_state) {
	sdl2.DestroyRenderer(plat_state.renderer)
	sdl2.DestroyWindow(plat_state.window)
	sdl2.Quit()
}

platform_pump_messages :: proc(plat_state: ^platform_state) -> bool {
	using sdl2
	event: sdl2.Event

	quit_flagged := false

	for PollEvent(&event) != false {
		#partial switch event.type {
		case .KEYDOWN:
		case .KEYUP:
			{
				key_sym := event.key.keysym.scancode
				pressed := (event.key.state == sdl2.PRESSED)

				// TODO: HIGH PRIORITY: Write a translation function to convert 
				// SDL2 keycodes into Vane ones

				input_process_key(keys(u16(key_sym)), pressed)
			}
		case .MOUSEBUTTONDOWN:
		case .MOUSEBUTTONUP:
			{
				mouse_button: buttons = buttons.BUTTON_MAX_BUTTONS
				pressed := (event.button.state == sdl2.PRESSED)

				switch event.button.button {
				case sdl2.BUTTON_LMASK:
					mouse_button = buttons.BUTTON_LEFT
				case sdl2.BUTTON_RMASK:
					mouse_button = buttons.BUTTON_RIGHT
				case sdl2.BUTTON_MMASK:
					mouse_button = buttons.BUTTON_MIDDLE
				}

				if mouse_button != buttons.BUTTON_MAX_BUTTONS {
					input_process_button(mouse_button, true)
				}
			}
		case .MOUSEMOTION:
			input_process_mouse_move(i16(event.motion.x), i16(event.motion.y))
		case .QUIT:
			{
				quit_flagged = true
			}
		}
	}
	return !quit_flagged
}
