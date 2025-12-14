{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (builtins) hasAttr;
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr;

  jsonFormat = pkgs.formats.json {};

  cfg = config.modules.shell.tools.github-copilot-cli;
in {
  options.modules.shell.tools.github-copilot-cli = {
    enable = mkEnableOption "github-copilot-cli";

    settings = mkOption {
      type = nullOr jsonFormat.type;
      description = "Configuration for github-copilot-cli";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli
    ];

    xdg.configFile = {
      ".copilot/mcp-config.json".source =
        mkIf (hasAttr "mcpServers" cfg.settings)
        (jsonFormat.generate "mcp-config.json"
          {
            inherit (cfg.settings) mcpServers;
          });
    };
  };
}
