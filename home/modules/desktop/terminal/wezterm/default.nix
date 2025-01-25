{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) bool package str;

  cfg = config.modules.desktop.terminal.wezterm;
in {
  options.modules.desktop.terminal.wezterm = {
    enable = mkEnableOption "wezterm";
    font = mkOption {
      type = str;
    };

    font-italic = mkOption {
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

    color-scheme = mkOption {
      type = str;
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
          inherit (cfg) font font-italic color-scheme;
        };
    };

    xdg.configFile."wezterm/my-config".source = ./my-config;
  };
}
