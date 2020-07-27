meson --prefix=/usr/local -Dbuildtype=release build
ninja -C build -j4
sudo ninja -C build install
