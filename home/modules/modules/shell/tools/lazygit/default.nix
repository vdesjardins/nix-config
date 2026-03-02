{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.lazygit;
in {
  options.modules.shell.tools.lazygit = {
    enable = mkEnableOption "lazygit";
  };

  config = mkIf cfg.enable {
    programs = {
      lazygit = {
        enable = true;
        settings = {
          gui.theme = {
            activeBorderColor = ["#89b4fa" "bold"];
            inactiveBorderColor = ["#a6adc8"];
            optionsTextColor = ["#89b4fa"];
            selectedLineBgColor = ["#313244"];
            cherryPickedCommitBgColor = ["#45475a"];
            cherryPickedCommitFgColor = ["#89b4fa"];
            unstagedChangesColor = ["#f38ba8"];
            defaultFgColor = ["#cdd6f4"];
            searchingActiveBorderColor = ["#f9e2af"];
          };
        };
      };

      zsh.shellAliases = {
        lg = "lazygit";
      };

      nushell.shellAliases = {
        lg = "lazygit";
      };
    };
  };
}
