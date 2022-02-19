# pikiss-gui
PiKISS for Raspberry Pi: A bunch of scripts with menu to make your life easier.
PiKISS GUI: GTK frontend for PiKISS.

## Building, Testing, and Installation

You'll need the following dependencies:
* meson >= 0.48.2
* gobject-introspection
* libgee-0.8-dev
* libgirepository1.0-dev
* libgtk-3-dev
* valac

Run `meson build` to configure the build environment:

    meson --prefix=/usr/local -Dbuildtype=release build
    
This command creates a `build` directory. For all following commands, change to
the build directory before running them.

To build pikiss-gui, use `build.sh`:

    build.sh

To install, use `ninja install`

    ninja install

To uninstall, use `uninstall.sh` (Generated after installation in build dir)

    uninstall.sh
