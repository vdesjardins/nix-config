{
  config,
  lib,
  inputs,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.opencode;
in {
  options.modules.shell.tools.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;

      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;

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

        permission = {
          bash = {
            "*" = "ask";
            "ls*" = "allow";
            "rg*" = "allow";
            "fd*" = "allow";
            "grep*" = "allow";
            "find*" = "allow";
            "xargs*" = "allow";
            "date*" = "allow";
            "cat*" = "allow";
            "echo*" = "allow";
            "tail*" = "allow";
            "head*" = "allow";
            "sleep*" = "allow";
            "pwd" = "allow";
            "timeout*" = "allow";
            "tee*" = "allow";
            "wc*" = "allow";
            "true" = "allow";
            "nix build*" = "allow";
          };
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
        After applying each change, create a file called INTENTS-[YYYY-MM-DD-HH-mm].md
        that includes the prompt used to make this change. Do not call any scm tools for this operation.
        Use `date` to generate the timestamp for the filename.

        **ALWAYS use these tools/commands:**
        - For documentation when unsure how to use a command or library: `context7` tool.
        - Search for code examples from open source projects when unsure how to implement a feature: `grep-app` tool.
      '';
    };

    xdg.configFile = {
      "opencode/plugin/opencode-notifier.js".source = "${my-packages.opencode-notifier}/opencode-notifier.js";
      "opencode/plugin/code-validator.js".source = ./plugins/code-validator.js;
      "opencode/code-validator.json".source = ./code-validator.json;
    };

    programs.zsh.shellAliases = {
      oc = "opencode";
      ocr = "opencode run";
      oce = "opencode export";
      oci = "opencode import";
      ocs = "opencode session list";
    };

    home.packages = with pkgs;
      lib.optionals stdenv.isLinux [
        libnotify
      ];
  };
}
