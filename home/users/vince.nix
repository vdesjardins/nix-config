inputs: {
  system = "x86_64-linux";
  username = "vince";
  homeDirectory = "/home/vince";

  xdg.enable = true;

  extraModules = [ inputs.vde-neovim.hmModule ];

  configuration =
    { pkgs, ... }: {

      imports = [
        ./default.nix

        ../role/utils
        ../role/dev/yaml
        ../role/dev/json
        ../role/dev/cpp
        ../role/dev/nix
        ../role/dev/bash
        ../role/dev/golang
        ../role/dev/rust
        ../role/ops/docker
        ../role/ops/gcloud
        ../role/ops/k8s
        ../role/ops/bpf
      ];
}
