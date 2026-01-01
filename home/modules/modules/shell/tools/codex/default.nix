{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.codex;
in {
  options.modules.shell.tools.codex = {
    enable = mkEnableOption "codex";
  };

  config = mkIf cfg.enable {
    programs.codex = {
      enable = true;

      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;

      settings = {
        profile = "llamacpp-gpt-oss-20b";

        features = {
          unified_exec = true;
          web_search_request = true;
          skills = true;
        };

        model_providers = {
          llamacpp = {
            name = "llamacpp";
            base_url = "http://localhost:11450/v1";
          };
          ollama = {
            name = "ollama";
            base_url = "http://localhost:11434/v1";
          };
        };

        profiles = {
          llamacpp-gpt-oss-20b = {
            model = "ggml-org/gpt-oss-20b-GGUF";
            model_provider = "llamacpp";
          };
          ollama-gpt-oss-20b = {
            model = "gpt-oss:20b";
            model_provider = "ollama";
          };
        };
      };
    };
  };
}
