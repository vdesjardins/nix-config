{...}: {
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
      bash.enable = true;
      go.enable = true;
      json.enable = true;
      lua.enable = true;
      make.enable = true;
      markdown.enable = true;
      nix.enable = true;
      python.enable = true;
      rego.enable = true;
      rust.enable = true;
      terraform.enable = true;
      yaml.enable = true;
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
      llamacpp.enable = true;
      opencode.enable = true;
      codex.enable = true;
      github-copilot-cli.enable = true;
      mcp = {
        context7.enable = true;
        desktop-commander.enable = true;
        fetch.enable = true;
        fluxcd.enable = true;
        nixos.enable = true;
        git.enable = true;
        github.enable = true;
        sequential-thinking.enable = true;
        kubernetes.enable = true;
        universal-skills.enable = true;
        playright.enable = true;
      };
    };

    desktop = {
      darwin.enable = true;
      browsers.enable = true;
    };
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
