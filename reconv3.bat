@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title RECON

:: Define ANSI escape sequence
set "ESC="

call :banner

:menu
echo.
:: Menu options with full text color and shades
echo   %ESC%[38;2;0;100;255m[1] listen     - active connections%ESC%[0m
echo   %ESC%[38;2;0;150;255m[2] locate     - locate IP%ESC%[0m
echo   %ESC%[38;2;0;200;255m[3] trace      - traceroute%ESC%[0m
echo   %ESC%[38;2;0;255;255m[4] ping       - ping host%ESC%[0m
echo   %ESC%[38;2;0;255;150m[5] whois      - whois lookup%ESC%[0m
echo   %ESC%[38;2;0;255;150m[6] openport   - scan common ports%ESC%[0m
echo   %ESC%[38;2;0;200;0m[7] dns        - DNS lookup%ESC%[0m
echo   %ESC%[38;2;255;150;0m[8] speedtest  - internet speed%ESC%[0m
echo   %ESC%[38;2;255;0;0m[9] exit%ESC%[0m
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
echo %ESC%[38;2;0;100;255mActive connections:%ESC%[0m
for /f "delims=" %%i in ('netstat -an ^| findstr "LISTENING"') do (
    echo %ESC%[38;2;0;120;255m%%i%ESC%[0m
)
pause >nul
cls
call :banner
goto menu

:locate
set /p ip=IP: 
if defined ip (
    echo %ESC%[38;2;0;150;255mLocating IP %ip%...%ESC%[0m
    for /f "delims=" %%i in ('curl -s ipinfo.io/%ip%') do (
        echo %ESC%[38;2;0;180;255m%%i%ESC%[0m
    )
)
pause >nul
cls
call :banner
goto menu

:trace
set /p ip=IP: 
if defined ip (
    echo %ESC%[38;2;0;200;255mTracing route to %ip%...%ESC%[0m
    for /f "delims=" %%i in ('tracert %ip%') do (
        echo %ESC%[38;2;0;220;255m%%i%ESC%[0m
    )
)
pause >nul
cls
call :banner
goto menu

:ping
set /p ip=IP: 
if defined ip (
    echo %ESC%[38;2;0;255;150mPinging %ip%...%ESC%[0m
    for /f "delims=" %%i in ('ping -n 4 %ip%') do (
        echo %ESC%[38;2;0;255;200m%%i%ESC%[0m
    )
)
pause >nul
cls
call :banner
goto menu

:whois
set /p dom=Domain (example.com): 
if defined dom (
    echo %ESC%[38;2;0;255;200mWhois lookup for %dom%...%ESC%[0m
    for /f "delims=" %%i in ('curl "https://who-dat.as93.net/api/v1/whois?identifier=%dom%"') do (
        echo %ESC%[38;2;0;255;255m%%i%ESC%[0m
    )
)
pause >nul
cls
call :banner
goto menu

:openport
set /p ip=IP: 
if defined ip (
    echo %ESC%[38;2;0;200;0mScanning common ports on %ip%...%ESC%[0m
    for %%p in (21 22 23 25 53 80 110 143 443 445 3389) do (
        for /f "delims=" %%r in ('powershell -NoProfile -Command "(Test-NetConnection -ComputerName %ip% -Port %%p -WarningAction SilentlyContinue).TcpTestSucceeded"') do (
            if /I "%%r"=="True" (
                echo %ESC%[38;2;0;255;0mPort %%p: OPEN%ESC%[0m
            ) else (
                echo %ESC%[38;2;0;150;0mPort %%p: closed%ESC%[0m
            )
        )
    )
)
pause >nul
cls
call :banner
goto menu

:dns
set /p domain=Domain: 
if defined domain (
    echo %ESC%[38;2;0;255;255mDNS lookup for %domain%...%ESC%[0m
    for /f "delims=" %%i in ('nslookup %domain%') do (
        echo %ESC%[38;2;0;220;255m%%i%ESC%[0m
    )
)
pause >nul
cls
call :banner
goto menu

:speedtest
echo %ESC%[38;2;255;150;0mRunning speedtest...%ESC%[0m
cd C:\Users\%USERNAME%\Downloads\ookla-speedtest-1.2.0-win64
speedtest.exe
pause >nul
cls
call :banner
goto menu

:banner
echo.
echo                                        [38;2;0;0;80m██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗[0m
echo                                        [38;2;0;0;100m██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║[0m
echo                                        [38;2;0;0;150m██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║[0m
echo                                        [38;2;0;0;200m██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║[0m
echo                                        [38;2;0;0;255m██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║[0m
echo                                        [38;2;102;102;255m╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝[0m
echo.                                       
goto :eof

:end
exit



