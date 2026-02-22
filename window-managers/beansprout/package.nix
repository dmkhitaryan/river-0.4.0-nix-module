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
fcft,
pixman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beansprout";
  version = "unstable-2026-02-20";

  src = fetchFromCodeberg {
    owner = "bwbuhse";
    repo = "beansprout";
    rev = "5f4d80f31398570cbb45196b3d1b5e8f49005c4b";
    hash = "sha256-gO/GeccAaOa+WL5bMC4bJS9ui1rqwhbsLCpC/O2MCjA=";
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
    pixman
    fcft
  ] ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 examples/config.kdl -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
