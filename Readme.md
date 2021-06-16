
Little unix for windows
=======================

This is a script to construct a small (~5 Mb) system providing a very minimal,
protable, unix-utility stack for windows.  Here "Portable" is used in the
windows sense, i.e. it does not need administrator right to execute/install, it
do not depend on extern file, directory names, or regitry keys.

A working installation of [MSYS2](https://www.msys2.org/) is needed. In its
simpler form, the script just copy some file from the MSYS2 installation, and
it substitutes some configuration files; however an option (enabled by default)
lets you to compile a version of [busybox](https://www.busybox.net/) with the
STANDALONE feature enabled (see the Issues section in this Readme for more
information).

Generating the system
---------------------

To generate a folder containing all the needed minimal software, you have to:

- Install MSYS2 somewhere (it does NOT require administrator privilages)
- Clone this repo somewhere
- Run the MSYS2 shell and entering the cloned folder
- Run the `./lufw.sh` script

The sub-folder `lufw` in the folder `build` will be created (you can move it
anywhere). It contains the whole system, i.e.:

- msys runtime : a library to implement a unix/posix stack in windows
- mintty : A terminal emulator for windows (with a solarized dark theme :) )
- busybox : a single binary containing a lot of unix-like utilities 
  (ls, sed, etc)
- some small configuration files (e.g. Solarized Dark theme)

If you trust running binaries taken form unknown sources (you shoud not), I
have also a [32-bit
package](http://pocomane.dynu.net/asset/little_unix_for_windows.7z).

Usage
-----

You can use the interactive terminal (mintty) / shell (busybox ash) double
clicking on teminal.bat in the root directory. Here you can use more or
less all the typical unix commands (ls, set, etc). There is no manual
but minimal help can be found with, e.g. the list of supported command can be
obtained with:

```
> busybox --help
```

or the documentation for the `ls` command can be obatined with one of:

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

How it Works
------------

The script mainly copy files from the MSYS2 installation. It also install some
MSYS2 package if missing. The full file list is:

- usr/bin/mkpasswd.exe
- usr/bin/cygwin-console-helper.exe
- usr/bin/msys-2.0.dll
- usr/bin/mintty.exe
- usr/bin/mkgroup.exe

The script download and compile busybox also. You can turn-off this
compilation, in such case the script will just copy the MSYS version of
busybox:

- usr/bin/busybox.exe

By default, the compiled version will enable the standalone feature of busybox:
it is the main reason to compile it, as explained in the Issues section.

Adding other MSYS utilities
---------------------------

Theoretically you can copy any MSYS utility in the /usr/bin folder and it
will be ready to be used. However some utility may depend on specific
configuration files or shared library. You have to copy all of them: the
configuration under the same folder hierarchy and the shared library in the
/usr/bin folder.

If you want copy some utility that have the same name of one supplied by
busybox (e.g. grep), you can simply overwrite the link in the /usr/bin
directory. In case you have to re-run the dofix script as described in the
installation section, there should be no problems since it can detect if a
file is a link or a binary.

Issues
======

I suggest you to integrate the FIX.txt file in your distribution. It explains
how to fix a couple of issue in both packing or moving the directory. In general,
you can run

```
> dofix.sh all
```

to fix all the issues, when they arise.

Distribution of non-standalone version
--------------------------------------

Non-standalone version of busybox relyes on os links to work properlu.

In some cases windows does not copyng (or extract) correctly the symbolic link.
It could just duplicate the original file resulting in a larger directory size
(i.e. ~ 100 Mb vs ~ 5 Mb of a regular one). Or it can generate other type of
links, that will prevent some utilities to work work properly (e.g.  "ls" could
not list anything).

With Right-click on terminal.bat and chose "Run as administrator"
(that rights are needed to create symbolic links in winsows) and run the
following command:

```
> dofix.sh link
```

Startup slowdown
----------------

Changing the machine, you could experience slowdown in the startup of
the shell. It is a real problem only in certain cases, as explained in the
"Speed troubleshot" section.

You can fix this with:

```
> dofix.sh userinfo
```

This can be annoying. There is a way to avoid at least the busybox link problem
described in the "Standalone busybox" section.

Starup speed troubleshoot
-------------------------

In some setup starting the shell or the terminal can take several seconds
(https://github.com/Alexpux/MSYS2-packages/issues/138).  It is not a big
problem in case of interactive terminal/shell, but if you have some app
that start a lot of shell (or busybox applet, like ls, sed, and so on) it can
became unusable.

The problem is related to the way MSYS will detect users and groups. If it is
configurated to get it from the system database, with some configuration, it
must wait some second every time an idendification is requested.

The solution should be to run a cygwin application, "cygserver" ( not
present int the binary package), but I prefer a workaround that do not need a
background demon constantly running.

In the /etc/nsswitch.conf file we ask to check some files before ask to
the system database.

```
passwd: files db
group: files db
```

So we just need to generate the correct files i.e. /etc/passwd and /etc/group.
To this purpose there is a script you can run:

```
> dofix.sh userinfo
```

However these information are machine-dependent so when you move the folder the
information in the passwd/group file will not match, and so it will fallback to
the system database. In that case the startup slow-down will be shown again,
and you need to re-run the `dofix.sh userinfo` script to fix it.

Someone reported that completly disable the database lookup improve startup
speed. I could not reproduce this behavior, however if you want to try, just
comment out the "db" in the nsswitch.conf:

```
passwd: files # db
group: files # db
```

But remember that in this case, when you change the machine, the terminal will
not start at all. You will have to temprorary re-enable the "db", then
re-run the `dofix.sh userinfo`, then re-disable the "db".

