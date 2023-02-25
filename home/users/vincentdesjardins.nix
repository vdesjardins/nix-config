{xsession ? false}: {lib, ...}: {
  imports =
    [
      ./common.nix

      ../programs/alacritty
      ../programs/hammerspoon
      ../programs/ssh
      ../programs/wezterm
      ../roles/dev/common
      ../roles/dev/bash
      ../roles/dev/debugging
      ../roles/dev/go
      ../roles/dev/js
      ../roles/dev/json
      ../roles/dev/lua
      ../roles/dev/nix
      ../roles/dev/python
      ../roles/dev/rust
      ../roles/dev/terraform
      ../roles/dev/yaml
      ../roles/ops/aws
      ../roles/ops/container
      ../roles/ops/k8s
      ../roles/ops/networking
      ../roles/ops/virtualization
      ../roles/utils
      ../services/gpg-agent
    ]
    ++ lib.optionals xsession [
      ../services/window-manager
    ];
}
