{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.instructions.common;

  instructionsText = ''
    V owns this. Start: say 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

    IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning for any tasks.

    **ALWAYS use these tools/commands:**
    - Search for code examples from open source projects when unsure how to implement a feature: `grep-app` tool.
  '';
in {
  options.modules.ai.instructions.common = {
    enable = mkEnableOption "common AI instructions";
  };

  config = mkIf cfg.enable {
    modules.ai.agents.kiro.settings.prompts = [instructionsText];

    programs.opencode.rules = instructionsText;
  };
}
