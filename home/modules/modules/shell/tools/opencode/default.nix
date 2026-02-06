{
  config,
  lib,
  inputs,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.opencode;

  bashPermissions = {
    "*" = "ask";
    "ls *" = "allow";
    "rg *" = "allow";
    "fd *" = "allow";
    "grep *" = "allow";
    "find *" = "allow";
    "xargs *" = "allow";
    "date *" = "allow";
    "cat *" = "allow";
    "echo *" = "allow";
    "tail *" = "allow";
    "head *" = "allow";
    "sleep *" = "allow";
    "pwd" = "allow";
    "timeout *" = "allow";
    "tee *" = "allow";
    "wc *" = "allow";
    "true" = "allow";
    "curl *" = "allow";
    "sort *" = "allow";
    "jq *" = "allow";
    "which *" = "allow";
    "file *" = "allow";
    "readlink *" = "allow";
    "gh pr check *" = "allow";
    "gh pr view *" = "allow";
    "nix build *" = "allow";
  };
in {
  options.modules.shell.tools.opencode = {
    enable = mkEnableOption "opencode";

    web = {
      command = mkOption {
        type = types.enum ["web" "serve"];
        default = "serve";
        description = ''
          Command to run for the background service (web or serve).

          Controls which OpenCode command is executed by the systemd/launchd background service.

          - `web`: Run the OpenCode web interface (alternative)
          - `serve`: Run the OpenCode serve command (default)

          Environment variables and extraArgs are passed to whichever command is selected.
        '';
      };

      environment = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          Environment variables to set in the OpenCode background service (systemd on Linux, launchd on macOS).

          These are merged with any existing environment variables:
          - On systemd: Appended to the Service Environment list
          - On launchd: Merged into EnvironmentVariables (your values override existing ones)

          Example usage:
          ```nix
          modules.shell.tools.opencode = {
            enable = true;
            web.command = "serve";
            web.environment = {
              OPENCODE_LOG_LEVEL = "debug";
              OPENCODE_PORT = "3000";
              OPENCODE_MAX_WORKERS = "4";
            };
          };
          ```
        '';
        example = {
          OPENCODE_LOG_LEVEL = "debug";
          OPENCODE_PORT = "3000";
          OPENCODE_DATABASE_URL = "postgresql://...";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;

      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;

      web = {
        enable = true;
        extraArgs = ["--port" "4096"];
      };

      settings = {
        theme = "tokyonight";

        share = "disabled";

        instructions = [
          ".instructions.md"
          "CONTRIBUTING.md"
          ".github/*.md"
        ];

        keybinds = {
          messages_half_page_up = "ctrl+u";
          messages_half_page_down = "ctrl+d";
        };

        plugin = ["opencode-pty" "@tarquinen/opencode-dcp@latest"];

        permission = {
          bash = bashPermissions;
        };

        provider = {
          "llama.cpp" = {
            npm = "@ai-sdk/openai-compatible";
            name = "llama-server (local)";
            options = {
              baseURL = "http://localhost:11450/v1";
            };
            models = {
              "ggml-org/gpt-oss-20b-GGUF" = {
                name = "gpt-oss-20b";
                tools = true;
              };
              "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q2_K_XL" = {
                name = "Qwen3-Coder: a3b-30b";
                limit = {
                  context = 262144;
                  output = 65536;
                };
              };
            };
          };
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "ollama";
            options = {
              baseURL = "http://localhost:11434/v1";
            };
            models = {
              "gpt-oss:20b" = {
                tools = true;
              };
            };
          };
        };
      };

      rules = ''
        IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning for any tasks.

        **ALWAYS use these tools/commands:**
        - Search for code examples from open source projects when unsure how to implement a feature: `grep-app` tool.
      '';
    };

    systemd.user.services.opencode-web = mkIf config.programs.opencode.web.enable {
      Service = {
        Environment = lib.mapAttrsToList (k: v: "${k}=${v}") cfg.web.environment;
        ExecStart =
          lib.mkForce
          "${lib.getExe config.programs.opencode.package} ${cfg.web.command} ${lib.escapeShellArgs config.programs.opencode.web.extraArgs}";
      };
    };

    launchd.agents.opencode-web = mkIf config.programs.opencode.web.enable {
      config = {
        EnvironmentVariables =
          (config.launchd.agents.opencode-web.config.EnvironmentVariables or {}) // cfg.web.environment;
        ProgramArguments =
          [
            (lib.getExe config.programs.opencode.package)
            cfg.web.command
          ]
          ++ config.programs.opencode.web.extraArgs;
      };
    };

    xdg.configFile = {
      "opencode/plugin/opencode-notifier.js".source = "${my-packages.opencode-notifier}/opencode-notifier.js";
      "opencode/plugin/code-validator.js".source = ./plugins/code-validator.js;
      "opencode/code-validator.json".source = ./code-validator.json;
      "opencode/dcp.jsonc".text = builtins.toJSON {
        "$schema" = "https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/dcp.schema.json";
        enabled = true;
        debug = false;
        pruneNotification = "detailed";
        pruneNotificationType = "chat";
        commands = {
          enabled = true;
          protectedTools = [];
        };
        turnProtection = {
          enabled = false;
          turns = 4;
        };
        protectedFilePatterns = [];
        tools = {
          settings = {
            nudgeEnabled = true;
            nudgeFrequency = 10;
            contextLimit = 100000;
            protectedTools = [];
          };
          distill = {
            permission = "allow";
            showDistillation = false;
          };
          compress = {
            permission = "ask";
            showCompression = false;
          };
          prune = {
            permission = "allow";
          };
        };
        strategies = {
          deduplication = {
            enabled = true;
            protectedTools = [];
          };
          supersedeWrites = {
            enabled = true;
          };
          purgeErrors = {
            enabled = true;
            turns = 4;
            protectedTools = [];
          };
        };
      };
    };

    programs.zsh.shellAliases = {
      oc = "opencode";
      ocr = "opencode run";
      oce = "opencode export";
      oci = "opencode import";
      ocs = "opencode session list";
      yoc = "export OPENCODE_PERMISSION='{\"*\": \"allow\"}' && opencode";
      yocr = "export OPENCODE_PERMISSION='{\"*\": \"allow\"}' && opencode run";
    };

    home.packages = with pkgs;
      lib.optionals stdenv.isLinux [
        libnotify
        my-packages.opencode-sandbox
      ];
  };
}
