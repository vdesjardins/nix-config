{
  pkgs,
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
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/beads"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/beads"
      ];
    };

    home.packages = [my-packages.beads pkgs.dolt];

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

    home.file = {
      ".kiro/skills/beads" = {
        source = "${my-packages.beads}/share/claude-plugin/skills/beads";
        recursive = true;
      };

      ".copilot/skills/beads" = {
        source = "${my-packages.beads}/share/claude-plugin/skills/beads";
        recursive = true;
      };
    };

    xdg.configFile = {
      "opencode/agent/beads" = {
        source = "${my-packages.beads}/share/claude-plugin/agents";
        recursive = true;
      };

      "opencode/skill/beads" = {
        source = "${my-packages.beads}/share/claude-plugin/skills/beads";
        recursive = true;
      };

      ".copilot/skills/beads" = {
        source = "${my-packages.beads}/share/claude-plugin/skills/beads";
        recursive = true;
      };
    };
  };
}
