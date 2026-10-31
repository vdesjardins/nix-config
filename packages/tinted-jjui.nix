{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tinted-jjui";
  version = "1.0-2bf3c44c78af63d83958c63eee2845d5f2c3a526";

  src = fetchFromGitHub {
    owner = "vic";
    repo = "tinted-jjui";
    rev = "2bf3c44c78af63d83958c63eee2845d5f2c3a526";
    hash = "sha256-V8ShPDJsTCsvIvOTUk4cfAQR7HQFbeN4Zqg65Si7RoE=";
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
