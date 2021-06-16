#!/bin/sh

#########################################################################
# Options

BB_COMPILE="yes"
BB_COMPILE_STANDALONE="yes"

#########################################################################

LUFWDIR="$(readlink -f "$(dirname $0)")"
BUILDSUBDIR="build"
BUILDDIR="$LUFWDIR/$BUILDSUBDIR"
OUTDIR="$BUILDDIR/lufw"
BB_PATCH_FILE="$LUFWDIR/busybox-1.23.2-1.src.patch"
#BB_URL="https://www.busybox.net/downloads/busybox-snapshot.tar.bz2"
#BB_URL="https://www.busybox.net/downloads/busybox-1.33.1.tar.bz2"
BB_URL="https://www.busybox.net/downloads/busybox-1.23.2.tar.bz2"
BB_TMP_NAM="bbx"

die () {
  echo "ERROR - $@"
  exit -1
}

echo "installing dependencies"
if [ "$BB_COMPILE" != "yes" ]; then
  pacman -S --needed busybox ||die
else
  pacman -S --needed gcc make diffutils patch ||die
fi

rm -fR "$BUILDDIR/"
mkdir -p "$BUILDDIR/"
mkdir -p "$OUTDIR/"
cd "$BUILDDIR" ||die

for F in $(ls "$LUFWDIR") ; do
  if [ "$F" != "$BUILDSUBDIR" ]; then
    cp -fR "$LUFWDIR"/"$F" "$OUTDIR/" ||die
  fi
done
rm "$OUTDIR"/lufw.sh "$OUTDIR"/Readme.md
rm "$OUTDIR"/"$(basename "$BB_PATCH_FILE")"

cp /usr/bin/msys-2.0.dll "$OUTDIR"/usr/bin ||die
cp /usr/bin/cygwin-console-helper.exe "$OUTDIR"/usr/bin ||die
cp /usr/bin/mkpasswd.exe "$OUTDIR"/usr/bin ||die
cp /usr/bin/mintty.exe "$OUTDIR"/usr/bin ||die
cp /usr/bin/mkgroup.exe "$OUTDIR"/usr/bin ||die

BB_BIN="no_busybox_fond"
if [ "$BB_COMPILE" != "yes" ]; then

  BB_BIN="/usr/bin/busybox.exe"

else

  echo "downloading busybox sources"

  curl -kL "$BB_URL" > "$BB_TMP_NAM".tar.bz2

  echo "preparing busybox sources"

  bunzip2 "$BB_TMP_NAM".tar.bz2 ||die
  tar -xf "$BB_TMP_NAM".tar ||die
  cd busybox* ||die

  # compatibility config/patch
  patch -i "$BB_PATCH_FILE" -p2
  # default config
  make cygwin_defconfig ||die
  # feature config/patch
  if [ "$BB_COMPILE_STANDALONE" = "yes" ]; then
    sed 's:# CONFIG_FEATURE_PREFER_APPLETS .*:CONFIG_FEATURE_PREFER_APPLETS=y:' -i .config ||die # needed by STANDALONE feature
    sed 's:# CONFIG_FEATURE_SH_STANDALONE .*:CONFIG_FEATURE_SH_STANDALONE=y:' -i .config ||die
  fi

  echo "compiling busybox"

  make busybox ||die
  BB_BIN="$PWD/busybox"
  cd - ||die
fi

cp "$BB_BIN" "$OUTDIR"/usr/bin/busybox.exe ||die
echo "done"

