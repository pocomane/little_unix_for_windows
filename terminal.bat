:
@echo off
set MSYS=winsymlinks:nativestrict
set PATH=/usr/bin;%PATH%
cd %~dp0
start usr\bin\mintty.exe usr/bin/busybox.exe ash %*
