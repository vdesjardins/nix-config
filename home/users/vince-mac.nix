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
      bash.enable = true;
      cue.enable = true;
      debugging.enable = true;
      go.enable = true;
      go-template.enable = true;
      js.enable = true;
      json.enable = true;
      jq.enable = true;
      lua.enable = true;
      make.enable = true;
      markdown.enable = true;
      nix.enable = true;
      python.enable = true;
      regex.enable = true;
      rust.enable = true;
      terraform.enable = true;
      vimscript.enable = true;
      yaml.enable = true;
      zig.enable = true;
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
