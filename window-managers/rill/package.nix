{
lib,
stdenv,
fetchFromCodeberg,
withManpages ? true,
scdoc,
zig_0_15,
libxkbcommon,
wayland,
wayland-protocols,
callPackage,
pkg-config,
wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "unstable-2026-02-20";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "fe78e170a49c74295310d7fd34aa8ff7b9167c39";
    hash = "sha256-LzBiOWJvM3aF+BEEyEORAjRjYOdDUhMg2Er5+3vRPDo=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
  ] ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 assets/config.zon -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
