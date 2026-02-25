# [WIP] NixOS module for River 0.4.0 onwards
Since River has been renamed to `river-classic` in Nixpkgs, and the new version is currently not in release state, I wanted to build it locally to try out the changes. Given how it works, there is also a bunch of window managers that are implemented separately from River itself. 
Of course, the only way to choose a favourite is to try them all! That's why I figured I might as well build all of those, and maybe make a module down the line. If I don't run out of steam sooner, that is.

## Contents
This repo has/will contain the following:
- [x] River 0.4.0-dev
- [x] Builds for window managers as listed [upstream](https://codeberg.org/river/wiki/src/branch/main/pages/wm-list.md): 
  - [x]  beansprout - a DWM-style tiling window manager with built-in wallpaper and a clock/bar, with configuration in Kdl
  - [x] Canoe - Stacking window manager with classic look and feel, written in Rust
  - [x]  kuskokwim - A tiling window manager with composable keybindings and first-class support for process management, written in Python
  - [x]  kwm - DWM-like dynamic tilling window manager with scrollable-tiling support, includes a simple status bar, written in Zig
  - [x]  machi - Minimalist window manager with cascading windows, horizontal panels and vertical workspaces
  - [x]  mousetrap - Minimal stumpwm/ratpoison-like window manager, using modern c++
  - [x]  pwm - Tiling window manager with SSD titlebars and Python API
  - [x]  rhine - Tiling window manager with a bsp layout, some Hyprland IPC for bars and ambitions of modularity
  - [x]  rijan - Small dynamic tiling window manager in 600 lines of Janet
  - [x]  rill - A minimalist scrolling window manager with simple animation, written in Zig
  - [x]  rrwm - Tiling window manager with a cosmic/bspwm layout, written in Rust
  - [x]  tarazed - Non-tiling window manager focusing on a powerful and distraction-free desktop experience
  - [x]  zrwm - Dynamic tiling window manager configured using a CLI tool
 - [x] River 0.4.0 module: `programs.river-next`
  - [x] `xwayland.enable`, `manpages.enable`: options to enable/disable `xwayland` and `man` pages for River. Those are enabled by default.
  - [x] `windowManagers`: option to select window manager(s) to install, along with creating respective desktop sessions for display managers to invoke. Empty by default.
  - [x] `extraPackages`: option to include extra packages. By default includes `foot` and `fuzzel` as those are most commonly by the window managers here by default.

## Goals
1. ~~Finish writing derivations for the window managers listed above.~~
2. ~~Write a module for River, along with options for enabling supported window managers.~~ 
3. Version control beyond manually running update scripts.

## Notes
Please note that all the packages here are pulling changes against their respective main branches. For window managers in particular, some are further along in development than others. Therefore, the risk of experiencing a breaking change may vary, **but it is always non-zero**!
