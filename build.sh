rm -rf ./build 
if [[ -n $PIKISSDIR" ]]; then
  meson --prefix="${HOME}/.local" -Dpikissdir="${PIKISSDIR}" -Dbuildtype=release build
else 
  meson --prefix="${HOME}/.local" -Dpikissdir="${HOME}/piKiss" -Dbuildtype=release build
fi
ninja -C build -j4
sudo ninja -C build install
sudo ninja -C build postinst
