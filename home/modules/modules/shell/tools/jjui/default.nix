{
  config,
  lib,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.modules.shell.tools.jjui;
in {
  options.modules.shell.tools.jjui = {
    enable = mkEnableOption "jjui - TUI for jujutsu";

    settings = mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        jjui configuration. See
        <https://github.com/idursun/jjui/wiki/Configuration>
        for options.
      '';
    };

    withTintedThemes = mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to include tinted-jjui themes, symlinked to the jjui config directory.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.jjui = {
      inherit (cfg) enable settings;
      # Explicitly set configDir to use XDG-compliant paths on all platforms
      # (home-manager defaults to ~/Library/Application Support on macOS)
      configDir = "${config.xdg.configHome}/jjui";
    };

    home.packages = mkIf cfg.withTintedThemes [my-packages.tinted-jjui];

    home.file = mkIf cfg.withTintedThemes {
      "${config.xdg.configHome}/jjui/themes" = {
        source = "${my-packages.tinted-jjui}/share/jjui/themes";
        recursive = true;
      };
    };

    programs.zsh.shellAliases = {
      jui = "jjui";
    };
  };
}
