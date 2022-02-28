# pikiss-gui
[PiKISS](https://github.com/jmcerrejon/piKiss) for Raspberry Pi: A bunch of scripts with menu to make your life easier. 
 
PiKISS GUI: GTK frontend for PiKISS.

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

 To build & install pikiss-gui, use `build.sh` (works in most cases) if doesn't work try installing manually.

    build.sh
    
<details>
<summary><b>To install PiKISS GUI manually</b> if you prefer to see what happens under the hood</summary>
 
Run `meson build` to configure the build environment:
 * [Optional] set --pikissdir as absolute path to your piKiss installation directory
     - Relative paths like `~/home/pi/piKiss` & `../piKiss` may work for compilation but will cause runtime errors.
 ```
 meson --prefix=~/.local --pikissdir=/home/pi/piKiss -Dbuildtype=release build
 ```

Run `ninja -C build` to build PiKISS GUI
 ```
 ninja -C build
 ```
 
Run `sudo ninja -C build install` to install PiKISS GUI
 ```
 sudo ninja -C build install
 ```
 
Run `sudo ninja -C build postinst' to sync apps with PiKISS
 ```
 sudo ninja -C build post
 ```
</details>

To uninstall, use `uninstall.sh` (Generated after installation in source dir)

    uninstall.sh
