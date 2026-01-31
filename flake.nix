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

    # hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Others
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    utils.url = "github:numtide/flake-utils";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    tmux-tokyo-night.url = "github:/fabioluciano/tmux-tokyo-night";
    tmux-tokyo-night.flake = false;

    ghostty.url = "github:ghostty-org/ghostty";
    ghostty.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    try.url = "github:tobi/try";
    try.inputs.nixpkgs.follows = "nixpkgs";

    opencode.url = "github:sst/opencode";
    opencode.inputs.nixpkgs.follows = "nixpkgs";

    llamacpp.url = "github:ggml-org/llama.cpp";
    llamacpp.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";

    # languages
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # neovim plugins
    blink-cmp.url = "github:Saghen/blink.cmp";
    blink-cmp.inputs.nixpkgs.follows = "nixpkgs";
    mcp-hub.url = "github:ravitemer/mcp-hub";
    mcp-hub-nvim.url = "github:ravitemer/mcphub.nvim";
  };

  outputs = {
    nix,
    nixpkgs,
    pre-commit-hooks,
    self,
    utils,
    ...
  } @ inputs: let
    inherit (lib.attrsets) genAttrs;
    inherit (utils.lib.system) aarch64-darwin x86_64-linux aarch64-linux;

    linux64BitSystems = [
      x86_64-linux
      aarch64-linux
    ];

    forAllSupportedSystems = genAttrs supportedSystems.allSystems;

    pkgsConfig = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      allowBroken = true;
      # contentAddressedByDefault = true;

      permittedInsecurePackages = [
      ];
    };

    mkOverlays = p: self.lib.mapModulesRecursive p (o: import o inputs);
    mkOverlays' = p: lib.attrsets.attrValues (mkOverlays p);
    mkChildOverlays = name: final: _prev: {
      ${name} = import inputs.${name} {
        inherit (final) system;
        config = pkgsConfig;
        overlays = mkOverlays' ./overlays/${name};
      };
    };

    myPackages = pkgs:
      lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ././packages;
      };

    myOverlays =
      {
        master = mkChildOverlays "master";
      }
      // (mkOverlays ./overlays/nixpkgs);

    supportedSystems = rec {
      darwin = [aarch64-darwin];
      linux = [x86_64-linux aarch64-linux];
      allSystems = darwin ++ linux;
    };

    mkPkgs = pkgs: system:
      import pkgs {
        inherit system;
        overlays = lib.attrsets.attrValues myOverlays;
        config = pkgsConfig;
      };

    pkgs = genAttrs supportedSystems.allSystems (mkPkgs nixpkgs);

    lib = inputs.nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit pkgs inputs;
        inherit (pkgs) system;
        lib = final;
        my-packages = self.packages;
      };
    });
  in {
    lib = lib.my;

    darwinConfigurations = import ./hosts/systems/darwin.nix {inherit lib;};

    nixosConfigurations = import ./hosts/systems/linux.nix {inherit lib;};

    homeConfigurations = import ./home/config {
      inherit lib;
    };

    homeModules = {
      default = {
        imports = self.lib.mapModulesRecursive' ./home/modules (f: f);
      };
      inherit (inputs.nixvim.homeModules) nixvim;
    };

    packages =
      builtins.foldl'
      (acc: value: (nixpkgs.lib.recursiveUpdate acc value)) {} [
        (forAllSupportedSystems (
          system:
            (myPackages pkgs.${system})
            // (lib.optionalAttrs (builtins.elem system linux64BitSystems) {
              vmBuilderImage = import ./hosts/modules/linux/containers/vm-builder.nix {
                inherit nixpkgs nix system;
                crossSystem = system;
              };
            })
        ))
      ];

    devShells = forAllSupportedSystems (system: {
      default = pkgs.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });

    checks = forAllSupportedSystems (
      system: let
        # Use only custom packages from ./packages directory
        customPackages = myPackages pkgs.${system};

        # Filter packages that have passthru.tests
        packagesWithTests =
          lib.filterAttrs
          (name: pkg: pkg ? passthru.tests)
          customPackages;

        # Build a flat set of test checks
        testsAttrs =
          lib.concatMapAttrs
          (
            pkgName: pkg:
              lib.mapAttrs'
              (testName: testDrv: lib.nameValuePair "packages-${pkgName}-${testName}" testDrv)
              pkg.passthru.tests
          )
          packagesWithTests;
      in
        {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              actionlint.enable = true;
              alejandra.enable = true;
              editorconfig-checker.enable = true;
              eslint.enable = true;
              prettier.enable = true;
              statix.enable = true;
              stylua.enable = true;
              shellcheck.enable = true;
              shfmt.enable = true;
              commitizen.enable = true;
              rumdl.enable = true;
            };
            package = pkgs.${system}.prek;
          };
        }
        // testsAttrs
    );
  };
}
