:
@echo off
call %~dp0env.bat

REM   If the busybox links are ok and the shell is correctly configured in
REM   /etc/passwd, you could avoid to pass the following whole line to mintty.
REM   However it is done in this way here in order to let the system to work also
REM   with broken default. Moreover this avoid possible faulty arguments when
REM   dragging some script over this batch file. 
start %MSYSROOT%\usr\bin\mintty.exe /usr/bin/busybox.exe ash -l %*

