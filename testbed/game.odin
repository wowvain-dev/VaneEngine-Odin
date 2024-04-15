
package testbed

import v "../vane"
import vcore "../vane/core"
import vplat "../vane/platform"


game_initialize :: proc (game: ^vcore.game) -> bool {
    return true
}

game_update :: proc (game: ^vcore.game, delta_time: f32) -> bool {
    return true
}

game_render :: proc (game: ^vcore.game, delta_time: f32) -> bool {
    return true
}

game_on_resize :: proc (game: ^vcore.game, width: u16, height: u16) -> bool {
    return true
}