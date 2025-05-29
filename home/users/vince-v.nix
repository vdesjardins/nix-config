{lib, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/home/vince";
    stateVersion = "24.11";
  };

  roles.common.enable = true;
  roles.vaults.enable = true;
  roles.utils.enable = true;
  roles.nixpkgs.enable = true;
  roles.sync.enable = true;
  roles.ai.enable = true;
  roles.security.enable = true;
  roles.multimedia.enable = true;

  roles.dev.bash.enable = true;
  roles.dev.cue.enable = true;
  roles.dev.kcl.enable = true;
  roles.dev.debugging.enable = true;
  roles.dev.go.enable = true;
  roles.dev.js.enable = true;
  roles.dev.json.enable = true;
  roles.dev.lua.enable = true;
  roles.dev.make.enable = true;
  roles.dev.markdown.enable = true;
  roles.dev.nix.enable = true;
  roles.dev.python.enable = true;
  roles.dev.regex.enable = true;
  roles.dev.rust.enable = true;
  roles.dev.terraform.enable = true;
  roles.dev.vimscript.enable = true;
  roles.dev.yaml.enable = true;
  roles.dev.zig.enable = true;
  roles.ops.aws.enable = true;
  roles.ops.container.enable = true;
  roles.ops.k8s.enable = true;
  roles.ops.networking.enable = true;
  roles.ops.bpf.enable = true;

  roles.desktop.wallpapers.enable = true;
  roles.desktop.browsers.enable = true;
  roles.desktop.viewers.enable = true;
  roles.desktop.security.enable = true;
  roles.desktop.sway.enable = true;
  roles.desktop.gaming.enable = true;
  roles.desktop.productivity.enable = true;
  roles.desktop.ai.enable = true;
  roles.desktop.wifi.enable = true;
  roles.desktop.diagnostic.enable = true;
  roles.desktop.graphics.enable = true;
  roles.desktop.videos.enable = true;
  roles.desktop.messaging.enable = true;
}
