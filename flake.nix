{
  description = "VinceD's dotfiles flake";

  inputs = {
    # Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";

    # System
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    # hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Others
    nur.url = "github:nix-community/NUR";
    utils.url = "github:numtide/flake-utils";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    tmux-tokyo-night.url = "github:/fabioluciano/tmux-tokyo-night";
    tmux-tokyo-night.flake = false;

    ghostty.url = "github:ghostty-org/ghostty";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # languages
    rust-overlay.url = "github:oxalica/rust-overlay";

    # neovim plugins
    blink-cmp.url = "github:Saghen/blink.cmp";
    mcp-hub.url = "github:ravitemer/mcp-hub";
    mcp-hub-nvim.url = "github:ravitemer/mcphub.nvim";
  };

  outputs = {
    deploy-rs,
    blink-cmp,
    ghostty,
    mcp-hub,
    mcp-hub-nvim,
    neovim-nightly,
    nix,
    nixpkgs,
    nur,
    pre-commit-hooks,
    rust-overlay,
    self,
    utils,
    ...
  } @ inputs: let
    inherit (lib.attrsets) genAttrs listToAttrs attrValues;
    inherit (builtins) readDir;
    inherit (lib.strings) removeSuffix;
    inherit (utils.lib.system) aarch64-darwin x86_64-linux aarch64-linux;

    linux64BitSystems = [
      x86_64-linux
      aarch64-linux
    ];

    forAllSupportedSystems = genAttrs supportedSystems.all;

    pkgsConfig = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      allowBroken = true;
      # contentAddressedByDefault = true;

      permittedInsecurePackages = [
      ];
    };

    mkOverlays = path: self.lib.mapModulesRecursive path (o: import o inputs);
    mkOverlays' = path: attrValues (mkOverlays path);
    mkChildOverlays = name: final: _prev: {
      ${name} = import inputs.${name} {
        inherit (final) system;
        config = pkgsConfig;
        overlays = mkOverlays' ./overlays/${name};
      };
    };

    myPackages = pkgs:
      self.lib.mapModulesRecursive ./packages (o: pkgs.callPackage o {});

    mkPackagesOverlay = final: prev:
      lib.attrsets.mapAttrs' (
        name: value:
          lib.attrsets.nameValuePair (removeSuffix ".nix" name) (prev.callPackage ./packages/${name} {})
      ) (readDir ./packages);

    myOverlays =
      {
        master = mkChildOverlays "master";
        myPkgs = mkPackagesOverlay;
      }
      // (mkOverlays ./overlays/nixpkgs);

    extraOverlays = {
      nur = nur.overlays.default;
      neovim-nightly = neovim-nightly.overlays.default;
      rust-overlay = rust-overlay.overlays.default;
      ghostty = final: prev: {ghostty = ghostty.packages.${prev.system}.default;};
      blink-cmp = final: prev: {vimPlugins = prev.vimPlugins // {blink-cmp = blink-cmp.packages.${prev.system}.default;};};
      mcp-hub = final: prev: {mcp-hub = mcp-hub.packages.${prev.system}.default;};
      mcp-hub-nvim = final: prev: {mcp-hub-nvim = mcp-hub-nvim.packages.${prev.system}.default;};
    };

    supportedSystems = rec {
      darwin = [aarch64-darwin];
      linux = [x86_64-linux aarch64-linux];
      all = darwin ++ linux;
    };

    mkPkgs = pkgs: extraOverlays: system:
      import pkgs {
        inherit system;
        overlays = extraOverlays ++ (attrValues myOverlays);
        config = pkgsConfig;
      };

    pkgs = genAttrs supportedSystems.all (mkPkgs nixpkgs (attrValues extraOverlays));

    lib = inputs.nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit pkgs inputs;
        lib = final;
      };
    });
  in {
    lib = lib.my;

    darwinConfigurations = import ./hosts/systems/darwin.nix {inherit lib;};

    nixosConfigurations = import ./hosts/systems/linux.nix {inherit lib;};

    homeConfigurations = import ./home/config {inherit lib;};

    hmModules = self.lib.mapModulesRecursive ./home/modules import;

    deploy = import ./hosts/deploy {inherit lib deploy-rs self;};

    inherit pkgs;
    packages =
      listToAttrs
      (builtins.map
        (system: {
          name = system;
          value = {
            "dockerImage/vm-builder" = import ./hosts/modules/linux/containers/vm-builder.nix {
              inherit nixpkgs nix system;
              crossSystem = system;
            };
          };
        })
        linux64BitSystems)
      // {
        aarch64-darwin."dockerImage/vm-builder" = import ./hosts/modules/linux/containers/vm-builder.nix {
          inherit nixpkgs nix;
          system = utils.lib.system.aarch64-darwin;
          crossSystem = utils.lib.system.aarch64-linux;
        };
      }
      // forAllSupportedSystems (system: myPackages pkgs.${system});

    overlays = {
      default = mkPackagesOverlay;
      nixpkgs = mkOverlays ./overlays/nixpkgs;
    };

    devShells = forAllSupportedSystems (system: {
      default = pkgs.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });

    checks = forAllSupportedSystems (
      system: {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            stylua.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            commitizen.enable = true;
          };
        };
      }
      # FIXME: doesn't work when deploying from different architecture https://github.com/serokell/deploy-rs/issues/167
      #// deploy-rs.lib.${system}.deployChecks self.deploy);
    );
  };
}
