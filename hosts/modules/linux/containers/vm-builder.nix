{
  nixpkgs,
  nix,
  system,
  crossSystem,
}: let
  pkgs = import nixpkgs {inherit system;};
  pkgsCross = import nixpkgs {system = crossSystem;};
in
  pkgs.dockerTools.buildImage {
    name = "nix-builder";
    tag = "latest";
    fromImage = nix.packages.${crossSystem}.dockerImage + "/image.tar.gz";
    copyToRoot = with pkgsCross;
      pkgs.buildEnv {
        name = "image-root";
        paths = [
          qemu-utils
          (pkgs.writeScriptBin
            "create-vm"
            ''
              #!${pkgsCross.runtimeShell}

              set -e

              mkdir -p ~/.config/nix
              echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
              echo 'system-features = nixos-test benchmark big-parallel kvm' >> ~/.config/nix/nix.conf
              echo 'trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=' >> ~/.config/nix/nix.conf

              nix build "$@"

              cp result/nixos-*-aarch64-linux.vmdk /output/
            '')
        ];
        pathsToLink = ["/bin"];
      };

    config = {
      # Cmd = [ "${pkgsCross.nix}/bin/nix" ];
      Cmd = ["/bin/create-vm"];
    };
  }
