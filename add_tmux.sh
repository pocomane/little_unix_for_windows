#!/bin/sh

#########################################################################
# Options

# no options

#########################################################################

LUFWDIR="$(readlink -f "$(dirname $0)")"
BUILDSUBDIR="build"
BUILDDIR="$LUFWDIR/$BUILDSUBDIR"
OUTDIR="$BUILDDIR/lufw"

die () {
  echo "ERROR - $@"
  exit -1
}

echo "installing software"
pacman -S --needed tmux ||die

echo "copying files"
mkdir -p "$OUTDIR"/tmp ||die
mkdir -p "$OUTDIR"/usr/bin/ ||die
cp /usr/bin/msys-event_core-2-1-7.dll "$OUTDIR"/usr/bin/ ||die
cp /usr/bin/msys-ncursesw6.dll "$OUTDIR"/usr/bin/ ||die
cp /usr/bin/tmux.exe "$OUTDIR"/usr/bin/ ||die

