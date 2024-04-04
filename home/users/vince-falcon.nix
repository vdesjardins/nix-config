{lib, ...}: {
  home = {
    username = "vince";
    homeDirectory = "/home/vince";
    stateVersion = "23.11";
  };

  imports = [
    ../roles/common.nix

    ../roles/desktop/darwin.nix
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
    ../roles/ops/bpf.nix
    ../roles/security.nix
    ../roles/vaults.nix
    ../roles/utils.nix
    ../roles/nixpkgs.nix
    ../roles/sync.nix

    ../roles/multimedia.nix
    ../roles/desktop/wallpapers.nix
    ../roles/desktop/browsers.nix
    ../roles/desktop/viewers.nix
    ../roles/desktop/security.nix
    ../roles/desktop/sway.nix
    ../roles/desktop/gaming.nix
    ../roles/desktop/productivity.nix
    ../roles/desktop/ai.nix
    ../roles/desktop/wifi.nix
  ];
}
