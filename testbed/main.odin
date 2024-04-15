package testbed

import "core:fmt"
import "core:io"

import v "../vane"
import vcore "../vane/core"
import vplat "../vane/platform"

import sdl "vendor:sdl2"

create_game :: proc (out_game: ^vcore.game) -> bool {
    out_game.app_config.start_pos_x = 100;
    out_game.app_config.start_pos_y = 100;
    out_game.app_config.start_width = 1280;
    out_game.app_config.start_height = 720;
    out_game.app_config.name = "Vane Engine Testbed";

    out_game.initialize = game_initialize
    out_game.update = game_update
    out_game.render = game_render
    out_game.on_resize = game_on_resize

    return true
}

main :: proc () {
    v.engine_main(create_game)
}