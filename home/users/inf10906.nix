{lib, ...}: {
  home = {
    username = "inf10906";
    homeDirectory = "/Users/inf10906";
    stateVersion = "23.11";
  };

  imports = [
    ../roles/common.nix
    ../roles/darwin.nix

    ../roles/desktop/darwin.nix
    ../roles/security.nix
    ../roles/dev/bash.nix
    ../roles/dev/kcl.nix
    ../roles/dev/go.nix
    ../roles/dev/go-template.nix
    ../roles/dev/js.nix
    ../roles/dev/json.nix
    ../roles/dev/lua.nix
    ../roles/dev/make.nix
    ../roles/dev/markdown.nix
    ../roles/dev/nix.nix
    ../roles/dev/python.nix
    ../roles/dev/regex.nix
    ../roles/dev/rego.nix
    ../roles/dev/rust.nix
    ../roles/dev/terraform.nix
    ../roles/dev/make.nix
    ../roles/dev/vimscript.nix
    ../roles/dev/yaml.nix
    ../roles/ops/aws.nix
    ../roles/ops/gcloud.nix
    ../roles/ops/container.nix
    ../roles/ops/k8s.nix
    ../roles/ops/networking.nix
    ../roles/ops/vault.nix
    ../roles/security.nix
    ../roles/nixpkgs.nix
    ../roles/utils.nix

    ../roles/desktop/browsers.nix
    ../roles/ai.nix
  ];
}
