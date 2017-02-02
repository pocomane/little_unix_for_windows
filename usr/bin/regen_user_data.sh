#!/usr/bin/busybox ash

/usr/bin/mkgroup.exe -l > /etc/group
/usr/bin/mkpasswd.exe -l > /etc/passwd

# mintty will use the shell in the passwd when launched without arguments.
# Setting the shell to a busybox compatible one.
cat /etc/passwd | sed 's:/usr/bin/bash:/usr/bin/sh:g' > /etc/passwd.tmp
mv /etc/passwd.tmp /etc/passwd

