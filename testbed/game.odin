
package testbed

import v "../vane"

game_state :: struct {
	delta_time: f32,
}

game_initialize :: proc(game: ^v.game) -> bool {
	return true
}

game_update :: proc(game: ^v.game, delta_time: f32) -> bool {
	return true
}

game_render :: proc(game: ^v.game, delta_time: f32) -> bool {
	return true
}

game_on_resize :: proc(game: ^v.game, width: u16, height: u16) -> bool {
	return true
}
