# clapper-appimage

Test of Clapper AppImage, not intended for daily-driving yet.

When the known issues gets solved, repo will be transfered to pkgforge-dev repo & it will be the part of AnyLinux-AppImages collection.

## Known issue

- HW-accelerated video decoding doesn't work (tested on AMD Vega 7 iGPU - possible culprit could be the Arch package itself, as it's not working there. Upstream flatpak is tested to work on Gnome 47 runtime, maybe some newer package version makes it not work here)
