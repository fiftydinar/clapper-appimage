# clapper-appimage

Test of Clapper AppImage, not intended for daily-driving yet.

When the known issues gets solved, repo will be transfered to pkgforge-dev repo & it will be the part of AnyLinux-AppImages collection.

## Known issue

- Cannot play any video, `clapper` cannot find the GST plugins, even with the environment variable set
- Even with the above issue fixed, playing URL videos only works in Arch-based distros, because of TLS certificates database errors, which is the same issue like with [Gnome Calculator's non-working currency conversion functionality](https://github.com/fiftydinar/gnome-calculator-appimage?tab=readme-ov-file#known-issue):  
https://github.com/VHSgunzo/sharun/issues/56
  
