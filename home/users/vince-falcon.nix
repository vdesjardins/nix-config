{lib, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/home/vince";
    stateVersion = "23.11";
  };

  roles = {
    common.enable = true;
    security.enable = true;
    vaults.enable = true;
    utils.enable = true;
    nixpkgs.enable = true;
    sync.enable = true;
    multimedia.enable = true;

    dev = {
      languages.enable = true;
      datatools.enable = true;
      debugging.enable = true;
    };

    ops = {
      aws.enable = true;
      container.enable = true;
      k8s.enable = true;
      networking.enable = true;
      bpf.enable = true;
    };

    desktop = {
      wallpapers.enable = true;
      browsers.enable = true;
      security.enable = true;
      extensions.enable = true;
      sway.enable = true;
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
