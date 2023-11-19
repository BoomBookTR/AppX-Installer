@echo off
setlocal enabledelayedexpansion

rem Dosya yolu var mı kontrolü
if "%~1" == "" (
    echo Opening file chooser...
    goto :loop
) else (
    goto :dragfile
)

:dragfile
rem Dosya yolu belirtilmişse doğrudan işleme geç
set "filePath=%~1"
set "fileName=%~n1"
set "fileExtension=%~x1"
goto :yukle

:loop
    set "tempfile=%temp%\file-%random%"
    if exist "%tempfile%" goto :loop
    call :getfile "c:\"
for /f "delims=" %%a in ('powershell "%tempfile%.ps1" ') do (
    set "filePath=%%~a"
    set "fileName=%%~nxa"
    set "fileExtension=%%~xa"
)
cls
del "%tempfile%.ps1"



:yukle
echo path is: "%filePath%"
echo file is: "%fileName%"
echo file extension is: "%fileExtension%"
echo.
echo.
REM Uzantı kontrolü
set "validExtension=0"
if /i not "!fileExtension!" equ ".appx" if /i not "!fileExtension!" equ ".msixbundle" (
    echo.
    echo.
    echo [ERROR] Only .appx and .msixbundle extensions...
    pause
    exit /b
)

echo [INFO] Installing !fileName!!fileExtension!...
powershell.exe -ExecutionPolicy Bypass "& {Add-AppxPackage -Path '!filePath!'}"
echo [INFO] Installed.
echo.

echo.
echo [SUCCESS] All packages installed.
pause >nul

goto :EOF


::GETFILE GİRİŞ
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
::GETFILE BİTİŞ