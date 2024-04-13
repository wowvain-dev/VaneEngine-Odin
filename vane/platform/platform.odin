package platform

import "vendor:sdl2"

internal_state :: struct {
    window: ^sdl2.Window,
    renderer: ^sdl2.Renderer,
}

platform_startup :: proc(plat_state: ^internal_state, application_name: cstring, x: i32, y: i32, width: i32, height: i32) {
    sdl2.Init(sdl2.INIT_VIDEO)
    
    window_flags := sdl2.WINDOW_SHOWN
    window := sdl2.CreateWindow(application_name, x, y, width, height, window_flags)
    if window == nil {
        // Handle error
        return
    }
    
    renderer_flags := sdl2.RENDERER_ACCELERATED | sdl2.RENDERER_PRESENTVSYNC
    renderer := sdl2.CreateRenderer(window, -1, renderer_flags)
    if renderer == nil {
        // Handle error
        return
    }
    
    plat_state.window = window
    plat_state.renderer = renderer
}

platform_shutdown :: proc(plat_state: ^internal_state) {
    sdl2.DestroyRenderer(plat_state.renderer)
    sdl2.DestroyWindow(plat_state.window)
    sdl2.Quit()
}