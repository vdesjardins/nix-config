{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkBefore;
  cfg = config.modules.ai.instructions.karpathy;

  # Fetch Karpathy's AI coding guidelines from GitHub
  karpathyInstructions = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md";
    sha256 = "sha256-aUotch5Bw4Xz20koOMIymYJt9bqYCeOwchqscAIeGWo=";
  };
in {
  options.modules.ai.instructions.karpathy = {
    enable = mkEnableOption "Karpathy AI coding guidelines for OpenCode";
  };

  config = mkIf cfg.enable {
    modules.ai.agents.kiro.settings.prompts = [
      (builtins.readFile karpathyInstructions)
    ];
    modules.ai.agents.github-copilot-cli.settings.prompts = [
      (builtins.readFile karpathyInstructions)
    ];

    programs.opencode.rules = mkBefore (builtins.readFile karpathyInstructions);
  };
}
