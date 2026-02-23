#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-prefetch-git gnused zon2nix jq nixfmt wget
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_rev=$(git ls-remote https://codeberg.org/Sivecano/rhine refs/heads/main | cut -f1)
hash=$(nix-prefetch-git --url https://codeberg.org/Sivecano/rhine --rev "$latest_rev" | jq -r '.hash')

sed -i "s|rev = \"[^\"]*\"|rev = \"$latest_rev\"|" "$SCRIPT_DIR/package.nix"
sed -i "s|hash = \"[^\"]*\"|hash = \"$hash\"|" "$SCRIPT_DIR/package.nix"

wget "https://codeberg.org/Sivecano/rhine/raw/commit/${latest_rev}/build.zig.zon" -O "$SCRIPT_DIR/build.zig.zon"
zon2nix "$SCRIPT_DIR/build.zig.zon" > "$SCRIPT_DIR/build.zig.zon.nix"

sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$SCRIPT_DIR/build.zig.zon.nix"
nixfmt "$SCRIPT_DIR/build.zig.zon.nix"

rm -f "$SCRIPT_DIR/build.zig.zon"
