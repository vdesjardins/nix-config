{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrsOf anything either lines listOf package str;

  cfg = config.modules.ai.agents.pi;

  # Collect piEnv attrs from all pi packages that declare them
  piEnvVars = lib.foldl' lib.mergeAttrs {} (map (p: p.passthru.piEnv or {}) cfg.packages);

  tauEnvVars = lib.optionalAttrs (lib.any (p: (p.pname or null) == "pi-tau") cfg.packages) {
    TAU_DISABLED = "1";
  };

  # Convert Nix packages to their store path strings for settings.json
  packagePaths = map (p: "${p}") cfg.packages;

  hasNixConfig = cfg.packages != [] || cfg.settings != {};

  # Write Nix-managed config to the store so shell interpolation is safe
  # (no quoting issues regardless of JSON content)
  nixConfigFile = pkgs.writeText "pi-nix-config.json" (builtins.toJSON (
    cfg.settings
    // (lib.optionalAttrs (packagePaths != []) {packages = packagePaths;})
  ));
in {
  options.modules.ai.agents.pi = {
    enable = mkEnableOption "pi coding agent";

    package = mkOption {
      type = package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
      description = "pi coding agent package";
    };

    packages = mkOption {
      type = listOf package;
      default = [];
      description = ''
        Pi packages built by Nix. Each package's store path is added to the
        `packages` array in settings.json as a local path, so pi loads them
        directly without running npm at startup.
      '';
    };

    settings = mkOption {
      type = attrsOf anything;
      description = ''
        Additional keys merged into ~/.pi/agent/settings.json.
        Nix wins for any key defined here; all other keys in the file are
        left untouched so pi can still write to them interactively.
        See https://pi.dev/docs/settings for all available options.
        Note: use the `packages` option instead of setting packages here directly.
      '';
      default = {};
      example = {
        defaultProvider = "anthropic";
        defaultThinkingLevel = "medium";
        theme = "dark";
      };
    };

    prompts = mkOption {
      type = attrsOf lines;
      description = ''
        Prompt templates installed to ~/.pi/agent/prompts/<name>.md.
        Each key becomes the template name (invoked with /<name> in pi).
        Content uses the same markdown + frontmatter format as opencode commands:
          ---
          description: What this template does
          ---
          The prompt body...
      '';
      default = {};
      example = {
        review = ''
          ---
          description: Review staged changes
          ---
          Review the staged changes for bugs and security issues.
        '';
      };
    };

    voice = {
      stt = {
        enable = mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable local speech-to-text for pi-telegram voice messages.
            Installs a whisper-cpp + ffmpeg wrapper at ~/.local/bin/pi-stt and
            merges an audio/* inbound handler into ~/.pi/agent/telegram.json so
            Telegram voice notes are automatically transcribed before reaching
            the agent.
            The whisper base.en model (~142 MB) is downloaded on first use.
          '';
        };
      };
    };

    keybindings = mkOption {
      type = attrsOf (either str (listOf str));
      description = ''
        Custom keybindings written to ~/.pi/agent/keybindings.json.
        Each key is a namespaced action id; the value is a single key string
        or a list of key strings that override the default bindings for that action.
        Run /reload in pi to apply changes without restarting.
        See https://pi.dev/docs/keybindings for all action ids and defaults.

        Tree navigation actions (app.tree.*):
          app.tree.foldOrUp         default: ["ctrl+left" "alt+left"]
          app.tree.unfoldOrDown     default: ["ctrl+right" "alt+right"]
          app.tree.editLabel        default: "shift+l"
          app.tree.toggleLabelTimestamp  default: "shift+t"
          app.tree.filter.cycleForward   default: "ctrl+o"
          app.tree.filter.cycleBackward  default: "shift+ctrl+o"
      '';
      default = {};
      example = {
        "app.tree.foldOrUp" = ["ctrl+left" "alt+left" "alt+h"];
        "app.tree.unfoldOrDown" = ["ctrl+right" "alt+right" "alt+l"];
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        [cfg.package]
        ++ lib.concatMap (p: p.propagatedBuildInputs or []) cfg.packages;

      sessionVariables = piEnvVars // tauEnvVars;

      # Merge Nix-managed config into a writable settings.json so pi can still
      # write to it interactively (pi install, /settings, etc.).
      #
      # Merge rules:
      #   packages — union of user-added and Nix-managed; removals from Nix are
      #              tracked via ~/.pi/agent/.nix-packages.prev and propagated
      #   other keys — Nix wins for keys it defines; unrelated user keys preserved

      # Merge audio/* inbound handler into telegram.json so pi-telegram
      # transcribes voice messages via pi-stt. Idempotent: only adds the
      # handler if no audio/* entry is already present.
      activation.piTelegramVoice = mkIf cfg.voice.stt.enable (lib.hm.dag.entryAfter ["writeBoundary"] ''
        _tg_file="$HOME/.pi/agent/telegram.json"
        _jq="${lib.getExe pkgs.jq}"
        _stt_cmd="$HOME/.local/bin/pi-stt"

        if [ -f "$_tg_file" ]; then
          "$_jq" --arg cmd "$_stt_cmd" '
            (.inboundHandlers // []) as $h |
            if ($h | map(select(.mime == "audio/*")) | length) > 0
            then .  # audio/* handler already present, leave unchanged
            else .inboundHandlers = ($h + [{"mime": "audio/*", "template": [$cmd, "{file}"]}])
            end
          ' "$_tg_file" > "$_tg_file.tmp" && mv "$_tg_file.tmp" "$_tg_file"
        fi
      '');

      activation.piSettings = mkIf hasNixConfig (lib.hm.dag.entryAfter ["writeBoundary"] ''
        _pi_dir="$HOME/.pi/agent"
        _settings="$_pi_dir/settings.json"
        _prev_pkgs_file="$_pi_dir/.nix-packages.prev"
        _jq="${lib.getExe pkgs.jq}"

        mkdir -p "$_pi_dir"

        # Current Nix-managed packages (may be empty array)
        _nix_pkgs=$("$_jq" -c '.packages // []' "${nixConfigFile}")
        # Previously Nix-managed packages (from last apply, for removal tracking)
        _prev_pkgs=$([ -f "$_prev_pkgs_file" ] && cat "$_prev_pkgs_file" || echo '[]')

        if [ ! -f "$_settings" ]; then
          # First run: initialise from Nix config directly
          cp "${nixConfigFile}" "$_settings"
        else
          "$_jq" \
            --slurpfile nix "${nixConfigFile}" \
            --argjson prev "$_prev_pkgs" \
            --argjson curr "$_nix_pkgs" \
            '
              # Capture user packages before Nix overlay touches the key
              (.packages // []) as $user_pkgs |
              # Overlay: Nix wins for keys it defines, user keys preserved
              . * $nix[0] |
              # Rebuild packages:
              #   - drop user packages that were previously Nix-managed (removals)
              #   - keep user packages that were never Nix-managed
              #   - add current Nix packages
              .packages = (
                ($user_pkgs | map(select(. as $p | $prev | index($p) == null)))
                + $curr
                | unique
              )
            ' "$_settings" > "$_settings.tmp" && mv "$_settings.tmp" "$_settings"
        fi

        # Persist current Nix packages so next apply knows what to remove
        printf '%s' "$_nix_pkgs" > "$_prev_pkgs_file"
      '');

      # pi-stt: whisper-cpp STT wrapper for pi-telegram voice transcription.
      # Installed when voice.stt.enable = true; telegram.json handler merged
      # via the piTelegramVoice activation script.
      # Prompts are standalone files — no conflict with interactive pi usage.
      file =
        lib.optionalAttrs cfg.voice.stt.enable {
          ".local/bin/pi-stt" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              set -euo pipefail

              MODEL_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/whisper-cpp/models"
              MODEL="$MODEL_DIR/ggml-base.en.bin"
              FILE="''${1:?Usage: pi-stt <audio-file>}"

              # Download model on first use (~142 MB)
              if [ ! -f "$MODEL" ]; then
                mkdir -p "$MODEL_DIR"
                ${pkgs.whisper-cpp}/bin/whisper-cpp-download-ggml-model base.en "$MODEL_DIR" >&2
              fi

              # whisper-cpp requires WAV; convert OGG Opus (Telegram format) via ffmpeg
              WAV=$(mktemp --suffix=.wav)
              trap 'rm -f "$WAV"' EXIT
              ${pkgs.ffmpeg}/bin/ffmpeg -y -i "$FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV" 2>/dev/null

              # Transcribe and strip timestamp markers from output
              ${pkgs.whisper-cpp}/bin/whisper-cli \
                --model "$MODEL" \
                --no-prints \
                --language auto \
                "$WAV" 2>/dev/null \
                | sed 's/^\s*\[.*-->.*\]\s*//'
            '';
          };
        }
        // lib.optionalAttrs (cfg.keybindings != {}) {
          ".pi/agent/keybindings.json".text = builtins.toJSON cfg.keybindings;
        }
        // lib.mapAttrs' (
          name: content:
            lib.nameValuePair ".pi/agent/prompts/${name}.md" {text = content;}
        )
        cfg.prompts;
    };

    # Inject piEnv vars into Hyprland env directives when Hyprland is enabled.
    # greetd launches Hyprland directly (no login shell), so sessionVariables
    # are never sourced — Hyprland's own `env` directive is the only reliable path.
    wayland.windowManager.hyprland.settings.env =
      mkIf
      (config.wayland.windowManager.hyprland.enable or false)
      (lib.mapAttrsToList (k: v: "${k},${v}") piEnvVars);

    programs.zsh.shellAliases = {
      pii = "pi";
      pic = "pi -c";
      pir = "pi --resume";
    };

    modules.shell.nushell.globalAliases = {
      pii = "pi";
      pic = "pi -c";
      pir = "pi --resume";
    };
  };
}
