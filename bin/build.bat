:: Save and clear the prompt (better clarity for echoing)
@echo off
set OLDPROMPT=%PROMPT%
set COMPILER="%AHK_COMPILER%"
set BINFILE="%AHK2_COMPILER_BINFILE%"
setlocal EnableDelayedExpansion
PROMPT $G$S


if "%1" NEQ "" (
  set CURRENT_VERSION=%1
) else (
  for /f %%i in ('%~dp0\current-version.bat') do (
    set CURRENT_VERSION=%%i.beta
  )
)

inifile "%CD%\dist\app\settings.ini" [version] current=%CURRENT_VERSION%

:: Kill existing processes that will affect builds
tasklist /fi "imagename eq DBA AutoTools.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "DBA AutoTools.exe"
  echo ^> Killing existing 'DBA AutoTools.exe' process...
)

tasklist /fi "imagename eq Job Receipts.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "Job Receipts.exe"
  echo ^> Killing existing 'Job Receipts.exe' process...
)


@echo on
:: Build both AHK files to EXEs
%COMPILER% /base %BINFILE% /in "%CD%\app\main.ahk" /out "%CD%\dist\DBA AutoTools.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\Job Receipts.ahk" /out "%CD%\dist\app\modules\Job Receipts.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\ClientInstaller.ahk" /out "%CD%\dist\client\ClientInstall.exe" /icon "%CD%\assets\Installer.ico" 
mkdir "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%"
mkdir "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%\assets"
copy "%CD%\assets\Prag Logo.ico" "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%\assets"
%COMPILER% /base %BINFILE% /in "%CD%\app\ServerInstaller.ahk" /out "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%\DBA-AutoTools-ServerInstall-%CURRENT_VERSION%.exe" /icon "%CD%\assets\Installer.ico" 
"C:\Program Files\7-Zip\7z.exe" a -tzip "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%.zip" "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%"
rmdir /S /Q "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%" 

:: Reset the prompt
@PROMPT %OLDPROMPT%