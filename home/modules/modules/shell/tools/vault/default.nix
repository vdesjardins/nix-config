{
  config,
  pkgs,
  lib,
  stdenv,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.vault;
in {
  options.modules.shell.tools.vault = {
    enable = mkEnableOption "vault";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [vault];

    xdg.configFile."zsh/functions/vault-copy".source =
      mkIf config.programs.zsh.enable ./zsh/functions/vault-copy;

    programs.zsh.initContent = ''
      source ${pkgs.vault}/share/bash-completion/completions/vault.bash
    '';
  };
}
