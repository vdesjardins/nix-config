{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.shell.tools.atuin;
in {
  options.modules.shell.tools.atuin = {
    enable = lib.mkEnableOption "atuin - shell history search";
    enableZshIntegration = lib.mkEnableOption "zsh integration" // {default = true;};
    enableNushellIntegration = lib.mkEnableOption "nushell integration" // {default = true;};
    enableDaemon = lib.mkEnableOption "atuin daemon for history syncing" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    # NOTE: After first apply, import existing zsh history with:
    #   atuin import zsh
    # This will populate atuin's database with all existing commands,
    # enabling immediate history search with timestamps and metadata.
    # History limit is set to 50,000 to match zsh capability.

    programs.atuin = {
      enable = true;
      inherit (cfg) enableZshIntegration enableNushellIntegration;

      # Theme settings - Tokyo Night Night with exact hex colors
      # Palette mapping:
      # - AlertError: #db4b4b (bright red for critical alerts)
      # - AlertWarn: #e0af68 (golden yellow for warnings)
      # - AlertInfo: #2ac3de (bright cyan-blue for info messages)
      # - Base: #c0caf5 (light lavender for default text)
      # - Guidance: #bb9af7 (bright lavender-purple for guide text)
      # - Annotation: #9ece6a (bright lime green for metadata)
      # - Important: #7dcfff (bright cyan for highlights)
      themes = {
        tokyo-night = {
          theme = {
            name = "tokyo-night";
          };
          colors = {
            AlertError = "#db4b4b";
            AlertWarn = "#e0af68";
            AlertInfo = "#2ac3de";
            Base = "#c0caf5";
            Guidance = "#bb9af7";
            Annotation = "#9ece6a";
            Important = "#7dcfff";
          };
        };
      };

      settings = {
        # General settings
        search_mode = "fuzzy";
        filter_mode = "global";
        filter_mode_shell_up_arrow = "session";
        stats = {
          common_prefix_len = 5;
          max_seconds = 3;
        };

        # UI settings
        show_preview = true;
        show_tabs = true;
        compact = false;

        theme.name = "tokyo-night";

        # Sync settings (if daemon is enabled via programs.atuin.daemon.enable)
        sync = {
          enabled = cfg.enableDaemon;
          records_enabled = true;
          key_path = "${config.home.homeDirectory}/.local/share/atuin/key";
          crypt_key_path = "${config.home.homeDirectory}/.local/share/atuin/crypt_key";
          auto_sync = true;
          sync_frequency = "5m";
          db_path = "${config.home.homeDirectory}/.local/share/atuin/history.db";
        };

        # History settings
        # Synced with zsh history limit (30,000 base + buffer for atuin's efficiency)
        history_limit = 50000;
        # Filter out commands that shouldn't be indexed:
        # - "^\\s": Commands starting with whitespace (typically hidden)
        # - "^exit": Exit command (rarely useful to track)
        # NOTE: 'cd' commands are NOT filtered - they sync across machines
        history_filter = [
          "^\\s"
          "^exit"
        ];
      };
    };

    # Enable daemon using upstream home-manager implementation
    # Automatically handles both systemd (Linux) and launchd (macOS)
    programs.atuin.daemon = lib.mkIf cfg.enableDaemon {
      enable = true;
      logLevel = null; # Set to "debug", "info", "warn", "error", or "trace" for logging
    };
  };
}
