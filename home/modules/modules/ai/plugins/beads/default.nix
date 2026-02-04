{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.ai.plugins.beads;
in {
  options.modules.ai.plugins.beads = {
    enable = mkEnableOption "memory for ai agents";
  };

  config = mkIf cfg.enable {
    home.packages = [my-packages.beads];

    programs = {
      opencode = {
        settings = {
          plugin = ["opencode-beads"];
          permission.bash = {
            "bd *" = "allow";
          };
        };
      };

      jujutsu = {
        settings.merge-tools = {
          beads-merge = {
            program = "bd";
            merge-args = ["merge" "$output" "$base" "$left" "$right"];
            merge-conflict-exit-codes = [1];
          };
        };
      };

      zsh = {
        shellAliases = {
          bl = "bd list";
          blt = "bd list --tree";
        };
      };

      nushell = {
        shellAliases = {
          bl = "bd list";
          blt = "bd list --tree";
        };
      };
    };

    xdg.configFile."opencode/agent/beads" = {
      source = "${my-packages.beads}/share/claude-plugin/agents";
      recursive = true;
    };

    xdg.configFile."opencode/skill/beads" = {
      source = "${my-packages.beads}/share/claude-plugin/skills/beads";
      recursive = true;
    };
  };
}
