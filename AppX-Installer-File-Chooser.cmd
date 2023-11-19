@echo off
setlocal enabledelayedexpansion

:loop
set "tempfile=%temp%\file-%random%"
if exist "%tempfile%" goto :loop
call :getfile "c:\"
for /f "delims=" %%a in ('powershell "%tempfile%.ps1" ') do (
   set "filePath=%%~a"
::   set "filePath=%%~dpa"
::   set "filePath=%%~dp"
   set "fileName=%%~nxa"
   set "fileExtension=%%~xa"
)
del "%tempfile%.ps1"
cls
echo  path is: "%filePath%"
echo  file is: "%fileName%"
echo  file extension is: "%fileExtension%"


REM Uzantı kontrolü
set "validExtension=0"
if /i "%fileExtension%" equ ".appx" set "validExtension=1"
if /i "%fileExtension%" equ ".msixbundle" set "validExtension=1"

if not !validExtension! equ 1 (
	echo.
	echo.
    echo [ERROR] Only .appx and .msixbundle extensions... Aborted...
    pause
    exit /b
)

echo [INFO] Installing !fileName!...
powershell.exe -ExecutionPolicy Bypass "& {Add-AppxPackage -Path '!filePath!'}"
echo [INFO] Installed.
echo.

echo.
echo [SUCCESS] All packages installed.
pause >nul

goto :EOF

:getfile
(
echo $initialDirectory = "%%~dpa"
echo [System.Reflection.Assembly]::LoadWithPartialName^("System.windows.forms"^) ^| Out-Null
echo $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
echo $OpenFileDialog.initialDirectory = "%%~dpa"
echo $OpenFileDialog.filter = "All Files (*.*)|*.*|Appx Files (*.appx)|*.appx|MsixBundle Files (*.msixbundle)|*.msixbundle"
echo $OpenFileDialog.ShowDialog^(^) ^| Out-Null
echo $OpenFileDialog.filename
) > "%tempfile%.ps1"
goto :EOF
