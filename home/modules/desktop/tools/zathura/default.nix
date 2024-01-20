{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.tools.zathura;
in {
  options.modules.desktop.tools.zathura = {
    enable = mkEnableOption "zathura";
    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      options = {
        inherit (cfg) font;

        default-fg = "#c0caf5";
        default-bg = "2#4283b";

        completion-bg = "#24283b";
        completion-fg = "#c0caf5";
        completion-highlight-bg = "#414868";
        completion-highlight-fg = "#c0caf5";
        completion-group-bg = "#24283b";
        completion-group-fg = "#7aa2f7";

        statusbar-fg = "#a9b1d6";
        statusbar-bg = "#414868";
        statusbar-h-padding = 10;
        statusbar-v-padding = 10;

        notification-bg = "#414868";
        notification-fg = "#a9b1d6";
        notification-error-bg = "#f7768e";
        notification-error-fg = "#24283b";
        notification-warning-bg = "#e0af68";
        notification-warning-fg = "#24283b";
        selection-notification = true;

        inputbar-fg = "#c0caf5";
        inputbar-bg = "#24283b";

        recolor = true;
        recolor-lightcolor = "#24283b";
        recolor-darkcolor = "#c0caf5";

        index-fg = "#c0caf5";
        index-bg = "#24283b";
        index-active-fg = "#c0caf5";
        index-active-bg = "#414868";

        render-loading-bg = "#24283b";
        render-loading-fg = "#c0caf5";

        highlight-color = "#7aa2f7";
        highlight-active-color = "#bb9af7";

        adjust-open = "width";
      };
    };
  };
}
