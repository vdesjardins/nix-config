{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.desktop.tools.keepassxc;
in {
  options.modules.desktop.tools.keepassxc = {
    enable = mkEnableOption "KeePassXC systemd service and git-based version control (requires programs.keepassxc.enable)";

    databasePath = mkOption {
      type = types.path;
      default = "${config.xdg.dataHome}/keepassxc/database.kdbx";
      readOnly = true;
      description = "Path to KeePassXC database file";
    };

    databaseDir = mkOption {
      type = types.path;
      default = "${config.xdg.dataHome}/keepassxc";
      readOnly = true;
      description = "Path to KeePassXC data directory";
    };

    git = mkOption {
      description = "Git-based version control for database";
      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Enable git versioning of database";
          };

          remoteUrl = mkOption {
            type = types.str;
            example = "git@github.com:vdesjardins/keepassxc-vault.git";
            description = "GitHub private repository URL (required if git.enable = true)";
          };

          autoCommit = mkOption {
            type = types.bool;
            default = true;
            readOnly = true;
            description = "Auto-commit database changes with debouncing (always enabled)";
          };

          commitMessage = mkOption {
            type = types.str;
            default = "Auto-backup: KeePassXC database update";
            description = "Commit message for auto-commits";
          };
        };
      };
      default = {};
    };

    syncthing = mkOption {
      description = "Syncthing synchronization settings";
      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Enable Syncthing sync of KeePassXC directory (manual configuration required)";
          };
        };
      };
      default = {};
    };

    windowRules = mkOption {
      description = "Hyprland window rules for KeePassXC";
      type = types.submodule {
        options = {
          floating = mkOption {
            type = types.bool;
            default = true;
            description = "Make KeePassXC windows floating in Hyprland";
          };
        };
      };
      default = {};
    };
  };

  imports = [
    ./systemd-timer.nix
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.git.enable -> (cfg.git.remoteUrl != "");
        message = "modules.desktop.tools.keepassxc: git.remoteUrl must be set when git.enable is true";
      }
    ];

    xdg.autostart.enable = true;

    programs.keepassxc = {
      enable = true;
      autostart = true;
      settings = {
        # Core application settings
        KeePassXC = {
          AutoSave = true;
          AutoSaveAfterEveryChange = false;
          AutoSaveAfterEveryChangeInterval = 10;
          ApplicationTheme = "dark";
          CompactMode = false;
          HidePasswords = true;
          AdvancedSettings = true;
        };

        # D-Bus Secret Service integration
        FdoSecrets = {
          Enabled = true;
          ShowNotification = false;
        };

        # Browser integration (native messaging manifest auto-installed by home-manager)
        Browser = {
          Enabled = true;
          UpdateBinaryPath = false;
        };

        # SSH Agent integration
        SSHAgent = {
          Enabled = true;
        };

        # Security and locking settings
        Security = {
          LockDatabaseOnScreenLock = true;
          LockDatabaseIdleSeconds = 300;
          LockDatabaseMinimizeOnLock = true;
          ClearClipboardSeconds = 10;
        };

        # Appearance
        GUI = {
          ApplicationTheme = "dark";
          CompactMode = false;
          DarkTrayIcon = true;
          LanguageOverride = "";
          MainWindowState = "";
          ShowTrayIcon = true;
          MinimizeToTray = true;
          MinimizeOnStartup = true;
          MinimizeOnClose = true;
          HideWindowOnOpen = false;
        };

        # Password generator defaults
        PasswordGenerator = {
          GeneratorType = "password";
          Length = 20;
          Numbers = true;
          LowerLetters = true;
          UpperLetters = true;
          SpecialCharacters = true;
          ExtendedASCII = false;
          Exclude = "";
          ExcludeAmbiguousCharacters = true;
          EnsureEveryGroupUsed = true;
        };
      };
    };

    # Ensure the KeePassXC data directory exists (writable, not in nix store)
    home.activation.createKeepassxcDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.local/share/keepassxc"
    '';

    # Configure KeePassXC window rules for Hyprland
    wayland.windowManager.hyprland.settings.windowrule = mkIf cfg.windowRules.floating [
      "match:class (org.keepassxc.KeePassXC), tag +password-manager"
    ];
  };
}
