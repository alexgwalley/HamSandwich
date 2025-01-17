@echo off
cd /d %~dp0 || goto :error
cd ..\.. || goto :error
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars32.bat" || goto :error
cmake --preset windows-i686-release -Wno-dev || goto :error
cmake --build build/cmake-windows-i686-release17.0 --target supreme jspedit || goto :error
cmake --install build/cmake-windows-i686-release17.0 --strip --prefix build/dist/steam-windows --component generic/executables || goto :error
cmake --install build/cmake-windows-i686-release17.0 --strip --prefix build/dist/steam-windows --component supreme/executables || goto :error
cmake --install build/cmake-windows-i686-release17.0 --strip --prefix build/dist/steam-windows --component jspedit/executables || goto :error
goto :EOF

:error
echo ==== ERROR! ====
echo Failed with error #%errorlevel%.
pause
exit /b %errorlevel%
