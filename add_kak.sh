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

echo "installing dependencies"
pacman -S --needed gcc make unzip ||die

echo "downloading software"
cd "$BUILDDIR" ||die
curl -kL "https://github.com/mawww/kakoune/archive/refs/heads/master.zip" > tmp.zip ||die
unzip tmp.zip ||die
cd - ||die

echo "compiling software"
cd "$BUILDDIR"/kakoune* ||die
make ||die
strip src/kak ||die
cd - ||die

echo "copying files"
mkdir -p "$OUTDIR"/usr/bin/ ||die
cd "$BUILDDIR"/kakoune* ||die
cp src/kak "$OUTDIR"/usr/bin/ ||die
cd -
cp /usr/bin/msys-stdc++-6.dll "$OUTDIR"/usr/bin/ ||die
cp /usr/bin/msys-gcc_s-seh-1.dll "$OUTDIR"/usr/bin/ ||die
mkdir -p "$OUTDIR"/usr/share/kak ||die
touch "$OUTDIR"/usr/share/kak/kakrc ||die
cp "$OUTDIR""/usr/bin/busybox.exe" "$OUTDIR""/usr/bin/sh.exe"
# echo "#!/usr/bin/busybox.exe ash" > "$OUTDIR"/usr/bin/sh
# echo "/usr/bin/busybox.exe ash"  >> "$OUTDIR"/usr/bin/sh

