{
  description = "VinceD's dotfiles flake";

  inputs = {
    # Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    fenix.url = "github:/nix-community/fenix";

    # System
    darwin.url = "github:LnL7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Others
    utils.url = "github:numtide/flake-utils";
    comma.url = "github:Shopify/comma";
    comma.flake = false;
    tmux.url = "github:tmux/tmux";
    tmux.flake = false;
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    lscolors.url = "github:/trapd00r/LS_COLORS";
    lscolors.flake = false;
    base16-fzf.url = "github:/fnune/base16-fzf";
    base16-fzf.flake = false;
    aws-find-profile.url = "github:/vdesjardins/aws-find-profile";
    aws-find-profile.flake = false;
    kubectl-view-utilization.url = "github:/etopeter/kubectl-view-utilization";
    kubectl-view-utilization.flake = false;
    kubectl-sniff.url = "github:/eldadru/ksniff";
    kubectl-sniff.flake = false;
    kubectl-trace.url = "github:/iovisor/kubectl-trace/v0.1.2";
    kubectl-trace.flake = false;
    kubectl-aliases.url = "github:/ahmetb/kubectl-aliases";
    kubectl-aliases.flake = false;
    kube-no-trouble.url = "github:/doitintl/kube-no-trouble";
    kube-no-trouble.flake = false;
    # TODO: does not work yet, submodule fetching should be supported after 2.4
    # is released
    # lua-format.url = "github:/Koihik/LuaFormatter";
    # lua-format.flake = false;
    # lua-format.submodules = true;
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , neovim-nightly
    , fenix
    , utils
    , ...
    }@inputs:
    let
      inherit (builtins) listToAttrs attrValues attrNames readDir;
      inherit (nixpkgs) lib;
      inherit (lib) removeSuffix;

      pkgsConfig = {
        overlays = (attrValues overlays);
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
      };

      overlays =
        let
          overlayFiles = listToAttrs (
            map
              (
                name: {
                  name = removeSuffix ".nix" name;
                  value = import (./overlays + "/${name}") inputs;
                }
              )
              (attrNames (readDir ./overlays))
          );
        in
        {
          nur = final: _prev: {
            nur = import inputs.nur {
              nurpkgs = final.unstable;
              pkgs = final.unstable;
            };
          };
          unstable = final: _prev: {
            unstable = import inputs.unstable {
              system = final.system;
              config = { allowUnfree = true; };
            };
          };
          master = final: _prev: {
            master = import inputs.master {
              system = final.system;
              config = { allowUnfree = true; };
            };
          };
          neovim-nightly = neovim-nightly.overlay;
          comma = final: _prev: {
            comma = import inputs.comma { inherit (final) pkgs; };
          };
          fenix = fenix.overlay;
        } // overlayFiles;
    in
    {
      darwinConfigurations.bootstrap = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        inherit inputs;
        modules = [ ./modules/darwin/bootstrap.nix ];
      };

      homeConfigurations.vincent_desjardins =
        home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          stateVersion = "21.05";
          username = "vincent_desjardins";
          homeDirectory = "/home/vincent_desjardins";
          configuration = import ./home/users/vincent_desjardins.nix {
            pkgs = pkgsConfig;
          };
        };
      vincent_desjardins = self.homeConfigurations.vincent_desjardins.activationPackage;

      darwinConfigurations.work-mac = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        inherit inputs;
        modules = [
          ./modules/darwin/default.nix
          ./modules/darwin/systems/C02G32U9MD6T.nix
          { users.knownUsers = [ "inf10906" ]; }
          home-manager.darwinModule
          { nixpkgs = pkgsConfig; }
          ./home/users/inf10906.nix
        ];
      };
      work-mac = self.darwinConfigurations.work-mac.system;

      inherit overlays;
    } // utils.lib.eachDefaultSystem (
      system: {
        legacyPackages = import nixpkgs {
          inherit system; inherit
          (pkgsConfig) config overlays
          ;
        };
      }
    );
}
