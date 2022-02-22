rm -rf ./build 
meson --prefix=${HOME}/.local -Dbuildtype=release build
ninja -C build -j4
sudo ninja -C build install
