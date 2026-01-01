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

      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      # package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

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
            "grep" = "allow";
            "find" = "allow";
            "xargs" = "allow";
            "date" = "allow";
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
              "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q2_K_XL"= {
                name= "Qwen3-Coder: a3b-30b";
                limit= {
                  context= 262144;
                  output= 65536;
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
      '';
    };
  };
}
