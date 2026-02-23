{
lib,
stdenv,
fetchFromCodeberg,
zig_0_15,
libxkbcommon,
wayland,
wayland-protocols,
callPackage,
pkg-config,
wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "unstable-2026-01-30";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    rev = "aba43eee098f70924550ef1dde671a0b2e09a4f7";
    hash = "sha256-KC1apGqgTqy9eENvIdTiF2qv2urEo+3O4V72fVgJSDo=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    wayland-protocols
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
  ];

  postInstall = ''
    install -Dm755 $src/config.rh -t $out/examples/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
