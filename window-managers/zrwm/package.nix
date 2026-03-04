{
  stdenv,
  fetchFromSourcehut,
  wayland,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
  gnumake,
  lib,
  git,
  fetchFromGitHub,
  writeText,
}:

let
  exampleConfig = ./init;
  libxkbcommon_13 = libxkbcommon.overrideAttrs (final: prev: {
    version = "1.13.1";
    src = fetchFromGitHub {
      owner = "xkbcommon";
      repo = "libxkbcommon";
      tag = "xkbcommon-${final.version}";
      hash = "sha256-wUsxsM0xXTg7nbvFMXrrnHherOepj0YI77eferjRgJA=";
    };
    patches = [
      (writeText "disable-x11com.patch" ''
        On nixpkgs /tmp/.X11-unix is not compatible with Xvfb requirement and the
        test fails.
        --- a/meson.build
        +++ b/meson.build
        @@ -1229,18 +1229,6 @@ if get_option('enable-x11')
                 env: test_env,
                 is_parallel : false,
             )
        -    test(
        -        'x11comp',
        -        executable(
        -            'test-x11comp',
        -            'test/x11comp.c',
        -            'test/utils-text.c',
        -            'test/utils-text.h',
        -            dependencies: x11_xvfb_test_dep
        -        ),
        -        env: test_env,
        -        is_parallel : false,
        -    )
         endif
         if get_option('enable-xkbregistry')
             test(
      '')
    ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrwm";
  version = "unstable-2026-02-22";

  src = fetchFromSourcehut {
    owner = "~zuki";
    repo = "zrwm";
    rev = "46305aa1f0c01e8d6f95c5127393d2ff8595d3da";
    hash = "sha256-ndZoxqnvPQwYzNrXBSdQ2GfKxG1b15t3HLs0+5D8DYE=";
  };

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
    git
  ];
  buildInputs = [
    wayland
    libxkbcommon_13
    wayland-protocols
  ];

  buildPhase = ''
    cc nob.c -o nob
    ./nob
  '';

  installPhase = ''
    install -Dm755 zrwm $out/bin/zrwm
    install -Dm755 zrwm-msg $out/bin/zrwm-msg
    install -Dm755 ${exampleConfig} $out/examples/init
  '';

  postPatch = ''
    substituteInPlace ipc.h \
      --replace \
        'init_file = malloc(sizeof(char) * (home_len + zrwm_init_text_len));' \
        'init_file = malloc(sizeof(char) * (home_len + zrwm_init_text_len + 1));'
  '';
})
