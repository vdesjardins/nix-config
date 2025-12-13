{...}: {
  home = {
    username = "vince";
    homeDirectory = "/home/vince";
    stateVersion = "24.11";
  };

  roles = {
    common.enable = true;
    vaults.enable = true;
    utils.enable = true;
    nixpkgs.enable = true;
    sync.enable = true;
    security.enable = true;
    multimedia.enable = true;

    dev = {
      bash.enable = true;
      cue.enable = true;
      kcl.enable = true;
      debugging.enable = true;
      go.enable = true;
      js.enable = true;
      json.enable = true;
      lua.enable = true;
      make.enable = true;
      markdown.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.enable = true;
      terraform.enable = true;
      yaml.enable = true;
      zig.enable = true;
    };

    ops = {
      aws.enable = true;
      container.enable = true;
      k8s.enable = true;
      networking.enable = true;
      bpf.enable = true;
    };

    ai = {
      ollama.enable = true;
      llamacpp.enable = true;
      gemini-cli.enable = true;
      opencode.enable = true;
      claude.enable = true;
      codex.enable = true;
      github-copilot-cli.enable = true;
      mcp = {
        context7.enable = true;
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
      wallpapers.enable = true;
      browsers.enable = true;
      viewers.enable = true;
      security.enable = true;
      extensions.enable = true;
      hyprland.enable = true;
      gaming.enable = true;
      productivity.enable = true;
      wifi.enable = true;
      diagnostic.enable = true;
      graphics.enable = true;
      videos.enable = true;
      messaging.enable = true;
    };
  };
}
