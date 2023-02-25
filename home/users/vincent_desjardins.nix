{...}: {
  home.sessionVariables = {
    VAULT_USERNAME = "inf10906";
    VAULT_ADDR = "https://vault.gcp.internal";
  };

  xdg.enable = true;

  imports = [
    ./common.nix

    ../programs/vault
    ../roles/dev/bash
    ../roles/dev/cpp
    ../roles/dev/cue
    ../roles/dev/debugging
    ../roles/dev/go
    ../roles/dev/json
    ../roles/dev/lua
    ../roles/dev/make
    ../roles/dev/nix
    ../roles/dev/rust
    ../roles/dev/rust
    ../roles/dev/terraform
    ../roles/dev/vimscript
    ../roles/dev/yaml
    ../roles/ops/aws
    ../roles/ops/container
    ../roles/ops/gcloud
    ../roles/ops/k8s
    ../roles/ops/networking
    ../roles/utils
  ];
}
