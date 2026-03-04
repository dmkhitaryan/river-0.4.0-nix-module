#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-prefetch-git gnused zon2nix jq nixfmt wget
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_rev=$(git ls-remote https://github.com/kewuaa/kwm refs/heads/master | cut -f1)
hash=$(nix-prefetch-git --url https://github.com/kewuaa/kwm --rev "$latest_rev" | jq -r '.hash')

source "$SCRIPT_DIR/../update-lib.sh"
update_src "$SCRIPT_DIR/package.nix" "$latest_rev" "$hash"

curl -fsSL "https://raw.githubusercontent.com/kewuaa/kwm/${latest_rev}/build.zig.zon" -o "$SCRIPT_DIR/build.zig.zon"
zon2nix "$SCRIPT_DIR/build.zig.zon" > "$SCRIPT_DIR/build.zig.zon.nix"
sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$SCRIPT_DIR/build.zig.zon.nix"
nixfmt "$SCRIPT_DIR/build.zig.zon.nix"

rm -f "$SCRIPT_DIR/build.zig.zon"
