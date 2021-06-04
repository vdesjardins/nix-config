{
  description = "VinceD dotfiles flake";


  inputs =
    {
      # Packages
      nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
      nixpkgs.url = "nixpkgs";

      # System
      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      # Others
      utils.url = "github:numtide/flake-utils";
      vde-neovim.url = "github:vdesjardins/neovim";
      vde-neovim.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }@inputs:
    let
      inherit (nixpkgs-unstable.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (darwin.lib) darwinSystem;

      supportedSystems = nixpkgs.lib.platforms.unix;
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
      {
        homeConfigurations.vinced = homeManagerConfiguration (
          import
            ./systems/vinced.nix inputs
        );
        vinced = self.homeConfigurations.vinced.activationPackage;

        darwinConfigurations.work-mac = darwinSystem (
          import
            ./systems/work-mac.nix inputs
        );
        work-mac = self.darwinConfigurations.work-mac.config.system.build.toplevel;
      };
}
