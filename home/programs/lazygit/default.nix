{
  lib,
  pkgs,
  ...
}:
with lib; {
  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        quitOnTopLevelReturn = true;
        disableStartupPopups = true;
      };
    };
  };

  programs.zsh.shellAliases = {
    lg = "lazygit";
  };
}
