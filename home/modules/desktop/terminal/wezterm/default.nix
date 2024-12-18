{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool package str;

  src = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
    rev = "f247ee700b569ed43f39320413a13ba9b0aef0db";
    sha256 = "sha256-axjZVZOI+WIv85FfMG+lxftDKlDIw/HzQKyJVFkL33M=";
  };
  file = "extras/wezterm/tokyonight_storm.toml";

  cfg = config.modules.desktop.terminal.wezterm;
in {
  options.modules.desktop.terminal.wezterm = {
    enable = mkEnableOption "wezterm";
    font = mkOption {
      type = str;
    };
    useTmux = mkOption {
      type = bool;
      default = false;
    };
    package = mkOption {
      type = package;
      default = pkgs.wezterm;
    };
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      inherit (cfg) enable;

      inherit (cfg) package;

      enableZshIntegration = true;

      extraConfig =
        import (
          if cfg.useTmux
          then ./wezterm-tmux.nix
          else ./wezterm.nix
        ) {
          inherit pkgs;
          inherit (cfg) font;
        };

      colorSchemes = builtins.fromTOML (builtins.readFile "${src}/${file}");
    };

    xdg.configFile."wezterm/my-config".source = ./my-config;
  };
}
