@echo off
chcp 65001 > nul
color 09
call :banner

:menu
echo.
echo 1) listen - listen for IPs
echo 2) locate - locate the IP
echo 3) trace - trace route
set /p option=Choose an option:

if "%option%"=="1" goto listen
if "%option%"=="2" goto locate
if "%option%"=="3" goto trace

echo Invalid option, try again.
goto menu

:listen
echo You selected listen.
netstat -an
pause
goto menu

:locate
curl -s https://ipwhois.app/json/%ip% > ip_location.json

for /f "delims=" %%i in (ip_location.json) do (
    set "line=%%i"
    echo !line! | findstr /i "country city region isp org timezone"
)
pause
goto menu

:trace
echo You selected trace.
set /p ip=Enter the IP to trace:
tracert %ip%
pause
goto menu

:banner
echo.
echo                                        ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗
echo                                        ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║
echo                                        ██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║
echo                                        ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║
echo                                        ██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║
echo                                        ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝
                                           
                                   
