{pkgs, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/home/vince";
    stateVersion = "24.11";
  };

  modules = {
    ai.agents.antigravity.enable = true;
    ai.agents.codex.enable = true;
    desktop.tools.thunar.enable = true;
    desktop.extensions.waybar.printer = {
      enable = true;
      name = "Brother-HL-3170CDW";
    };
    services.sqlite-backups = {
      enable = true;
      passagePrefix = "hosts/v/backups";
      repositoryPrefix = "s3:s3.ca-east-006.backblazeb2.com/kube-backups-v/backups";
    };
    services.google-drive = {
      enable = true;
      passage.enable = true;
    };
  };

  roles = {
    common.enable = true;
    vaults.enable = true;
    utils = {
      enable = true;
      tmux.shell = pkgs.nushell;
    };
    nixpkgs.enable = true;
    sync.enable = true;
    security.enable = true;
    multimedia.enable = true;

    dev = {
      languages.enable = true;
      datatools.enable = true;
      debugging.enable = true;
      profiling.enable = true;
    };

    ops = {
      aws.enable = true;
      container.enable = true;
      k8s.enable = true;
      networking.enable = true;
      bpf.enable = true;
    };

    ai = {
      tools = {
        enable = true;
        mcp = {
          grafana.grafanaUrl = "https://grafana.kube-stack.org";
          memory-service.enable = true;
          nixos.enable = false; # Disabled due to fastmcp/mcp version mismatch
        };
        pi = {
          settings.theme = "tokyo-night-storm";
        };
      };
    };

    desktop = {
      wallpapers.enable = true;
      browsers.enable = true;
      security.enable = true;
      extensions.enable = true;
      hyprland.enable = true;
      niri.enable = true;
      gaming.enable = true;
      productivity.enable = true;
      wifi.enable = true;
      messaging.enable = true;
      tools.enable = true;
      media.enable = true;
    };
  };
}
