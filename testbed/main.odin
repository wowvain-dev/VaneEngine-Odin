package testbed

import "core:fmt"
import "core:io"


import vane "../vane"
import vane_core "../vane/core"
import vane_platform "../vane/platform"
import sdl "vendor:sdl2"

main :: proc () {
    using vane_core
    using vane_platform
    
    config: application_config = {
        name = "Testbed",
        start_pos_x = 100,
        start_pos_y = 100,
        start_width = 800,
        start_height = 600
    }

    application_create(config)
    application_run();
}