#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-prefetch-git jq

fetch() {
  local url=$1 rev=$2
  nix-prefetch-git --url "$url" --rev "$rev" 2>/dev/null | jq -r '.hash'
}

janet=$(fetch https://codeberg.org/ifreund/zig-janet 977e2777b9f0f6fd3531bec3c96c7073b690cbe3)
janet_wayland=$(fetch https://codeberg.org/ifreund/janet-wayland c118af389f43ac853c5189db4fd5cc430c7a3370)
wayland=$(fetch https://github.com/ifreund/wayland-build.zig 8c7f2c42ab0e4c16853d03914ce1f3259cda40db)
libxkbcommon=$(fetch https://github.com/allyourcodebase/libxkbcommon 809157d5118909298f3e086fa8d8103198e938fd)
janet_xkbcommon=$(fetch https://codeberg.org/ifreund/janet-xkbcommon bdd15cd20329078e47abb30bddddfb7b28f52f66)
spork=$(fetch https://github.com/janet-lang/spork 4224d5678ec8bb8777a9075030cf38da52f2d70a)
lemongrass=$(fetch https://github.com/pyrmont/lemongrass 906974b82ba06ed421e0c8cd9a56c6ddc4ca6820)
river=$(fetch https://codeberg.org/river/river 0ad1a8fa0bdabc9c73013d0102f3136e346355c5)
wayland_protocols=$(fetch https://gitlab.freedesktop.org/wayland/wayland-protocols 88223018d1b578d0d8869866da66d9608e05f928)

cat > "$SCRIPT_DIR/build.zig.zon.nix" << EOF
{ linkFarm, fetchgit }:
linkFarm "zig-packages" [
  { name = "janet-1.40.1-3XUN8cVGAAA7Os-UamOhi0sYVRqN-slGltgD5Jwwwfdk";
    path = fetchgit { url = "https://codeberg.org/ifreund/zig-janet"; rev = "977e2777b9f0f6fd3531bec3c96c7073b690cbe3"; hash = "$janet"; }; }
  { name = "N-V-__8AAPOoAACNhl0Pd9muOFuvch4kljaImdQiU6FPr9tY";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-wayland"; rev = "c118af389f43ac853c5189db4fd5cc430c7a3370"; hash = "$janet_wayland"; }; }
  { name = "wayland-1.24.0-3-dxEBa1pmAABlHkqXCGmZ4r9c_N8fhAXculLHBbO2pRRT";
    path = fetchgit { url = "https://github.com/ifreund/wayland-build.zig"; rev = "8c7f2c42ab0e4c16853d03914ce1f3259cda40db"; hash = "$wayland"; }; }
  { name = "libxkbcommon-1.11.0-1-93LaF6pwAgDFoaLfOkR8ioG4RVcDHbBhsDmC_rYwyOEG";
    path = fetchgit { url = "https://github.com/allyourcodebase/libxkbcommon"; rev = "809157d5118909298f3e086fa8d8103198e938fd"; hash = "$libxkbcommon"; }; }
  { name = "N-V-__8AAGELAABqy7_LKHe7k7pcmtqO8MJth7xoJZSYvriG";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-xkbcommon"; rev = "bdd15cd20329078e47abb30bddddfb7b28f52f66"; hash = "$janet_xkbcommon"; }; }
  { name = "N-V-__8AAAl3EACmKe5RiZh89D3n0pLUopY0K-kLHBIpREzpZeAO";
    path = fetchgit { url = "https://github.com/janet-lang/spork"; rev = "4224d5678ec8bb8777a9075030cf38da52f2d70a"; hash = "$spork"; }; }
  { name = "N-V-__8AAPMqAQCbXJ9KGZ7pEepOFcJFiLb-PW0LlAOhlgtd";
    path = fetchgit { url = "https://github.com/pyrmont/lemongrass"; rev = "906974b82ba06ed421e0c8cd9a56c6ddc4ca6820"; hash = "$lemongrass"; }; }
  { name = "river-0.4.0-dev-_G6NjnrjCQC0Zi7_CzoeOEkyp733JglzODl4vT5KuCLR";
    path = fetchgit { url = "https://codeberg.org/river/river"; rev = "0ad1a8fa0bdabc9c73013d0102f3136e346355c5"; hash = "$river"; }; }
  { name = "N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland-protocols"; rev = "88223018d1b578d0d8869866da66d9608e05f928"; hash = "$wayland_protocols"; }; }
]
EOF

echo "Done"
