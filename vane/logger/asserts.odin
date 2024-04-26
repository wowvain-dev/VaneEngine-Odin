package logger

// As opposed to C, Odin has better asserts out of the box, so this file will be much 
// more bare bones than in the C++ version of the engine.

when ODIN_DEBUG {
	assert_debug :: #force_inline proc(condition: bool, message := "", loc := #caller_location) {
		assert(condition, message, loc)
	}
} else {
	assert_debug :: #force_inline proc(_: ..any) {}
}
