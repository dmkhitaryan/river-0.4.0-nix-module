#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-prefetch-git gnused zon2nix jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_rev=$(git ls-remote https://git.sr.ht/~hokiegeek/orilla refs/heads/main | cut -f1)
hash=$(nix-prefetch-git --url https://git.sr.ht/~hokiegeek/orilla --rev "$latest_rev" | jq -r '.hash')

source "$SCRIPT_DIR/../update-lib.sh"
update_src "$SCRIPT_DIR/package.nix" "$latest_rev" "$hash"
