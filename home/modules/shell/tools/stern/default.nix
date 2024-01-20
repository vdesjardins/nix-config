{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.stern;
in {
  options.modules.shell.tools.stern = {
    enable = mkEnableOption "stern";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [unstable.stern];

    programs.zsh.initExtra = ''
      source <(${pkgs.stern}/bin/stern --completion zsh)
    '';
  };
}
