@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
color 09
title RECON

call :banner

:menu
echo.
echo   [1] listen     - active connections
echo   [2] locate     - locate IP
echo   [3] trace      - traceroute
echo   [4] ping       - ping host
echo   [5] whois      - whois lookup
echo   [6] openport   - scan common ports
echo   [7] dns        - DNS lookup
echo   [8] speedtest  - internet speed
echo   [9] exit
echo.
set /p option=Choose option: 

if "%option%"=="1" goto listen
if "%option%"=="2" goto locate
if "%option%"=="3" goto trace
if "%option%"=="4" goto ping
if "%option%"=="5" goto whois
if "%option%"=="6" goto openport
if "%option%"=="7" goto dns
if "%option%"=="8" goto speedtest
if "%option%"=="9" goto end
goto menu

:listen
netstat -an | findstr "LISTENING"
pause >nul
goto menu

:locate
set /p ip=IP: 
if defined ip curl -s ipinfo.io/%ip%
pause >nul
goto menu

:trace
set /p ip=IP: 
if defined ip tracert %ip%
pause >nul
goto menu

:ping
set /p ip=IP: 
if defined ip ping -n 4 %ip%
pause >nul
goto menu

:whois
set /p dom=Domain (example.com): 
if defined dom curl -s "https://rdap.org/domain/%dom%"
pause >nul
goto menu

:openport
set /p ip=IP: 
if defined ip (
  echo Scanning common ports on %ip% ...
  for %%p in (21 22 23 25 53 80 110 143 443 445 3389) do (
    for /f "delims=" %%r in ('powershell -NoProfile -Command "(Test-NetConnection -ComputerName %ip% -Port %%p -WarningAction SilentlyContinue).TcpTestSucceeded"') do (
      if /I "%%r"=="True" (echo Port %%p: OPEN) else (echo Port %%p: closed)
    )
  )
)
pause >nul
goto menu

:dns
set /p domain=Domain: 
if defined domain nslookup %domain%
pause >nul
goto menu

:speedtest
echo Running speedtest (requires Ookla speedtest CLI)...
speedtest
pause >nul
goto menu

:banner
echo.
echo                                        ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗
echo                                        ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║
echo                                        ██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║
echo                                        ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║
echo                                        ██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║
echo                                        ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝
echo.                                       
goto :eof

:end
exit
