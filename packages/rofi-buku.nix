{
  fetchFromGitHub,
  lib,
  stdenv,
  gawk,
  buku,
  ...
}: let
  versioning = builtins.fromJSON (builtins.readFile ./rofi-buku.json);
in
  stdenv.mkDerivation {
    pname = "rofi-buku";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "knatsakis";
      repo = "rofi-buku"; # Bat uses sublime syntax for its themes
      rev = versioning.revision;
      hash = versioning.hash;
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
      maintainers = with lib.maintainers; [vdesjardins];
    };
  }
