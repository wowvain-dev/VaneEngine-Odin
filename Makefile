ODIN := odin
ODINFLAGS := -collection:shared=external

ifeq ($(OS),Windows_NT)
	SHARED_EXT := .dll
	EXEC_EXT := .exe
else
	SHARED_EXT := .so
	EXEC_EXT :=
endif

.SILENT:
.PHONY: all vane testbed editor

all: vane testbed editor


vane:
	echo "===== Building Vane ====="
	if not exist "bin\" mkdir bin
	$(ODIN) build vane/ -out:bin/vane$(SHARED_EXT) -build-mode:shared $(ODINFLAGS)
	copy /Y external\\*.dll bin\\
	echo "===== Built Succesfully ====="

testbed:
	echo "===== Building Testbed ====="
	if not exist "bin\" mkdir bin
	$(ODIN) build testbed/ -out:bin/testbed$(EXEC_EXT) $(ODINFLAGS)
	echo "===== Built Succesfully ====="

editor:
	echo "===== Building Testbed ====="
	if not exist "bin\" mkdir bin
	$(ODIN) build editor/ -out:bin/editor$(EXEC_EXT) $(ODINFLAGS)
	echo "===== Built Succesfully ====="