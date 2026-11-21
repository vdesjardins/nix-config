{
  config,
  lib,
  inputs,
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
          adapter = {
            name = "copilot";
            model = "claude-3.5-sonnet";
          };
        };
      };
      agent = mkOption {
        type = attrs;
        default = {
          adapter = {
            name = "copilot";
            model = "claude-3.5-sonnet";
          };
        };
      };
      inline = mkOption {
        type = attrs;
        default = {
          adapter = {
            name = "copilot";
            model = "claude-3.5-sonnet";
          };
        };
      };

      mcpServers = mkOption {
        type = attrs;
        default = {};
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

    xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      defaultApplications."text/csv" = [
        (
          if config.modules.desktop.terminal.ghostty.enable
          then "nvim-csv.desktop"
          else "nvim.desktop"
        )
      ];
    };

    xdg.desktopEntries.nvim-csv = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && config.modules.desktop.terminal.ghostty.enable) {
      name = "Neovim (CSV)";
      genericName = "Text Editor";
      exec = "${lib.getExe config.modules.desktop.terminal.ghostty.package} -e nvim %F";
      terminal = false;
      icon = "nvim";
      mimeType = ["text/csv"];
      categories = ["Utility" "TextEditor"];
      noDisplay = true;
    };

    programs.nixvim = {
      enable = true;

      inherit (cfg) colorschemes;

      package = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Use the host's pkgs (with overlays) so nixvim doesn't create its own
      # pkgs instance that lacks our overlays (e.g. claude-code 2.1.92).
      # allowBroken/allowUnfree are already set in the flake's global pkgsConfig.
      nixpkgs.useGlobalPackages = true;

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
