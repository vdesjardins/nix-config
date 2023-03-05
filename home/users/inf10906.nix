{...}: {lib, ...}: {
  imports = [
    ./common.nix

    ../programs/hammerspoon
    ../programs/ssh
    ../programs/wezterm
    ../programs/gpg
    ../roles/dev/bash
    ../roles/dev/cue
    ../roles/dev/debugging
    ../roles/dev/go
    ../roles/dev/go-template
    ../roles/dev/js
    ../roles/dev/json
    ../roles/dev/lua
    ../roles/dev/make
    ../roles/dev/markdown
    ../roles/dev/nix
    ../roles/dev/python
    ../roles/dev/rust
    ../roles/dev/terraform
    ../roles/dev/yaml
    ../roles/dev/zig
    ../roles/ops/aws
    ../roles/ops/container
    ../roles/ops/k8s
    ../roles/ops/networking
    ../roles/ops/virtualization
    ../roles/utils
    ../services/gpg-agent
  ];
}
