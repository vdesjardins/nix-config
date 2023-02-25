{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = with pkgs; [vault];

  programs.zsh.shellAliases = {
    vlad = "vault login -method=ldap -path=ad username=$VAULT_USERNAME";
  };

  xdg.configFile."zsh/functions/vault-copy".source =
    mkIf config.programs.zsh.enable ./zsh/functions/vault-copy;

  programs.zsh.initExtra = ''
    source ${pkgs.vault}/share/bash-completion/completions/vault.bash
  '';
}
