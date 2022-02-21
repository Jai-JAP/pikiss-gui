rm -rf ./build 
meson --prefix=~/.local -Dbuildtype=release build
ninja -C build -j4
sudo ninja -C build install
