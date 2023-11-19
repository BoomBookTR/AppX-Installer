@echo off
setlocal enabledelayedexpansion

set "filePath=%~1"
set "fileName=%~n1"
set "fileExtension=%~x1"

REM Uzantı kontrolü
set "validExtension=0"
if /i not "!fileExtension!" equ ".appx" if /i not "!fileExtension!" equ ".msixbundle" (
	echo.
	echo.
    echo [ERROR] Only .appx and .msixbundle extensions... Aborted...
    pause
    exit /b
)

echo [INFO] Installing !fileName!!fileExtension!...
powershell.exe -ExecutionPolicy Bypass "& {Add-AppxPackage -Path '%filePath%'}"
echo [INFO] Installed.
echo.

echo.
echo [SUCCESS] All packages installed.
pause >nul
