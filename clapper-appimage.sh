#!/bin/sh

set -eux

ARCH="$(uname -m)"
PACKAGE=clapper
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"
VERSION="$(cat ~/version)"

# Variables used by quick-sharun
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME="$PACKAGE"-"$VERSION"-anylinux-"$ARCH".AppImage
export DESKTOP=/usr/share/applications/com.github.rafostar.Clapper.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/com.github.rafostar.Clapper.svg
export DEPLOY_OPENGL=1
export DEPLOY_GSTREAMER=1
export STARTUPWMCLASS=clapper # For Wayland, this is 'com.github.rafostar.Clapper', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this

sys_clapper_dir=$(echo /usr/lib/clapper-*)
if [ -d "$sys_clapper_dir" ]; then
	export PATH_MAPPING="
		$sys_clapper_dir:\${SHARUN_DIR}/lib/${sys_clapper_dir##*/}
	"
else
	>&2 echo "ERROR: Cannot find the clapper lib dir"
	exit 1
fi

# DEPLOY ALL LIBS
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/clapper -- https://test-videos.co.uk/vids/bigbuckbunny/mp4/h265/1080/Big_Buck_Bunny_1080_10s_1MB.mp4

## Further debloat locale
find ./AppDir/share/locale -type f ! -name '*glib*' ! -name '*clapper-app*' -delete

## Set gsettings to save to keyfile, instead to dconf
echo "GSETTINGS_BACKEND=keyfile" >> ./AppDir/.env

# MAKE APPIMAGE WITH URUNTIME
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage

# PREPARE APPIMAGE FOR RELEASE
mkdir -p ./dist
mv -v ./*.AppImage* ./dist
mv -v ~/version     ./dist
