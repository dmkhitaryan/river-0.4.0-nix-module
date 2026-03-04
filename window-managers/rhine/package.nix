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
    rev = "5a222116b0e75486c504a34495c1f1bf6ad88bb3";
    hash = "sha256-e53q2P3Hbrot8TpcK9lCwpm0BL5HSvTDE+zax3b9yiw=";
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
