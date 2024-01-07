{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = mkIf config.programs.nix-index.enable {
    home.packages = with pkgs; [comma];
    programs.nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
