{
  config,
  lib,
  pkgs,
  ...
}: let
  font = "Monaspace Radon";
  pkg_wezterm = pkgs.unstable.wezterm;
  src = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
    rev = "f247ee700b569ed43f39320413a13ba9b0aef0db";
    sha256 = "sha256-axjZVZOI+WIv85FfMG+lxftDKlDIw/HzQKyJVFkL33M=";
  };
  file = "extras/wezterm/tokyonight_storm.toml";
in {
  programs.wezterm = {
    enable = true;

    package = pkg_wezterm;

    enableZshIntegration = true;

    extraConfig = import ./wezterm-tmux.nix {
      inherit font;
      inherit (config.home) homeDirectory;
    };

    colorSchemes = builtins.fromTOML (builtins.readFile "${src}/${file}");
  };
}
