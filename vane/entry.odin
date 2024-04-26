package vane

import fmt "core:fmt"
import mem "core:mem"

import "core:os"
import "vendor:sdl2"

import v_log "logger"

engine_main :: proc(create_game: proc(out_game: ^game) -> bool) {

	game_inst: game

	// Initialize memory subsystem
	when ODIN_DEBUG {
		track_main: mem.Tracking_Allocator
		track_temp: mem.Tracking_Allocator

		mem.tracking_allocator_init(&track_main, context.allocator)
		mem.tracking_allocator_init(&track_temp, context.temp_allocator)

		context.allocator = mem.tracking_allocator(&track_main)
		context.temp_allocator = mem.tracking_allocator(&track_temp)

		defer {
			if len(track_main.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track_main.allocation_map))
				for _, entry in track_main.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track_main.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track_main.bad_free_array))
				for entry in track_main.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track_main)

			if len(track_temp.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track_temp.allocation_map))
				for _, entry in track_temp.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track_temp.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track_temp.bad_free_array))
				for entry in track_temp.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track_temp)
		}}

	if !create_game(&game_inst) {
		os.exit(-1)
	}

	if !application_create(&game_inst) {
		v_log.VINFO("Application failed to create")
		os.exit(1)
	}

	if !application_run() {
		v_log.VINFO("Application did not shut down gracefully")
		os.exit(2)
	}


	os.exit(0)
}
