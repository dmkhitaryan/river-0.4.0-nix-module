{
  stdenv,
  fetchFromGitLab,
  wayland,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
  gnumake,
  libbsd,
  libscfg,
  libevdev,
  pixman,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "tarazed";
  src = fetchFromGitLab {
    domain = "gitlab.gwdg.de";
    owner = "leonhenrik.plickat";
    repo = "tarazed";
    rev = "25ff1c6ac5fd733c3febcdb2e475e1642c9815af";
    hash = "sha256-pZMNq2LLzJIkzbiV1clh+BAKP0hVpmGHgS2hRD7o9/U=";
  };

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
    gnumake
  ];
  buildInputs = [
    wayland
    libbsd
    libscfg
    libevdev
    pixman
    libxkbcommon
    wayland-protocols
  ];

  installPhase = ''
    install -Dm755 tarazed $out/bin/tarazed
  '';
})
