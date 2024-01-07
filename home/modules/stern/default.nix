{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.stern;
in {
  options.programs.stern = {
    enable = mkEnableOption "stern";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [unstable.stern];

    programs.zsh.initExtra = ''
      source <(${pkgs.stern}/bin/stern --completion zsh)
    '';
  };
}
