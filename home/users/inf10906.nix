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
      k8s.enable = true;
      networking.enable = true;
      vault.enable = true;
    };

    ai = {
      tools = {
        enable = true;
        claude.enable = false;
        ollama.enable = false;
        llamacpp.enable = false;
        opencode = {
          enable = true;
          daemon.enable = false;
        };
        github-copilot-cli.enable = true;
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
        };
        skills = {
          dev-browser.enable = false;
        };
      };
    };

    desktop = {
      darwin.enable = true;
      browsers.enable = true;
    };
  };

  modules.desktop.browsers.firefox = {
    enablePolicies = lib.mkForce false;
  };

  modules.desktop.editors.nixvim = {
    ai = {
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
}
