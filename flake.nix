{
  description = "VinceD's dotfiles flake";

  inputs = {
    # Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";

    # System
    darwin.url = "github:LnL7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Others
    utils.url = "github:numtide/flake-utils";
    tmux.url = "github:tmux/tmux";
    tmux.flake = false;
    efm-langserver.url = "github:mattn/efm-langserver";
    efm-langserver.flake = false;
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    # lua-format.url = "github.com:Koihik/LuaFormatter";
    # lua-format.flake = false;
    # TODO: does not work yet
    # lua-format.submodules = true;
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , neovim-nightly
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
        overlayFiles // {
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
        };
    in
    {
      darwinConfigurations.bootstrap = darwin.lib.darwinSystem {
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
        inherit inputs;
        modules = [
          ./modules/darwin/default.nix
          ./modules/darwin/systems/C02XX09DJHD2.nix
          { users.knownUsers = [ "vdesjardins" ]; }
          home-manager.darwinModule
          { nixpkgs = pkgsConfig; }
          ./home/users/vdesjardins.nix
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
