rm -rf ./build 
meson --prefix="${HOME}/.local" -Dpikissdir="${HOME}/piKiss" -Dbuildtype=release build
ninja -C build -j4
sudo ninja -C build install
sudo ninja -C build postinst
