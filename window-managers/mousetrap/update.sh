#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-prefetch-git gnused zon2nix jq nixfmt wget
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_rev=$(git ls-remote https://codeberg.org/g4b/mousetrap refs/heads/master | cut -f1)
hash=$(nix-prefetch-git --url https://codeberg.org/g4b/mousetrap --rev "$latest_rev" | jq -r '.hash')

sed -i "s|rev = \"[^\"]*\"|rev = \"$latest_rev\"|" "$SCRIPT_DIR/package.nix"
sed -i "s|hash = \"[^\"]*\"|hash = \"$hash\"|" "$SCRIPT_DIR/package.nix"
