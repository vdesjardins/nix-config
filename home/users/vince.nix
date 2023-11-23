{wm ? null}: {lib, ...}: {
  imports =
    [
      ./common.nix

      ../programs/alacritty
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
      ../roles/dev/jq
      ../roles/dev/lua
      ../roles/dev/make
      ../roles/dev/markdown
      ../roles/dev/nix
      ../roles/dev/python
      ../roles/dev/regex
      ../roles/dev/rust
      ../roles/dev/terraform
      ../roles/dev/yaml
      ../roles/dev/zig
      ../roles/ops/aws
      ../roles/ops/container
      ../roles/ops/k8s
      ../roles/ops/networking
      ../roles/ops/virtualization
      ../roles/security
      ../roles/utils
      ../services/yubikey-agent
    ]
    ++ lib.optionals (wm == "i3") [
      ../services/window-manager
      ../programs/firefox
    ];
}
