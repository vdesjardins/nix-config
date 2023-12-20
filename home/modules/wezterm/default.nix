{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  pkg_wezterm = pkgs.unstable.wezterm;
  src = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
    rev = "f247ee700b569ed43f39320413a13ba9b0aef0db";
    sha256 = "sha256-axjZVZOI+WIv85FfMG+lxftDKlDIw/HzQKyJVFkL33M=";
  };
  file = "extras/wezterm/tokyonight_storm.toml";

  cfg = config.programs.myWezterm;
in {
  options.programs.myWezterm = {
    enable = mkEnableOption "myWeztern";
    font = mkOption {
      type = types.str;
    };
  };

  config = {
    programs.wezterm = {
      enable = true;

      package = pkg_wezterm;

      enableZshIntegration = true;

      extraConfig = import ./wezterm-tmux.nix {
        inherit (cfg) font;
        inherit (config.home) homeDirectory;
      };

      colorSchemes = builtins.fromTOML (builtins.readFile "${src}/${file}");
    };
  };
}
