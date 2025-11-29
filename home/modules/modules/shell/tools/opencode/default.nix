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

      package = inputs.opencode.packages.${pkgs.system}.default;

      settings = {
        provider = {
          llamacpp = {
            npm = "@ai-sdk/openai-compatible";
            name = "llamacpp";
            options = {
              baseURL = "http://localhost:11450/v1";
            };
            models = {
              gpt-oss-20b = {
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
