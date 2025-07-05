{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) package str;

  cfg = config.modules.desktop.extensions.wofi;
in {
  options.modules.desktop.extensions.wofi = {
    enable = mkEnableOption "wofi";

    package = mkOption {
      type = package;
      default = pkgs.wofi-wayland;
    };

    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.wofi = {
      inherit (cfg) enable;

      style = ''
        @define-color	selected-text  #7dcfff;
        @define-color	text  #cfc9c2;
        @define-color	base  #1a1b26;

        * {
          font-family: 'CaskaydiaMono Nerd Font', monospace;
          font-size: 18px;
        }

        window {
          margin: 0px;
          padding: 20px;
          background-color: @base;
          opacity: 0.95;
        }

        #inner-box {
          margin: 0;
          padding: 0;
          border: none;
          background-color: @base;
        }

        #outer-box {
          margin: 0;
          padding: 20px;
          border: none;
          background-color: @base;
        }

        #scroll {
          margin: 0;
          padding: 0;
          border: none;
          background-color: @base;
        }

        #input {
          margin: 0;
          padding: 10px;
          border: none;
          background-color: @base;
          color: @text;
        }

        #input:focus {
          outline: none;
          box-shadow: none;
          border: none;
        }

        #text {
          margin: 5px;
          border: none;
          color: @text;
        }

        #entry {
          background-color: @base;
        }

        #entry:selected {
          outline: none;
          border: none;
        }

        #entry:selected #text {
          color: @selected-text;
        }

        #entry image {
          -gtk-icon-transform: scale(0.7);
        }
      '';
    };

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          ''$mod, D, exec, ${getExe pkgs.flock} --nonblock /tmp/.wofi.lock -c "${getExe pkgs.wofi} --show drun --sort-order=alphabetical"''
          "$mod SHIFT, SPACE, exec, pkill -SIGUSR1 waybar"
        ];
      };
    };
  };
}
