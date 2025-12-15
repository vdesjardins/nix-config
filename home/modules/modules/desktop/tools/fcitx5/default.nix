{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.tools.fcitx5;
in {
  options.modules.desktop.tools.fcitx5 = {
    enable = mkEnableOption "fcitx5";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        addons = with pkgs; [
          fcitx5-tokyonight
        ];

        settings = {
          addons = {
            # disable hint triggers to avoid interference with tmux move pane (ctrl+alt+h, ctrl+alt+j)
            keyboard.globalSection = {
              "Hint Trigger" = "";
              "One Time Hint Trigger" = "";
            };
          };
        };
      };
    };
  };
}
