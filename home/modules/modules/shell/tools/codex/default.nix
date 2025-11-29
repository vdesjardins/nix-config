{
  config,
  lib,
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

      settings = {
        profile = "gpt-oss-20b";

        model_context_window = 32768;

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
          llamacpp = {
            model = "llamacpp";
            model_provider = "llamacpp";
          };
          gpt-oss-20b = {
            model = "gpt-oss:20b";
            model_provider = "ollama";
          };
        };
      };
    };
  };
}
