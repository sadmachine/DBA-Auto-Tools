:: Save and clear the prompt (better clarity for echoing)
@echo off
set OLDPROMPT=%PROMPT%
set COMPILER="%AHK_COMPILER%"
set BINFILE="%AHK_COMPILER_BINFILE%"
PROMPT $G$S

if "%~1" == "" (
  echo You must supply a version number as argument 1.
)

if "%~2" == "" (
  echo You must supply a commit message as argument 2.
)

for /f %%i in ('%~dp0\current-branch.bat') do (
  set CURRENT_BRANCH=%%i
)

if "%CURRENT_BRANCH%" NEQ "main" (
  echo Current branch is '%CURRENT_BRANCH%', please merge all changes into the main branch before committing a version.
  goto END
)

call %~dp0\build.bat %~1

git add .
git commit -m "%~2"
git tag -a %~1 -m "%~2"
git push
git push origin %~1


:END
:: Reset the prompt
@PROMPT %OLDPROMPT%