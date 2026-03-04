{
lib,
stdenv,
fetchFromGitHub,
withBar ? true,
withCustomConfig ? false,
scdoc,
zig_0_15,
libxkbcommon,
wayland,
wayland-protocols,
callPackage,
pkg-config,
wayland-scanner,
pixman,
fcft,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kewuaa";
  version = "unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "bba0540585734e027733bc9077cbc729ea37d6ee";
    hash = "sha256-L3onRky3aS/P119NFujCzJiroKcN1uxQ8z0xI5fGbzs=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    wayland
    wayland-protocols
    pixman
    fcft
    libxkbcommon
  ];

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ]
  ++ lib.optional withBar "-Dbar"
  ++ lib.optional withCustomConfig "-Dconfig"; #
})
