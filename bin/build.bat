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

:: Kill existing processes that will affect builds
tasklist /fi "imagename eq QueueManager.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "QueueManager.exe"
  echo ^> Killing existing 'QueueManager.exe' process...
)

tasklist /fi "imagename eq PO_Verification.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "PO_Verification.exe"
  echo ^> Killing existing 'PO_Verification.exe' process...
)

tasklist /fi "imagename eq tmp.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "tmp.exe"
  echo ^> Killing existing 'tmp.exe' process...
)
if errorlevel 1 taskkill /f /im "tmp.exe"

tasklist /fi "imagename eq Settings.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "Settings.exe"
  echo ^> Killing existing 'Settings.exe' process...
)

@echo on
:: Build both AHK files to EXEs
%COMPILER% /base %BINFILE% /in "%CD%\app\main.ahk" /out "%CD%\dist\DBA AutoTools.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\Job Receipts.ahk" /out "%CD%\dist\app\modules\Job Receipts.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\Installer.ahk" /out "%CD%\installers\Installer-DBA-AutoTools-%CURRENT_VERSION%.exe" /icon "%CD%\assets\Installer.ico" 

:: Reset the prompt
@PROMPT %OLDPROMPT%