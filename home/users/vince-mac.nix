{lib, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/Users/vince";
    stateVersion = "23.11";
  };

  roles = {
    common.enable = true;
    darwin.enable = true;
    security.enable = true;
    vaults.enable = true;
    utils.enable = true;
    nixpkgs.enable = true;
    sync.enable = true;

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
      virtualization.enable = true;
    };

    desktop = {
      browsers.enable = true;
      darwin.enable = true;
    };
  };
}
