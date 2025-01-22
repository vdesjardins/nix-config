{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "colortheme-tokyonight";
  version = "2025-01-22";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
    rev = "c3ab53c3f544e4a04f2a05d43451fd9bedff51b4";
    sha256 = "sha256-vY054vqhOLyARRpm3XcfM84Qzwb3mMIh5QRSQU1Bcg0=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/themes/tokyonight/
    cp -r colors $out/share/themes/tokyonight/
    cp -r extras $out/share/themes/tokyonight/
  '';

  meta = with lib; {
    description = "🏙 A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins. Includes additional themes for Kitty, Alacritty, iTerm and Fish.";
    homepage = "https://github.com/folke/tokyonight.nvim";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
