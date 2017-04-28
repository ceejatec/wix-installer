@echo off
setlocal

set INSTALLDIR=%~1
::Does string have a trailing backslash? if so, remove it 
IF %INSTALLDIR:~-1%==\ SET INSTALLDIR=%INSTALLDIR:~0,-1%

call :fixfile "bin" "erl.ini"

:: End of script
exit /B %ERRORLEVEL%

:: Function to modify a file
:fixfile
set DIR=%~1
set FILENAME=%~2

"%INSTALLDIR%\bin\fnr.exe" --cl --silent --fileMask "%FILENAME%" --dir "%INSTALLDIR%\%DIR%" --useRegEx --find "C:/Jenkins/workspace/.*windows/install" --replace "%INSTALLDIR%"
"%INSTALLDIR%\bin\fnr.exe" --cl --silent --fileMask "%FILENAME%" --dir "%INSTALLDIR%\%DIR%" --find "\\" --replace "/" 
exit /B 0
