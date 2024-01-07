{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.programs.joshuto.enable {
    programs.zsh.shellAliases = {
      j = "joshuto";
    };
  };
}
