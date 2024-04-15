package vane

import "core:os"
import vcore "./core"
import vplat "./platform"

import "vendor:sdl2"

engine_main :: proc(
  create_game: proc(out_game: ^vcore.game) -> bool
) {
  using vcore 
  using vplat

	game_inst: game

  if !create_game(&game_inst) { 
    os.exit(-1)
  }

  if !application_create(&game_inst) {
    VINFO("Application failed to create")
    os.exit(1)
  }

  if !application_run() {
    VINFO("Application did not shut down gracefully")
    os.exit(2)
  }


  os.exit(0)
}
