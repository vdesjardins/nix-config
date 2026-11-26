{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-jjui";
  version = "0-unstable-2026-11-25";

  src = fetchFromGitHub {
    owner = "vic";
    repo = "tinted-jjui";
    rev = "0c3a2656082f7c18ee344fbdc9689f2d31a65ddf";
    hash = "sha256-RRAoCxzNxp3WHqDTgsXEz63S9Xm4jzDQi0V0fvwrJCg=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/jjui/themes
    cp -r themes/*.toml $out/share/jjui/themes/
  '';

  meta = with lib; {
    description = "jjui themes from base16 and base24 color schemes";
    homepage = "https://github.com/vic/tinted-jjui";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
