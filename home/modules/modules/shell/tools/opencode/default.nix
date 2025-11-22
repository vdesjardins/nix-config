{
  config,
  lib,
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
      settings = {
        provider = {
          local = {
            npm = "@ai-sdk/openai-compatible";
            name = "local";
            options = {
              baseURL = "http://localhost:11450/v1";
            };
            models = {
              llamacpp = {
                name = "LlamaCPP";
                limit = {
                  context = 32768;
                  output = 32768;
                };
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
