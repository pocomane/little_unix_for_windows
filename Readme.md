
Little unix for windows
=======================

A small (~5 Mb) ditribution of 32-bit windows binaries, providing a very
minimal unix-utility stack.

What
----

This is a binary distribution of the following open source software:
- msys runtime : a library to implement a unix/posix stack in windows
- mintty : A terminal emulator for windows
- busybox : a single binary containing a lot of unix-like utilities 
  (ls, sed, etc)

All the source was obtained from https://github.com/Alexpux/MSYS2-packages.
Some configuration file inside this distribution were sligthly modified.

Busybox was compiled with the "Standalone Shell" feature that let you to
call all its applet without creating links or script wrappers.

Mintty has a solarized dark theme. :)

Why
---

In general I think that a proper windows port of busybox is better (e.g.
https://github.com/pclouds/busybox-w32) for such minimalist systems.
However I had some difficulties using the console/terminal on pre-windows-10
system, so I started to use mintty. Then, I switched to the msys busybox for
two reason:
- The system is already dependent on the msys dll due to mintty
- The msys busybox is simpler to compile and keep up-to-date (If you have a
  msys installation somewhere...)

Use the interactive shell/terminal
----------------------------------

You can use the interactive terminal (mintty) / shell (busybox ash) double
clicking on teminal.bat in the root directory. Here you can use more or
less all the typical unix commands (ls, set, etc). They are embended
inside the busybox executable so you can not discover them by listing
into some directory or tryign to tab-completate the command line. Use
the busybox command without argument to get a list of avaiable "Applets".

If you wnt run a unix shell script, just write

ash path/to/my_script.sh

In the terminal. Alternatively you can run through the terminal.bat 
utility simply passing your script path as argument. You can do this,
for example, dragging your script on terminal.bat. However, in that way,
the terminal will be closed just after the script finish; if you want to
keep it open, end your script with something like

echo press enter to exit
read

Please note that the script must be a plain unix-style ASCII file i.e.
there must be no carriage return. If your editor can not save in this
format, use the dos2unix utility (type dos2unix --help in the interactive
console) before running the script.

TODO : Enable support for carriage return script !!! Is there a busybox
compilation option for this ???

Starup speed troubleshoot
-------------------------

In some setup starting the shell or the terminal can take several seconds
(https://github.com/Alexpux/MSYS2-packages/issues/138).  It is not a big
problem in case of interactive terminal/shell, but if you have some app
that start a lot of shell (or busybox applet, like ls, sed, and so on) it can
became unusable.

The solution should be run the a cygwin application, "cygserver" (
not distributed with this package), but I prefer a workaround that do not
need a background demon constantly running. Just click on the 
regen_user_data.bat script and change in etc/nsswitch.conf the lines:

passwd: files db
group: files db

with:

passwd: files # db
group: files # db

Note that you have to re-run regen_user_data.bat every time you change the
machine on which you run this software. It just generate the files
etc/group and etc/passwd, but they are machine specific. This is also the
sole purpose of the usr/bin/mkpasswd.exe and usr/bin/mkgroup.exe
utilities (as well as regen_user_date.bat and usr/bin/regen_user_data.sh).

