{
  pkgs,
  config,
  options,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.myWofi;
in {
  options.programs.myWofi = {
    enable = mkEnableOption "myWofi";
    font = mkOption {
      type = types.str;
    };
  };

  config = {
    programs.wofi = lib.mkIf cfg.enable {
      enable = true;

      settings = {
        style = "$HOME/.config/wofi/style.css";
        xoffset = "710";
        yoffset = "275";
        show = "drun";
        width = "500";
        height = "500";
        always_parse_args = "true";
        show_all = "true";
        print_command = "true";
        layer = "overlay";
        insensitive = "true";
        prompt = "";
      };
    };

    xdg.configFile."wofi/style.css".text = ''
      window {
      margin: 0px;
      border: 2px solid #414868;
      border-radius: 5px;
      background-color: #24283b;
      font-family: ${cfg.font};
      font-size: 12px;
      }

      #input {
      margin: 5px;
      border: 1px solid #24283b;
      color: #c0caf5;
      background-color: #24283b;
      }

      #input image {
      	color: #c0caf5;
      }

      #inner-box {
      margin: 5px;
      border: none;
      background-color: #24283b;
      }

      #outer-box {
      margin: 5px;
      border: none;
      background-color: #24283b;
      }

      #scroll {
      margin: 0px;
      border: none;
      }

      #text {
      margin: 5px;
      border: none;
      color: #c0caf5;
      }

      #entry:selected {
      	background-color: #414868;
      	font-weight: normal;
      }

      #text:selected {
      	background-color: #414868;
      	font-weight: normal;
      }
    '';
  };
}
