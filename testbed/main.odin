package testbed

import vane "../vane"
import vane_core "../vane/core"
import vane_platform "../vane/platform"

main :: proc () {
    using vane_core

    VFATAL("This is a %s", "test")
    
}