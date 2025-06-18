{
  fetchFromGitHub,
  lib,
  stdenv,
  gawk,
  buku,
  ...
}:
stdenv.mkDerivation {
  pname = "rofi-buku";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "knatsakis";
    repo = "rofi-buku"; # Bat uses sublime syntax for its themes
    rev = "e483b5a94102f06627b603e70dceba91487726a0";
    hash = "sha256-eHzfKksrVOgDC15JDfGg3I0+XvHKH+I99A5T33U2tT0=";
  };

  doCheck = false;

  buildInputs = [
    gawk
    buku
  ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 rofi-buku $out/bin/rofi-buku
    install -Dm644 config.buku $out/usr/share/doc/rofi-buku/config.example
    install -Dm644 config.buku $out/etc/rofi-buku.config
    install -Dm644 README.md $out/usr/share/doc/rofi-buku/README.md
  '';

  fixupPhase = ''
    patchShebangs $out/bin
    substituteInPlace $out/bin/rofi-buku \
    --replace "gawk" ${gawk}/bin/gawk \
    --replace " awk" " ${gawk}/bin/awk" \
    --replace "buku " "${buku}/bin/buku "
  '';

  meta = {
    description = "rofi frontend for buku bookmarks manager";
    homepage = "https://github.com/knatsakis/rofi-buku";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
  };
}
