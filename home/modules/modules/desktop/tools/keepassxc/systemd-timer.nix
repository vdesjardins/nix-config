{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.tools.keepassxc;

  # Auto-commit script with debouncing
  autoCommitScript = pkgs.writeShellScript "keepassxc-auto-commit" ''
    set -euo pipefail

    DB_PATH="${cfg.databasePath}"
    DB_DIR="${cfg.databaseDir}"
    LOCK_FILE="$DB_DIR/.git-commit.lock"

    # Logging function
    log() {
      echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    }

    log "=== Auto-commit script started ==="
    log "DB_PATH: $DB_PATH"
    log "DB_DIR: $DB_DIR"
    log "LOCK_FILE: $LOCK_FILE"

    # Only proceed if database exists
    if [[ ! -f "$DB_PATH" ]]; then
      log "Database file does not exist, exiting"
      exit 0
    fi
    log "Database file exists"

    # Only proceed if we're in a git repo
    if ! cd "$DB_DIR" 2>/dev/null || ! git rev-parse --git-dir > /dev/null 2>&1; then
      log "Not in a git repository, exiting"
      exit 0
    fi
    log "In git repository"

    # Prevent concurrent commits with a lock file
    if [[ -f "$LOCK_FILE" ]]; then
      log "Lock file exists, another instance is running, exiting"
      exit 0
    fi
    log "No lock file, proceeding"

    # Create lock file
    touch "$LOCK_FILE"
    log "Created lock file"
    trap "log 'Removing lock file'; rm -f $LOCK_FILE" EXIT

    # Get the current modification time
    CURRENT_MTIME=$(stat -c %Y "$DB_PATH" 2>/dev/null || echo 0)
    log "Current mtime: $CURRENT_MTIME"

    # Wait 30 seconds to allow more changes to batch
    log "Sleeping for 30 seconds to batch changes..."
    sleep 30
    log "Sleep complete"

    # Get the new modification time
    NEW_MTIME=$(stat -c %Y "$DB_PATH" 2>/dev/null || echo 0)
    log "New mtime: $NEW_MTIME"

    # Only commit if file has been modified during the wait
    if [[ $CURRENT_MTIME -ne $NEW_MTIME ]]; then
      log "File was modified during sleep, proceeding with commit"

      # Stage the database file
      if git add database.kdbx 2>&1; then
        log "Successfully staged database.kdbx"
      else
        log "Failed to stage database.kdbx"
      fi

      # Only commit if there are staged changes
      if git diff --cached --quiet 2>/dev/null; then
        log "No staged changes to commit"
      else
        log "Staged changes found, committing..."
        if git commit -m "${cfg.git.commitMessage}" 2>&1; then
          log "Commit successful"
        else
          log "Commit failed"
        fi
      fi
    else
      log "File was NOT modified during sleep, skipping commit"
    fi

    log "=== Auto-commit script finished ==="
    exit 0
  '';
in {
  config = mkIf (cfg.enable && cfg.git.enable) {
    systemd.user = {
      paths.keepassxc-auto-commit = {
        Unit = {
          Description = "Watch KeePassXC database for changes (debounced)";
          After = "keepassxc.service";
        };

        Path = {
          # Monitor the database file for modifications
          PathModified = cfg.databasePath;
          # Only trigger service if directory is not empty
          DirectoryNotEmpty = cfg.databaseDir;
          # Unit to trigger on path change
          Unit = "keepassxc-auto-commit.service";
          # Trigger at most once every 60 seconds (debounce window)
          MakeDirectory = false;
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };

      services.keepassxc-auto-commit = {
        Unit = {
          Description = "Auto-commit KeePassXC database to git";
          After = "keepassxc.service";
          PartOf = "keepassxc.service";
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${autoCommitScript}";
          StandardOutput = "journal";
          StandardError = "journal";
          StandardInput = "null";
          # Don't restart this service, it's triggered by path unit or timer
          RemainAfterExit = false;
          # Allow higher rate limits for path-triggered service
          StartLimitIntervalSec = 600;
          StartLimitBurst = 10;
          # Set environment to ensure git works
          Environment = "PATH=/run/current-system/sw/bin:/run/wrappers/bin:/home/vince/.nix-profile/bin";
          # Ensure git config works
          WorkingDirectory = "%h/.local/share/keepassxc";
        };

        # Don't add to any target - only triggered by path unit or timer
      };

      # Timer unit: periodic 15-minute checks to ensure regular backups
      timers.keepassxc-auto-commit-periodic = {
        Unit = {
          Description = "Periodic backup of KeePassXC database (every 15 minutes)";
          After = "keepassxc.service";
        };

        Timer = {
          # Run every 15 minutes
          OnBootSec = "5min";
          OnUnitActiveSec = "15min";
          # Trigger the service
          Unit = "keepassxc-auto-commit.service";
          # Randomize to avoid issues
          RandomizedDelaySec = "30s";
        };

        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
