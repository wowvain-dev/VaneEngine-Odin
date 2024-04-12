@echo off

echo Creating build folders
if not exist "build\" mkdir build
if not exist "build\\vane" mkdir build\\vane
if not exist "build\\editor" mkdir build\\editor
if not exist "build\\testbed" mkdir build\\testbed

echo Compiling vane ...
odin build vane/ -build-mode:shared -out:build/vane/vane.dll

echo Compiling testbed ...
odin build testbed/ -build-mode:exe -out:build/testbed/testbed.exe

echo Compiling editor ...
odin build editor/ -build-mode:exe -out:build/editor/vane_editor.exe