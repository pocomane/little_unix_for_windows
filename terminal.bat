:
@echo off
call %~dp0env.bat

start %MSYSROOT%\usr\bin\mintty.exe /usr/bin/busybox.exe ash -l %*

