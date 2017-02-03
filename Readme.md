
Little unix for windows
=======================

A small (~5 Mb) system providing a very minimal, protable, unix-utility stack
for windows.

What
----

Here you will find some config files that you can use to pack a minimal
unix stack for windows. If you trust running binaries taken form unknown
sources (you shoud not), I have also a [32-bit
package](http://pocomane.dynu.net/asset/little_unix_for_windows.7z)
containing all the software:
- msys runtime : a library to implement a unix/posix stack in windows
- mintty : A terminal emulator for windows (with a solarized dark theme :) )
- busybox : a single binary containing a lot of unix-like utilities 
  (ls, sed, etc)

All the source was obtained from https://github.com/Alexpux/MSYS2-packages.
Some configuration file from the original distributions were sligthly modified.
busybox was compiled with the "Standalone Shell" feature that let you to call
all its applet without creating links or script wrappers.

Why
---

In general I think that a proper windows port of busybox (e.g.
https://github.com/pclouds/busybox-w32) is better for such minimalist systems.
However I had some difficulties using the console/terminal on pre-windows-10
system, so I started to use mintty. Then, I switched to the msys busybox for
two reason:
- The system is already dependent on the msys dll due to mintty
- The msys busybox is simpler to compile and keep up-to-date (If you have a
  msys installation somewhere...)

Preparation
-----------

You have to copy some executable file in the usr/bin subfolder.  If you
have a MSYS2 installation somewhere, you can find the files in the
following MSYS2 subfolder, otherwise you have to find them on the web. The
only one that could miss in a MSYS2 distribution is busybox that is not
installed by default. You can download and install it with
`pacman -Su busybox`. The full MSYS2 file list is:

- usr/bin/mkpasswd.exe
- usr/bin/cygwin-console-helper.exe
- usr/bin/msys-2.0.dll
- usr/bin/mintty.exe
- usr/bin/mkgroup.exe
- usr/bin/busybox.exe

Then, you have to generate the busybox links.  Right-click on terminal.bat and
chose "Run as administrator" (that rights are needed to create symbolic
links in winsows) and run the following command:

```
> bblink.sh
```

When it ends, close the admin terminal, you are done.

Distribution
------------

If you want to make a binary package, you can remove the .git folder the
.gitignore file and this Readme.md. I suggest you to keep the FIX.txt file or
integreate it in a your own Readme file.

Note that in some cases windows does not copyng (or extract) correctly the
symbolic link. It could just duplicate the original file resulting in a larger
directory size (i.e. ~ 100 Mb vs ~ 5 Mb of a regular one). Or it can generate
other type of links, that will prevent some utilities to work work properly
(e.g.  "ls" could not list anything). In any moment you can correct all this
issues with

```
> bblink.sh -r
> bblink.sh
```

The first just delete all the links or wrong generated file copies.

Use the interactive shell/terminal
----------------------------------

You can use the interactive terminal (mintty) / shell (busybox ash) double
clicking on teminal.bat in the root directory. Here you can use more or
less all the typical unix commands (ls, set, etc). There is no manual
but minimal help can be found with (e.g. for the "ls" command)

```
> busybox help ls
> ls --help
```

If you want to run a sub-shell script, just write:

```
> ash -l
```

Or if you want to open another terminal windows:

```
> mintty ash -l &
```

Or to run a script:

```
> ./my_script.sh
```

This will run the scipt in the terminal. Alternatively you can run through the
terminal.bat utility simply passing your script path as argument. You can do
this, for example, dragging your script on terminal.bat. However, in that
way, the terminal will be closed just after the script finish; if you want to
keep it open, end your script with something like

```
echo press enter to exit
read
```

Please note that the script must be a plain unix-style ASCII file i.e.
there must be no carriage return. If your editor can not save in this
format, use the dos2unix utility (type dos2unix --help in the interactive
console) before running the script.

Adding other MSYS utilities
---------------------------

Theoretically you can copy any MSYS utility in the /usr/bin folder and it
will be ready to be used. However some utility may depend on specific
configuration files or shared library. You have to copy all of them: the
configuration under the same folder hierarchy and the shared library in the
/usr/bin folder.

If you want copy some utility that have the same name of one supplied by
busybox (e.g. grep), you can simply overwrite the link in the /usr/bin
directory. In case you have to re-run the bblink script as described in the
installation section, there should be no problems since it can detect if a
file is a link or a binary.

Starup speed troubleshoot
-------------------------

In some setup starting the shell or the terminal can take several seconds
(https://github.com/Alexpux/MSYS2-packages/issues/138).  It is not a big
problem in case of interactive terminal/shell, but if you have some app
that start a lot of shell (or busybox applet, like ls, sed, and so on) it can
became unusable.

The solution should be to run a cygwin application, "cygserver" (
not present int the binary package), but I prefer a workaround that do not
need a background demon constantly running. Just click on the 
regen_user_data.bat script and change in etc/nsswitch.conf the lines:

```
passwd: files db
group: files db
```

with:

```
passwd: files # db
group: files # db
```

Note that you have to re-run regen_user_data.bat every time you change the
machine on which you run this software. It just generate the files
etc/group and etc/passwd, but they are machine specific. This is also the
sole purpose of the usr/bin/mkpasswd.exe and usr/bin/mkgroup.exe
utilities (as well as regen_user_date.bat and usr/bin/regen_user_data.sh).

