#!/bin/sh

set -eux

ARCH="$(uname -m)"
PACKAGE=clapper
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

VERSION=$(pacman -Q "$PACKAGE" | awk 'NR==1 {print $2; exit}')
[ -n "$VERSION" ] && echo "$VERSION" > ~/version

# Variables used by quick-sharun
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME="$PACKAGE"-"$VERSION"-anylinux-"$ARCH".AppImage
export DESKTOP=/usr/share/applications/com.github.rafostar.Clapper.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/com.github.rafostar.Clapper.svg
export PATH_MAPPING_HARDCODED=1 # GTK applications are usually hardcoded to look into /usr/share, especially noticeable in non-working locale, hence why this is used
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_LOCALE=1

# Prepare AppDir
mkdir -p ./AppDir/shared/lib

# DEPLOY ALL LIBS
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/clapper -- https://test-videos.co.uk/vids/bigbuckbunny/mp4/h265/1080/Big_Buck_Bunny_1080_10s_1MB.mp4

## Patch StartupWMClass to work on X11
## Doesn't work when ran in Wayland, as it's 'com.github.rafostar.Clapper' instead.
## It needs to be manually changed by the user in this case.
sed -i '/^\[Desktop Entry\]/a\
StartupWMClass=clapper
' ./AppDir/*.desktop

## Further debloat locale
find ./AppDir/share/locale -type f ! -name '*glib*' ! -name '*clapper-app*' -delete

# MAKE APPIMAGE WITH URUNTIME
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage
