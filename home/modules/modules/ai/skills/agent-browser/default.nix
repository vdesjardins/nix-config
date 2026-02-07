{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.ai.skills.agent-browser;
in {
  options.modules.ai.skills.agent-browser = {
    enable = mkEnableOption "agent-browser skill";
  };

  config = mkIf cfg.enable {
    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser];

    # Link skill files from the npm package
    xdg.configFile."opencode/skill/agent-browser" = {
      source = "${inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser}/etc/agent-browser/skills/agent-browser";
      recursive = true;
    };
  };
}
