# pikiss-gui
[PiKISS](https://github.com/jmcerrejon/piKiss) for Raspberry Pi: A bunch of scripts with menu to make your life easier. 
 
PiKISS GUI: GTK frontend for PiKISS.

Thanks to [krishenrikesn](https://github.com/krishenriksen) for his initial work on [pikiss-gui](https://github.com/krishenriksen/pikiss-gui)

### Do not open issues related to PiKISS GUI on piKiss repo. Instead see [here](#for-support)

## Building, Testing, and Installation

***You'll need piKiss preinstalled for app sync to work.***

You'll need the following dependencies:
* meson >= 0.57
* gobject-introspection
* libgee-0.8-dev
* libgirepository1.0-dev
* libgtk-3-dev
* libgnome-menu-3-dev
* valac

 To build & install pikiss-gui, use `build.sh`.
 * build.sh assumes that piKiss is installed at ${HOME}/piKiss, if piKiss is installed at a different location than ${HOME}/piKiss then run build.sh with PIKISSDIR=your_piKiss_dir
```
    PIKISSDIR=your_piKiss_dir build.sh
```    
<details>
<summary><b>To install PiKISS GUI manually</b> if you prefer to see what happens under the hood</summary>
 
Run `meson build` to configure the build environment:
 ```
 meson --prefix=~/.local -Dpikissdir=${HOME}/piKiss -Dbuildtype=release build
 ```
 * If you did not install piKiss in your home directory; then set -Dpikissdir as absolute path to your piKiss installation directory.
     - Relative paths like `~/piKiss` & `../piKiss` may work for compilation but ***will cause runtime errors***.
 ```
 meson --prefix=~/.local -Dpikissdir=your_piKiss_dir -Dbuildtype=release build
 ```
Run `ninja -C build` to build PiKISS GUI
 ```
 ninja -C build
 ```
 
Run `ninja -C build install` to install PiKISS GUI
* Run with sudo if prefix is /usr or /usr/local
 ```
 ninja -C build install
 ```
 
Run `ninja -C build postinst` to sync apps with PiKISS & create other data files
* Run with sudo if prefix is /usr or /usr/local
 ```
 ninja -C build postinst
 ```
</details>

To uninstall, use `uninstall.sh` (Generated after installation in source dir)
```
    uninstall.sh
```

# For Support
- Open an issue [here](https://github.com/Jai-JAP/pikiss-gui/issues)
- Join the Discord server https://discord.gg/Jfu3Mbd3Ru
