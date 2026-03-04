#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-prefetch-git gnused zon2nix jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/window-managers/update-lib.sh"

usage() {
  echo "Usage: $(basename "$0") [--update] [--build]"
  echo ""
  echo "  --update   Fetch latest revisions and update .nix files"
  echo "  --build    Build river and all window managers via nix-build"
  echo ""
  echo "  With no flags, both steps are run."
}

do_update=false
do_build=false

for arg in "$@"; do
  case "$arg" in
    --update) do_update=true ;;
    --build)  do_build=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown flag: $arg"; usage; exit 1 ;;
  esac
done

# Default: run both if no flags given.
if ! $do_update && ! $do_build; then
  do_update=true
  do_build=true
fi

WM_DIR="$SCRIPT_DIR/window-managers"
update_failed=()
build_failed=()

# Update section: River + all window managers.
if $do_update; then
  echo "Updating river..."
  latest_rev=$(git ls-remote https://codeberg.org/river/river refs/heads/main | cut -f1)
  hash=$(nix-prefetch-git --url https://codeberg.org/river/river --rev "$latest_rev" | jq -r '.hash')

  update_src "$SCRIPT_DIR/river-dev.nix" "$latest_rev" "$hash"

  wget "https://codeberg.org/river/river/raw/commit/${latest_rev}/build.zig.zon" -O "$SCRIPT_DIR/build.zig.zon"
  zon2nix "$SCRIPT_DIR/build.zig.zon" > "$SCRIPT_DIR/build.zig.zon.nix"
  sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$SCRIPT_DIR/build.zig.zon.nix"
  nixfmt "$SCRIPT_DIR/build.zig.zon.nix"
  rm -f "$SCRIPT_DIR/build.zig.zon"

  for script in "$WM_DIR"/*/update.sh; do
    wm=$(basename "$(dirname "$script")")
    log="/tmp/river-wm-update-${wm}.log"
    echo "Updating $wm..."
    if bash "$script" >"$log" 2>&1; then
      rm -f "$log"
    else
      echo "  FAILED — log: $log"
      update_failed+=("$wm")
    fi
  done
fi

# Build section: River + all window managers.
if $do_build; then
  echo ""
  echo "Building river..."
  river_log="/tmp/river-build-river.log"
  if nix-build -E "with import <nixpkgs> {}; callPackage $SCRIPT_DIR/river-dev.nix {}" \
      --no-out-link >"$river_log" 2>&1; then
    rm -f "$river_log"
  else
    echo "  FAILED — log: $river_log"
    build_failed+=("river")
  fi

  for pkg in "$WM_DIR"/*/package.nix; do
    wm=$(basename "$(dirname "$pkg")")
    log="/tmp/river-build-${wm}.log"
    echo "Building $wm..."
    if nix-build -E "with import <nixpkgs> {}; callPackage $pkg {}" \
        --no-out-link >"$log" 2>&1; then
      rm -f "$log"
    else
      echo "  FAILED — log: $log"
      build_failed+=("$wm")
    fi
  done
fi

# Results section - return what failed to update and/or build.
exit_code=0

if [ ${#update_failed[@]} -gt 0 ]; then
  echo ""
  echo "Update failures:"
  for wm in "${update_failed[@]}"; do
    echo "  - $wm  (log: /tmp/river-wm-update-${wm}.log)"
  done
  exit_code=1
fi

if [ ${#build_failed[@]} -gt 0 ]; then
  echo ""
  echo "Build failures:"
  for name in "${build_failed[@]}"; do
    echo "  - $name  (log: /tmp/river-build-${name}.log)"
  done
  exit_code=1
fi

exit $exit_code
