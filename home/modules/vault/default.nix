{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.vault;
in {
  options.programs.vault = {
    enable = mkEnableOption "vault";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [vault];

    programs.zsh.shellAliases = {
      vlad = "vault login -method=ldap -path=ad username=$VAULT_USERNAME";
    };

    xdg.configFile."zsh/functions/vault-copy".source =
      mkIf config.programs.zsh.enable ./zsh/functions/vault-copy;

    programs.zsh.initExtra = ''
      source ${pkgs.vault}/share/bash-completion/completions/vault.bash
    '';
  };
}
