:
@echo off
set MSYS=winsymlinks:nativestrict
set MSYSROOT=%~dp0
set ENV=/etc/env
start %MSYSROOT%\usr\bin\mintty.exe /usr/bin/busybox.exe ash %*

