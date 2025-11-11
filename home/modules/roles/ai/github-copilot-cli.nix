{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.github-copilot-cli;
in {
  options.roles.ai.github-copilot-cli = {
    enable = mkEnableOption "github-copilot-cli";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.github-copilot-cli.enable = true;
  };
}
