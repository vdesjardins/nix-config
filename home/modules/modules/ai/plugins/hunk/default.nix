{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) package;

  cfg = config.modules.ai.plugins.hunk;
in {
  options.modules.ai.plugins.hunk = {
    enable = mkEnableOption "hunk terminal diff viewer with AI review skill";
    package = mkOption {
      type = package;
      default = inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk;
      description = "The hunk package to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    programs.opencode.settings.permission.bash = {
      "hunk *" = "allow";
    };

    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/hunk-review"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/hunk-review"
      ];
    };

    home.file = {
      ".kiro/skills/hunk-review".source = "${cfg.package}/skills/hunk-review";
      ".copilot/skills/hunk-review".source = "${cfg.package}/skills/hunk-review";
    };

    xdg.configFile = {
      "opencode/skill/hunk-review".source = "${cfg.package}/skills/hunk-review";
    };
  };
}
