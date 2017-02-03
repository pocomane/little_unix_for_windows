#!/usr/bin/busybox.exe ash

DD='/usr/bin'
BB='busybox.exe'

# ---------------------------------------

CHECK=""
do_classify(){
  TYPE="file"
  if [ ! -e "$CHECK" ] ; then
    TYPE="miss"
  elif [ "$CHECK" == "busybox.exe" ] ; then
    TYPE="busybox"
  elif [ "$("$DD/$BB" readlink "$CHECK")" == "$BB" ] ; then
    TYPE="busyboxlink"
  elif [ ! -s "$CHECK" ] ; then
    TYPE="empty"
  elif [ "$("$DD/$BB" diff "$BB" "$CHECK")" == "" ] ; then
    TYPE="busyboxcopy"
  fi
  CHECK="$TYPE"
  TYPE=""
}

make_user_info(){

  "$DD/$BB" printf "."
  /usr/bin/mkgroup.exe -l > /etc/group
  /usr/bin/mkpasswd.exe -l > /etc/passwd

  # mintty will use the shell in the passwd when launched without arguments.
  # Setting the shell to a busybox compatible one.
  "$DD/$BB" printf "."
  "$DD/$BB" cat /etc/passwd | "$DD/$BB" sed 's:/usr/bin/bash:/usr/bin/sh:g' > /etc/passwd.tmp
  "$DD/$BB" mv /etc/passwd.tmp /etc/passwd
}

remove_user_info(){
  "$DD/$BB" printf "."
  "$DD/$BB" rm -f /etc/passwd
  "$DD/$BB" printf "."
  "$DD/$BB" rm -f /etc/group
}

make_bb_link() {

  for A in $("$DD/$BB" ls) ; do
    "$DD/$BB" printf "."

    CHECK="$A"
    do_classify

    if [ "$CHECK" == "busyboxcopy" -o "$CHECK" == "empty" ] ; then
      "$DD/$BB" rm "$A"
    fi
  done

  for A in $("$DD/$BB" --list) ; do
    "$DD/$BB" printf "."

    CHECK="$A"
    do_classify

    if [ "$CHECK" == "busyboxcopy" -o "$CHECK" == "empty" -o "$CHECK" == "miss" ] ; then
      "$DD/$BB" ln -s "$BB" "$A"
    fi
  done
}

remove_bb_link(){
  for A in $("$DD/$BB" ls) ; do
    "$DD/$BB" printf "."

    CHECK="$A"
    do_classify

    if [ "$CHECK" == "busyboxlink" -o "$CHECK" == "busyboxcopy" ] ; then
      "$DD/$BB" rm "$A"
    fi
  done
}

# ---------------------------------------
# MAIN

cd "$DD"

if [ "$1" == "link" -o "$1" == "all" ] ; then
  echo "Fixing"
  make_bb_link

elif [ "$1" == "userinfo" -o "$1" == "all" ] ; then
  make_user_info

elif [ "$1" == "clean" ] ; then
  echo "Clearing"
  remove_bb_link
  remove_user_info

elif [ "$1" == "" ] ; then
  echo ""
  echo "Arguments other than the first are ignored. Accepted argument:"
  echo "- clean - removes all the generated files and links"
  echo "- all - is equivalent to call all the other except the 'clean' one"
  echo "- link - generates link to the busybox executable"
  echo "- userinfo - generates passwd and group files with system information"
else
  echo "Error: run without argument for help"
fi
"$DD/$BB" printf "\n"

# ---------------------------------------

# During the removal, the following files should be kept:
# sysfix.sh                  mintty.exe                 msys-2.0.dll
# busybox.exe                mkgroup.exe                regen_user_data.sh
# cygwin-console-helper.exe  mkpasswd.exe

