{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "colortheme-tokyonight";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
    rev = "v4.12.0";
    sha256 = "sha256-fj6x7R11+s0/lhWCe0s3ELTRLgvU25Rjp4M5vZw5i3c=";
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
