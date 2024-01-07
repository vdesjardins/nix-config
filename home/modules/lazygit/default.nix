{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.programs.lazygit.enable {
    programs.lazygit = {
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
  };
}
