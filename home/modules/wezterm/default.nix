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

  cfg = config.programs.wezterm;
in {
  options.programs.wezterm = {
    font = mkOption {
      type = types.str;
    };
    useTmux = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      package = pkg_wezterm;

      enableZshIntegration = true;

      extraConfig =
        import (
          if cfg.useTmux
          then ./wezterm-tmue.nix
          else ./wezterm.nix
        ) {
          inherit pkgs;
          inherit (cfg) font;
          inherit (config.home) homeDirectory;
        };

      colorSchemes = builtins.fromTOML (builtins.readFile "${src}/${file}");
    };

    xdg.configFile."wezterm/my-config".source = ./my-config;
  };
}
