{
  python3Packages,
  fetchFromCodeberg,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pkg-config,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "kuskokwim";
  version = "unstable-2026-02-23";

  pyproject = true;

  src = fetchFromCodeberg {
    owner = "ricci";
    repo = "kuskokwim";
    rev = "d912850aa466d9f05d2806002aaff65ecf4431f0";
    hash = "sha256-o8rUs4PldLcOmi1lKQQbi3II5dk+o7gN1XVBkZn5ySY=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  dependencies = [
    python3Packages.pillow
    python3Packages.pydantic
    python3Packages.xkbcommon
  ];

  postInstall = ''
    install -Dm755 $src/config.example.toml -t $out/example/config.toml
  '';

  doCheck = false;
})
