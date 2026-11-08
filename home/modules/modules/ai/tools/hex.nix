{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.ai.tools.hex;
in {
  imports = [inputs.hex.homeManagerModules.hex];

  options.modules.ai.tools.hex = {
    enable = lib.mkEnableOption "Hex local voice dictation";
    autostart = lib.mkEnableOption "Hex startup with the graphical session";
  };

  config = lib.mkIf cfg.enable {
    programs.hex = {
      enable = true;
      inherit (cfg) autostart;
    };

    # Niri's portal backend does not implement GlobalShortcuts. Invoke Hex's
    # service API directly instead; a toggle does not need a key-release bind.
    wayland.windowManager.niri.settings.binds."Alt+Space" = lib.mkIf config.modules.desktop.window-managers.niri.enable {
      _props = {
        repeat = false;
        allow-inhibiting = false;
        hotkey-overlay-title = "Toggle Hex Dictation";
      };
      spawn = [
        "${pkgs.writeShellScript "hex-dictation-toggle" ''
          exec ${lib.getExe' pkgs.systemd "systemd-cat"} --identifier=hex-shortcut \
            ${lib.getExe config.programs.hex.package} dictation toggle --json
        ''}"
      ];
    };
  };
}
