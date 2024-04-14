package platform

import "core:fmt"
import "vendor:sdl2"

platform_state :: struct {
    window: ^sdl2.Window,
    renderer: ^sdl2.Renderer,
}

platform_startup :: proc(
    plat_state: ^platform_state, 
    application_name: cstring, 
    x: i16, 
    y: i16, 
    width: i16, 
    height: i16
) -> bool {
    sdl2.Init(sdl2.INIT_VIDEO)
    
    window_flags := sdl2.WINDOW_SHOWN
    window := sdl2.CreateWindow(application_name, i32(x), i32(y), i32(width), i32(height), window_flags)
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

    fmt.print("Platform initialized\n")

    return true
}

platform_shutdown :: proc(plat_state: ^platform_state) {
    sdl2.DestroyRenderer(plat_state.renderer)
    sdl2.DestroyWindow(plat_state.window)
    sdl2.Quit()
}

platform_pump_messages :: proc(plat_state: ^platform_state) -> bool {
    sdl2.PumpEvents()
    return true
}