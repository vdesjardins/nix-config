{
  config,
  lib,
  my-packages,
  inputs,
  pkgs,
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

      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

      settings = {
        theme = "tokyonight";

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
            "git status" = "allow";
            "git diff" = "allow";
            "git add" = "allow";
            "git commit" = "allow";
            "git checkout" = "allow";
            "git stash" = "allow";
            "ls" = "allow";
          };
        };

        provider = {
          llamacpp = {
            npm = "@ai-sdk/openai-compatible";
            name = "llamacpp";
            options = {
              baseURL = "http://localhost:11450/v1";
            };
            models = {
              "ggml-org/gpt-oss-20b-GGUF" = {
                tools = true;
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

        plugin = [
          "${my-packages.opencode-skills}/lib/node_modules/opencode-skills/dist/index.js"
        ];
      };
    };
  };
}
