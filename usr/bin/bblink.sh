#!/usr/bin/busybox.exe ash

DD='/usr/bin'
BB='busybox.exe'
cd "$DD"

ACTION="create"
if [ "$1" == "-r" ] ; then
  ACTION="remove"
fi

if [ "$ACTION" == "create" ] ; then
  for A in $("$DD/$BB" --list) ; do
    if [ ! -x "$A" ] ; then
      "$DD/$BB" ln -s "$BB" "$A"
      "$DD/$BB" printf .
    fi
  done
fi

if [ "$ACTION" == "remove" ] ; then
  for A in $("$DD/$BB" ls) ; do
    if [ ! "$A" == "$BB" ] ; then

      TOREMOVE="false"
      if [ "$("$DD/$BB" readlink "$A")" == "$BB" ] ; then
        TOREMOVE="true"
      elif [ "$("$DD/$BB" diff "$BB" "$A")" == "" ] ; then
        TOREMOVE="true"
      fi

      if [ "$TOREMOVE" == "true" ] ; then
        "$DD/$BB" rm "$A"
        "$DD/$BB" printf .
      fi
    fi
  done
fi

"$DD/$BB" printf "\n"

# During the removal, the following files should be kept:
# bblink.sh                  mintty.exe                 msys-2.0.dll
# busybox.exe                mkgroup.exe                regen_user_data.sh
# cygwin-console-helper.exe  mkpasswd.exe

