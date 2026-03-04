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
    rev = "f055b55a9454612b92d99341fcae88e5a6979426";
    hash = "sha256-KXLD7GSxO6iWSEX1d3QduM3oLfBJhxjofE1Wh0eKbMs=";
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
