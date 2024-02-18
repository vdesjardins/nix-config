{lib, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/home/vince";
    stateVersion = "23.11";
  };

  imports = [
    ../roles/common.nix

    ../roles/win/darwin.nix
    ../roles/dev/bash.nix
    ../roles/dev/cue.nix
    ../roles/dev/debugging.nix
    ../roles/dev/go.nix
    ../roles/dev/go-template.nix
    ../roles/dev/js.nix
    ../roles/dev/json.nix
    ../roles/dev/jq.nix
    ../roles/dev/lua.nix
    ../roles/dev/make.nix
    ../roles/dev/markdown.nix
    ../roles/dev/nix.nix
    ../roles/dev/python.nix
    ../roles/dev/regex.nix
    ../roles/dev/rust.nix
    ../roles/dev/terraform.nix
    ../roles/dev/vimscript.nix
    ../roles/dev/yaml.nix
    ../roles/dev/zig.nix
    ../roles/ops/aws.nix
    ../roles/ops/container.nix
    ../roles/ops/k8s.nix
    ../roles/ops/networking.nix
    ../roles/ops/virtualization.nix
    ../roles/security.nix
    ../roles/utils.nix
    ../roles/nixpkgs.nix
    ../roles/sync.nix
    ../roles/win/browsers.nix

    ../roles/multimedia.nix
    ../roles/win/viewers.nix
    ../roles/win/status.nix
    ../roles/win/security.nix
    ../roles/win/sway.nix
  ];
}
