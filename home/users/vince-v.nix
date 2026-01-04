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
        mcp.grafana.grafanaUrl = "https://grafana.kube-stack.org";
        mcp.nixos.enable = false; # Disabled due to fastmcp/mcp version mismatch
      };
    };

    desktop = {
      wallpapers.enable = true;
      browsers.enable = true;
      security.enable = true;
      extensions.enable = true;
      hyprland.enable = true;
      gaming.enable = true;
      productivity.enable = true;
      wifi.enable = true;
      messaging.enable = true;
      tools.enable = true;
      media.enable = true;
    };
  };
}
