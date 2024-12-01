{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.editors.nixvim;
in {
  options.modules.desktop.editors.nixvim = {
    enable = mkEnableOption "neovim editor";
  };

  imports = [
    ./keymappings.nix
    ./options.nix
    ./plugins
  ];

  config = mkIf cfg.enable {
    home.shellAliases.v = "nvim";

    programs.nixvim = {
      enable = true;

      package = pkgs.neovim;

      defaultEditor = true;

      performance = {
        byteCompileLua.enable = true;
      };

      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;
    };
  };
}
