{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.tools;
in {
  options.roles.ai.tools = {
    enable = mkEnableOption "AI tools bundle (ollama, llamacpp, claude, opencode, github-copilot-cli, mcp servers, skills)";

    # CLI Tools
    ollama = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Ollama";
      };
      settings = mkOption {
        type = lib.types.attrs;
        default = {
          enable = true;
          # TODO: not yet supported by home-manager module
          # acceleration = "vulkan";
          package = pkgs.ollama-vulkan;
        };
        description = ''
          Configuration for the Ollama service, which provides a server for local large language models.
        '';
      };
    };

    llamacpp = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable llama.cpp";
      };
      settings = mkOption {
        type = lib.types.attrs;
        default = {
          enable = true;
          package = inputs.llamacpp.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
        };
        description = ''
          Configuration for the llamacpp service
        '';
      };
    };

    claude.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Claude CLI";
    };

    opencode.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable OpenCode CLI";
    };

    github-copilot-cli.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable GitHub Copilot CLI";
    };

    plugins = {
      enable = mkEnableOption "plugins (all)";
      beads.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable beads integration";
      };
    };

    # MCP Servers
    mcp = {
      enable = mkEnableOption "MCP servers (all)";
      context7.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Context7 MCP server";
      };
      fluxcd.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable FluxCD MCP server";
      };
      git.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Git MCP server";
      };
      grep-app.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable grep-app MCP server";
      };
      github.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable GitHub MCP server";
      };
      grafana = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Grafana MCP server";
        };
        grafanaUrl = mkOption {
          type = types.str;
          default = "";
          description = "Grafana URL for MCP server";
        };
      };
      kubernetes.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Kubernetes MCP server";
      };
      nixos.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable NixOS MCP server (disabled by default due to fastmcp/mcp version mismatch)";
      };
      playwright.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Playwright MCP server";
      };
      sequential-thinking.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Sequential Thinking MCP server";
      };
      tree-sitter.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Tree-Sitter MCP server";
      };
      memory-service.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Memory Service MCP server";
      };
      tmux-mcp.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable tmux-mcp MCP server";
      };
    };

    # Skills
    skills = {
      enable = mkEnableOption "Skills (all)";
      conventional-commits.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable conventional-commits skill";
      };
      skill-creator.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable skill-creator";
      };
      skill-reviewer.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable skill-reviewer";
      };
      writing-skills.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable writing-skills";
      };
      dev-browser.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable dev-browser skill";
      };
      jj.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable jujutsu skill";
      };
      timewarrior.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable timewarrior skill";
      };
      tmux.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable tmux skill";
      };
      buku.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable buku skill";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      lib.optionals cfg.llamacpp.enable [cfg.llamacpp.settings.package];

    modules = {
      services.ollama = mkIf cfg.ollama.enable cfg.ollama.settings;

      shell.tools = {
        claude.enable = cfg.claude.enable;
        opencode.enable = cfg.opencode.enable;
        github-copilot-cli.enable = cfg.github-copilot-cli.enable;
      };

      ai = {
        plugins = {
          beads.enable = cfg.plugins.beads.enable;
        };

        mcp = {
          context7.enable = cfg.mcp.context7.enable;
          fluxcd.enable = cfg.mcp.fluxcd.enable;
          git.enable = cfg.mcp.git.enable;
          grep-app.enable = cfg.mcp.grep-app.enable;
          github.enable = cfg.mcp.github.enable;
          grafana = {
            inherit (cfg.mcp.grafana) enable grafanaUrl;
          };
          kubernetes.enable = cfg.mcp.kubernetes.enable;
          nixos.enable = cfg.mcp.nixos.enable;
          playwright.enable = cfg.mcp.playwright.enable;
          sequential-thinking.enable = cfg.mcp.sequential-thinking.enable;
          tree-sitter.enable = cfg.mcp.tree-sitter.enable;
          memory-service.enable = cfg.mcp.memory-service.enable;
          tmux-mcp.enable = cfg.mcp.tmux-mcp.enable;
        };

        skills = {
          conventional-commits.enable = cfg.skills.conventional-commits.enable;
          skill-creator.enable = cfg.skills.skill-creator.enable;
          skill-reviewer.enable = cfg.skills.skill-reviewer.enable;
          writing-skills.enable = cfg.skills.writing-skills.enable;
          dev-browser.enable = cfg.skills.dev-browser.enable;
          jj.enable = cfg.skills.jj.enable;
          timewarrior.enable = cfg.skills.timewarrior.enable;
          tmux.enable = cfg.skills.tmux.enable;
          buku.enable = cfg.skills.buku.enable;
        };
      };
    };
  };
}
