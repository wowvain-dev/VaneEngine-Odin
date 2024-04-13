package testbed

import "core:fmt"
import "core:io"


import vane "../vane"
import vane_core "../vane/core"
import vane_platform "../vane/platform"

main :: proc () {
    using vane_core
    using vane_platform

    VFATAL("This is a %s, %.2f", "test", 3.2413)
    VERROR("This is a %s, %.2f", "test", 3.2413)
    VWARN("This is a %s, %.2f", "test", 3.2413)
    VINFO("This is a %s, %.2f", "test", 3.2413)
    VDEBUG("This is a %s, %.2f", "test", 3.2413)
    VTRACE("This is a %s, %.2f", "test", 3.2413)

    assert_debug(1 != 1, "This is a test")

    platform_state: ^internal_state

    platform_startup(
        platform_state,
        cstring("Testbed"),
        500, 500,
        500, 500)
    
    for {}

    platform_shutdown(platform_state)
    
}