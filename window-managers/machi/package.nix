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
  pname = "machi";
  version = "0.1.0-dev";

  src = fetchFromCodeberg {
    owner = "machi";
    repo = "machi";
    rev = "097b31af73f3a5102a88947a731a1b91b50e3c8c";
    hash = "sha256-LD5iLjqQbPPCVOhIZKAdgxScxivTk9GMuwFkNOnOmks=";
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
    install -Dm755 example/machi.ini -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ] ++ [ "-Doptimize=ReleaseSafe" ];

})
