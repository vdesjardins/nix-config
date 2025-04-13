{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (config.modules.home) configDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.modules.desktop.tools.buku;
in {
  options.modules.desktop.tools.buku = {
    enable = mkEnableOption "buku";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [buku];

    programs.zsh.shellAliases = {
      b = "buku --suggest";
    };

    xdg.dataFile.buku.source =
      mkOutOfStoreSymlink "${configDirectory}/desktop/tools/buku/share";
  };
}
