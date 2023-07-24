@echo off

NET SESSION >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
    echo Run Frontier with admin. This script wont work otherwise
)

shift /0
cd %systemroot%\system32
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
goto :ABC
)

:ABC
cls
chcp 65001 >nul 2>&1
cd /d "%~dp0"
goto :unwantedfile

:unwantedfile
cls
set filesToDelete=C:\Windows\System32\GameBarPresenceWriter.exe C:\Windows\System32\smartscreen.exe C:\Windows\System32\Narrator.exe C:\Windows\System32\mcupdate_GenuineIntel.dll C:\Windows\HelpPane.exe C:\Windows\System32\mcupdate_AuthenticAMD.dll

for %%f in (%filesToDelete%) do (
    if exist "%%f" (
        echo Deleting "%%f"...
        takeown /f "%%f" >nul 2>&1
        icacls "%%f" /grant:r "%USERNAME%":F >nul 2>&1
        taskkill /im "%%~nxf" /f >nul 2>&1
        del /f /q "%%f" >nul 2>&1
        echo "%%f" deleted.
    )
)

cls
goto success

:success
cls
set msgboxTitle=Executed successfully
set msgboxBody=The unwanted files cleanup has been successful.
set tmpmsgbox=%temp%\~tmpmsgbox.vbs
if exist "%tmpmsgbox%" DEL /F /Q "%tmpmsgbox%"
echo msgbox "%msgboxBody%",0,"%msgboxTitle%">"%tmpmsgbox%"
WSCRIPT "%tmpmsgbox%"
echo [90mLoading Menu...
timeout 2 > nul
exit /B

:ColorText    
echo off    
<nul set /p ".=%DEL%" > "%~2"    
findstr /v /a:%1 /R "^$" "%~2" nul    
del "%~2" > nul 2>&1    
goto :eof
