{
  description = "VinceD dotfiles flake";

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
    vde-neovim.url = "github:vdesjardins/neovim";
    vde-neovim.inputs.nixpkgs.follows = "nixpkgs";
    tmux.url = "github:tmux/tmux";
    tmux.flake = false;
  };

  outputs =
    { self
    , nixpkgs
    , unstable
    , nur
    , home-manager
    , darwin
    , vde-neovim
    , ...
    }@inputs:
      let
        inherit (builtins) listToAttrs attrValues attrNames readDir;
        inherit (nixpkgs) lib;
        inherit (lib) removeSuffix;

        supportedSystems = nixpkgs.lib.platforms.unix;
        forAllSystems = f:
          nixpkgs.lib.genAttrs supportedSystems (system: f system);

        pkgs = {
          overlays = (attrValues overlays);
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };

        overlays = let
          overlayFiles = listToAttrs (
            map (
              name: {
                name = removeSuffix ".nix" name;
                value = import (./overlays + "/${name}") inputs;
              }
            ) (attrNames (readDir ./overlays))
          );
        in
          overlayFiles // {
            nur = final: prev: {
              nur = import inputs.nur {
                nurpkgs = final.unstable;
                pkgs = final.unstable;
              };
            };
            unstable = final: prev: {
              unstable = import inputs.unstable {
                system = final.system;
                config = { allowUnfree = true; };
              };
            };
            master = final: prev: {
              master = import inputs.master {
                system = final.system;
                config = { allowUnfree = true; };
              };
            };
          } // vde-neovim.overlays;
      in
        {
          homeConfigurations.vincent_desjardins =
            home-manager.lib.homeManagerConfiguration {
              system = "x86_64-linux";
              stateVersion = "21.05";
              username = "vincent_desjardins";
              homeDirectory = "/home/vincent_desjardins";
              extraModules = [ inputs.vde-neovim.hmModule ];
              configuration = import ./home/users/vincent_desjardins.nix { inherit pkgs; };
            };
          vincent_desjardins = self.homeConfigurations.vincent_desjardins.activationPackage;

          darwinConfigurations.bootstrap = darwin.lib.darwinSystem {
            inputs = inputs;
            modules = [ ./modules/darwin/bootstrap.nix ];
          };

          darwinConfigurations.work-mac = darwin.lib.darwinSystem {
            inherit inputs;
            modules = [
              ./darwin/modules/default.nix
              ./darwin/systems/C02XX09DJHD2.nix
              home-manager.darwinModule
              { nixpkgs = pkgs; }
              ./home/users/vdesjardins.nix
            ];
          };
          work-mac = self.darwinConfigurations.work-mac.system;

          overlays = overlays;
        };
}
