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
      bash.enable = true;
      cue.enable = true;
      kcl.enable = true;
      debugging.enable = true;
      go.enable = true;
      go-template.enable = true;
      js.enable = true;
      json.enable = true;
      jq.enable = true;
      lua.enable = true;
      make.enable = true;
      markdown.enable = true;
      enable = true;
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
      bpf.enable = true;
    };

    desktop = {
      wallpapers.enable = true;
      browsers.enable = true;
      viewers.enable = true;
      security.enable = true;
      extensions.enable = true;
      sway.enable = true;
      hyprland.enable = true;
      gaming.enable = true;
      productivity.enable = true;
      ai.enable = true;
      wifi.enable = true;
      diagnostic.enable = true;
      graphics.enable = true;
      videos.enable = true;
      messaging.enable = true;
    };
  };
}
