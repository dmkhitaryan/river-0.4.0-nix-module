{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  wayland-protocols,
}:

let
  defaultConfig = ./default.toml;
in
rustPlatform.buildRustPackage {
  pname = "orilla";
  version = "unstable-2026-02-11";

  src = fetchFromSourcehut {
    owner = "~hokiegeek";
    repo = "orilla";
    rev = "870070ac5dca50a07fa5f1b7f544d0a49e82e118";
    hash = "sha256-R2f7RXZwl2QCWh3EyUsEOfZZsYYk6mJjdE52G9TBtyo=";
  };

  cargoHash = "sha256-0I7AiNaNlVG9Cvsz/DUMmgR6hBJAIJhn56nvGaqez88=";
  patches = [ ./xdg-config-path.patch ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
    wayland-protocols
  ];

  postInstall = ''
    install -Dm755 ${defaultConfig} $out/example/default.toml
  '';

}
