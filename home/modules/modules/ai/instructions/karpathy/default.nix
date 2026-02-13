{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAfter;
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
    programs.opencode.rules = mkAfter (builtins.readFile karpathyInstructions);
  };
}
