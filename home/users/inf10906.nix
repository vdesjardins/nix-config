{...}: {lib, ...}: {
  imports = [
    ./common.nix

    ../programs/vault
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
    ../roles/dev/rego
    ../roles/dev/rust
    ../roles/dev/terraform
    ../roles/dev/make
    ../roles/dev/yaml
    ../roles/ops/aws
    ../roles/ops/gcloud
    ../roles/ops/container
    ../roles/ops/k8s
    ../roles/ops/networking
    ../roles/ops/virtualization
    ../roles/utils
    ../services/yubikey-agent
  ];
}
