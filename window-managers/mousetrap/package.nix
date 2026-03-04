{
  stdenv,
  fetchFromCodeberg,
  fetchFromGitHub,
  wayland,
  cairo,
  pango,
  tomlplusplus,
  pkg-config,
  wayland-scanner,
  meson,
  git,
  libxkbcommon,
  cmake,
  wayland-protocols,
  ninja,
  spdlog,
}:

let
  meson_1_10 = meson.overrideAttrs (final: prev: {
    version = "1.10.1";
    format = "setuptools";
    src = fetchFromGitHub {
      owner = "mesonbuild";
      repo = "meson";
      rev = final.version;
      hash = "sha256-UeSD3lIZ5hz3UsxZ1sCPzUhiekr3WIEiGxu+inyV8vo=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  name = "mousetrap";
  src = fetchFromCodeberg {
    owner = "g4b";
    repo = "mousetrap";
    rev = "5c7785fbb557d6888b0f2913eeb4b40028cb02aa";
    hash = "sha256-DgebH3dpQhl5cyQkRKzRmtnhdGmFWxTLJRjyrdhsd/s=";
  };

  nativeBuildInputs = [
    wayland-scanner
    meson_1_10
    git
    pkg-config
    cmake
    ninja
  ];
  buildInputs = [
    wayland
    cairo
    pango
    spdlog
    tomlplusplus
    libxkbcommon
    wayland-protocols
  ];

  postInstall = ''
    install -Dm755 $src/config.toml $out/examples/config.toml
  '';

})
