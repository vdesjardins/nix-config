{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) anything attrsOf package;

  defaultSettings = {
    theme = {
      name = "tokyo-night";
    };
    terminal = {
      shell_mode = "auto";
      new_cwd = "follow";
    };
    update = {
      channel = "stable";
      version_check = true;
      manifest_check = true;
    };
    keys = {
      prefix = "ctrl+space";
      reload_config = "prefix+r";
      detach = "prefix+d";
      new_tab = "prefix+c";
      rename_tab = "prefix+comma";
      previous_tab = "prefix+p";
      next_tab = "prefix+n";
      switch_tab = "prefix+1..9";
      close_tab = "prefix+ampersand";
      rename_pane = "prefix+shift+p";
      edit_scrollback = "prefix+e";
      focus_pane_left = [
        "prefix+h"
        "ctrl+h"
      ];
      focus_pane_down = [
        "prefix+j"
        "ctrl+j"
      ];
      focus_pane_up = [
        "prefix+k"
        "ctrl+k"
      ];
      focus_pane_right = [
        "prefix+l"
        "ctrl+l"
      ];
      cycle_pane_next = "prefix+ctrl+a";
      cycle_pane_previous = "prefix+shift+ctrl+a";
      split_vertical = "prefix+s";
      split_horizontal = "prefix+v";
      resize_mode = "prefix+Z";
    };
    ui = {
      toast = {
        delivery = "off";
        delay_seconds = 1;
      };
      sound = {
        agents = {
          droid = "off";
        };
      };
    };
    experimental = {
      pane_history = false;
    };
  };

  tomlFormat = pkgs.formats.toml {};

  cfg = config.modules.ai.agents.herdr;
in {
  options.modules.ai.agents.herdr = {
    enable = mkEnableOption "herdr";

    package = mkOption {
      type = package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
      description = "herdr terminal workspace manager package";
    };

    settings = mkOption {
      type = attrsOf anything;
      default = defaultSettings;
      description = "Herdr config written to ~/.config/herdr/config.toml";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."herdr/config.toml".source = tomlFormat.generate "herdr-config.toml" cfg.settings;
  };
}
