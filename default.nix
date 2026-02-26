{
  nixosModule = import ./river-module.nix;

  packages = {
    river-next  = ./river-dev.nix;
    beansprout  = ./window-managers/beansprout/package.nix;
    canoe       = ./window-managers/canoe/package.nix;
    kuskokwim   = ./window-managers/kuskokwim/package.nix;
    kwm         = ./window-managers/kwm/package.nix;
    machi       = ./window-managers/machi/package.nix;
    mousetrap   = ./window-managers/mousetrap/package.nix;
    pwm         = ./window-managers/pwm/package.nix;
    rhine       = ./window-managers/rhine/package.nix;
    rijan       = ./window-managers/rijan/package.nix;
    rill        = ./window-managers/rill/package.nix;
    rrwm        = ./window-managers/rrwm/package.nix;
    tarazed     = ./window-managers/tarazed/package.nix;
    zrwm        = ./window-managers/zrwm/package.nix;
  };
}
