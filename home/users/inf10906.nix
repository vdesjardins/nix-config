{lib, ...}: {
  home = {
    username = "inf10906";
    homeDirectory = "/Users/inf10906";
    stateVersion = "23.11";
  };

  roles = {
    common.enable = true;
    darwin.enable = true;
    security.enable = true;
    nixpkgs.enable = true;
    utils.enable = true;

    dev = {
      languages.enable = true;
      datatools.enable = true;
    };

    ops = {
      aws.enable = true;
      gcloud.enable = true;
      container.enable = true;
      k8s = {
        enable = true;
        localClusters = {
          kind.enable = true;
          minikube.enable = false;
          k3d.enable = false;
        };
        developmentTools.enable = false;
        extendedPlugins.enable = false;
      };
      networking.enable = true;
      vault.enable = true;
    };

    ai = {
      tools = {
        enable = true;
        claude.enable = false;
        ollama.enable = false;
        llamacpp.enable = false;
        ccusage.enable = false;
        opencode = {
          enable = true;
          daemon.enable = false;
        };
        github-copilot-cli.enable = true;
        kiro.enable = false;
        beads-viewer.enable = false;
        coding-agent-search.enable = false;
        handy.enable = false;
        sandbox-runtime.enable = false;
        graphify.enable = false;
        parallel.enable = false;
        mcp = {
          nixos.enable = false;
          context7.enable = true;
          git.enable = true;
          github.enable = true;
          grafana.enable = false;
          tree-sitter.enable = false;
          sequential-thinking.enable = true;
          kubernetes.enable = true;
          playwright.enable = false;
          memory-service.enable = false;
          mcporter.enable = false;
          tmux-mcp.enable = false;
        };
        skills = {
          agent-browser.enable = false;
        };
      };
    };

    desktop = {
      darwin.enable = true;
      browsers.enable = true;
    };
  };

  modules = {
    shell.tools.yazi.enable = lib.mkForce false;

    desktop = {
      browsers.firefox.enablePolicies = lib.mkForce false;

      editors.nixvim.ai = {
        chat = {
          adapter = {
            name = "copilot";
            model = "gemini-2.5-pro";
          };
        };
        agent = {
          adapter = {
            name = "copilot";
            model = "gemini-2.5-pro";
          };
        };
        inline = {
          adapter = {
            name = "copilot";
            model = "gemini-2.5-pro";
          };
        };
      };
    };
  };
}
