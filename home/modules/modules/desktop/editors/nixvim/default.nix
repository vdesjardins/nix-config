{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrs;

  cfg = config.modules.desktop.editors.nixvim;
in {
  options.modules.desktop.editors.nixvim = {
    enable = mkEnableOption "neovim editor";

    colorschemes = mkOption {
      type = attrs;
    };

    ai = {
      chat = mkOption {
        type = attrs;
        default = {
          adapter = "copilot";
          model = "claude-3.5-sonnet";
        };
      };
      agent = mkOption {
        type = attrs;
        default = {
          adapter = "copilot";
          model = "claude-3.5-sonnet";
        };
      };
      inline = mkOption {
        type = attrs;
        default = {
          adapter = "copilot";
          model = "claude-3.5-sonnet";
        };
      };
    };
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

      inherit (cfg) colorschemes;

      package = pkgs.neovim;

      nixpkgs.config.allowBroken = true;

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
