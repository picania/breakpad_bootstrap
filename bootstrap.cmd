@echo off

rem Get depot_tools
call git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

rem Get Breakpad
call git clone https://chromium.googlesource.com/breakpad/breakpad.git src

rem Checkout commit (or master)
cd src
call git checkout 48a13da
cd ..

rem Configure gclient for Breakpad fetch
call depot_tools\gclient.bat config --name src --unmanaged https://chromium.googlesource.com/breakpad/breakpad.git

rem Setup environment
set GYP_GENERATORS=msvs
set GYP_MSVS_VERSION=2013

rem Fetch Breakpad (and generate MSVC project)
call depot_tools\gclient.bat sync

rem Reconfigure MSVC project with custom parameters
src\src\tools\gyp\gyp.bat --no-circular-check ^
    src\src\client\windows\breakpad_client.gyp ^
    -Dwin_release_RuntimeLibrary=2 ^
    -Dwin_debug_RuntimeLibrary=3 ^
    -DWarnAsError=false

