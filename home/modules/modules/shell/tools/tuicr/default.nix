{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.tuicr;

  # Fetch tuicr skill from GitHub
  tuicrSkill = pkgs.fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    rev = "main";
    hash = "sha256-seyQoEf+0KepXLJil83Wdb0fSIaifXRTyiBul9RaBOg=";
  };
in {
  options.modules.shell.tools.tuicr = {
    enable = mkEnableOption "tuicr - Terminal UI for code review and collaboration";
  };

  config = mkIf cfg.enable {
    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tuicr];

    xdg.configFile."opencode/skill/tuicr" = {
      source = "${tuicrSkill}/.claude/skill";
      recursive = true;
    };
  };
}
