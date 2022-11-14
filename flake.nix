{
  description = "VinceD's dotfiles flake";

  inputs = {
    # Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    fenix.url = "github:/nix-community/fenix";

    # System
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Others
    nix.url = "github:nixos/nix/2.8.0";
    utils.url = "github:numtide/flake-utils";
    comma.url = "github:Shopify/comma";
    comma.flake = false;
    tmux.url = "github:tmux/tmux";
    tmux.flake = false;
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    lscolors.url = "github:/trapd00r/LS_COLORS";
    lscolors.flake = false;
    base16-fzf.url = "github:/fnune/base16-fzf";
    base16-fzf.flake = false;
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    hammerspoon-controlescape.url = "github:/jasonrudolph/ControlEscape.spoon";
    hammerspoon-controlescape.flake = false;

    # aws
    aws-find-profile.url = "github:/vdesjardins/aws-find-profile";
    aws-find-profile.flake = false;
    aws-sso-util.url = "github:/vdesjardins/aws-sso-util";
    aws-sso-util.flake = false;

    # Kubebernetes
    kubectl-view-utilization.url = "github:/etopeter/kubectl-view-utilization";
    kubectl-view-utilization.flake = false;
    kubectl-sniff.url = "github:/eldadru/ksniff";
    kubectl-sniff.flake = false;
    kubectl-trace.url = "github:/iovisor/kubectl-trace";
    kubectl-trace.flake = false;
    kubectl-who-can.url = "github:aquasecurity/kubectl-who-can/v0.4.0";
    kubectl-who-can.flake = false;
    kubectl-aliases.url = "github:/ahmetb/kubectl-aliases";
    kubectl-aliases.flake = false;
    kube-no-trouble.url = "github:/doitintl/kube-no-trouble";
    kube-no-trouble.flake = false;
    kube-lineage.url = "github:/tohjustin/kube-lineage/v0.4.2";
    kube-lineage.flake = false;
    kubectl-blame.url = "github:/knight42/kubectl-blame/v0.0.8";
    kubectl-blame.flake = false;
    ketall.url = "github:corneliusweig/ketall";
    ketall.flake = false;

    # Neovim
    ## LSP
    neovim-plugin-nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    neovim-plugin-nvim-lspconfig.flake = false;
    neovim-plugin-lspsaga-nvim.url = "github:tami5/lspsaga.nvim";
    neovim-plugin-lspsaga-nvim.flake = false;
    neovim-plugin-lspkind-nvim.url = "github:onsails/lspkind-nvim";
    neovim-plugin-lspkind-nvim.flake = false;
    neovim-plugin-nvim-lightbulb.url = "github:kosayoda/nvim-lightbulb";
    neovim-plugin-nvim-lightbulb.flake = false;
    neovim-plugin-null-ls.url = "github:jose-elias-alvarez/null-ls.nvim";
    neovim-plugin-null-ls.flake = false;
    neovim-plugin-lsp-signature-nvim.url = "github:ray-x/lsp_signature.nvim";
    neovim-plugin-lsp-signature-nvim.flake = false;

    neovim-plugin-cmp-nvim-lsp.url = "github:hrsh7th/cmp-nvim-lsp";
    neovim-plugin-cmp-nvim-lsp.flake = false;
    neovim-plugin-cmp-buffer.url = "github:hrsh7th/cmp-buffer";
    neovim-plugin-cmp-buffer.flake = false;
    neovim-plugin-cmp-path.url = "github:hrsh7th/cmp-path";
    neovim-plugin-cmp-path.flake = false;
    neovim-plugin-cmp-cmdline.url = "github:hrsh7th/cmp-cmdline";
    neovim-plugin-cmp-cmdline.flake = false;
    neovim-plugin-nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    neovim-plugin-nvim-cmp.flake = false;
    neovim-plugin-cmp-nvim-ultisnips.url = "github:quangnguyen30192/cmp-nvim-ultisnips";
    neovim-plugin-cmp-nvim-ultisnips.flake = false;
    neovim-plugin-cmp-treesitter.url = "github:ray-x/cmp-treesitter";
    neovim-plugin-cmp-treesitter.flake = false;

    # ## Debugging
    neovim-plugin-nvim-dap.url = "github:mfussenegger/nvim-dap";
    neovim-plugin-nvim-dap.flake = false;
    neovim-plugin-nvim-dap-ui.url = "github:rcarriga/nvim-dap-ui";
    neovim-plugin-nvim-dap-ui.flake = false;
    neovim-plugin-telescope-dap.url = "github:nvim-telescope/telescope-dap.nvim";
    neovim-plugin-telescope-dap.flake = false;
    neovim-plugin-nvim-dap-go.url = "github:leoluz/nvim-dap-go";
    neovim-plugin-nvim-dap-go.flake = false;

    ## Treesitter
    neovim-plugin-nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter";
    neovim-plugin-nvim-treesitter.flake = false;
    neovim-plugin-nvim-treesitter-textobjects.url = "github:nvim-treesitter/nvim-treesitter-textobjects";
    neovim-plugin-nvim-treesitter-textobjects.flake = false;
    neovim-plugin-nvim-ts-rainbow.url = "github:p00f/nvim-ts-rainbow";
    neovim-plugin-nvim-ts-rainbow.flake = false;
    neovim-plugin-indent-blankline-nvim.url = "github:lukas-reineke/indent-blankline.nvim";
    neovim-plugin-indent-blankline-nvim.flake = false;
    neovim-plugin-playground.url = "github:nvim-treesitter/playground";
    neovim-plugin-playground.flake = false;
    neovim-plugin-nvim-ts-context-commentstring.url = "github:JoosepAlviste/nvim-ts-context-commentstring";
    neovim-plugin-nvim-ts-context-commentstring.flake = false;
    neovim-plugin-nvim-ts-autotag.url = "github:windwp/nvim-ts-autotag";
    neovim-plugin-nvim-ts-autotag.flake = false;

    ## status line
    neovim-plugin-lualine-nvim.url = "github:nvim-lualine/lualine.nvim";
    neovim-plugin-lualine-nvim.flake = false;

    ## git
    neovim-plugin-gitsigns-nvim.url = "github:lewis6991/gitsigns.nvim";
    neovim-plugin-gitsigns-nvim.flake = false;
    neovim-plugin-git-blame-nvim.url = "github:f-person/git-blame.nvim";
    neovim-plugin-git-blame-nvim.flake = false;
    neovim-plugin-vim-fugitive.url = "github:tpope/vim-fugitive";
    neovim-plugin-vim-fugitive.flake = false;
    neovim-plugin-vim-rhubarb.url = "github:tpope/vim-rhubarb";
    neovim-plugin-vim-rhubarb.flake = false;

    ## Tree
    neovim-plugin-nvim-neo-tree.url = "github:nvim-neo-tree/neo-tree.nvim";
    neovim-plugin-nvim-neo-tree.flake = false;

    neovim-plugin-telescope-nvim.url = "github:nvim-telescope/telescope.nvim";
    neovim-plugin-telescope-nvim.flake = false;
    neovim-plugin-telescope-ui-select.url = "github:nvim-telescope/telescope-ui-select.nvim";
    neovim-plugin-telescope-ui-select.flake = false;

    ## Misc
    neovim-plugin-neodev-nvim.url = "github:folke/neodev.nvim";
    neovim-plugin-neodev-nvim.flake = false;
    neovim-plugin-which-key-nvim.url = "github:folke/which-key.nvim";
    neovim-plugin-which-key-nvim.flake = false;
    neovim-plugin-trouble-nvim.url = "github:folke/lsp-trouble.nvim";
    neovim-plugin-trouble-nvim.flake = false;
    neovim-plugin-nvim-bqf.url = "github:kevinhwang91/nvim-bqf"; # preview in quickfix
    neovim-plugin-nvim-bqf.flake = false;
    neovim-plugin-lsp-rooter-nvim.url = "github:ahmedkhalf/lsp-rooter.nvim";
    neovim-plugin-lsp-rooter-nvim.flake = false;
    neovim-plugin-vim-commentary.url = "github:tpope/vim-commentary";
    neovim-plugin-vim-commentary.flake = false;
    neovim-plugin-vim-rsi.url = "github:tpope/vim-rsi"; # emacs style keybindings in edit/cmd
    neovim-plugin-vim-rsi.flake = false;
    neovim-plugin-vim-bookmarks.url = "github:MattesGroeger/vim-bookmarks";
    neovim-plugin-vim-bookmarks.flake = false;
    neovim-plugin-vim-tmux-navigator.url = "github:christoomey/vim-tmux-navigator";
    neovim-plugin-vim-tmux-navigator.flake = false;
    neovim-plugin-vim-startify.url = "github:mhinz/vim-startify";
    neovim-plugin-vim-startify.flake = false;
    neovim-plugin-vim-bbye.url = "github:moll/vim-bbye"; # close buffer
    neovim-plugin-vim-bbye.flake = false;
    neovim-plugin-nvim-neoclip-lua.url = "github:AckslD/nvim-neoclip.lua"; # Clipboard manager
    neovim-plugin-nvim-neoclip-lua.flake = false;
    neovim-plugin-planery.url = "github:nvim-lua/plenary.nvim";
    neovim-plugin-planery.flake = false;
    neovim-plugin-popup.url = "github:nvim-lua/popup.nvim";
    neovim-plugin-popup.flake = false;
    neovim-plugin-nvim-web-devicons.url = "github:kyazdani42/nvim-web-devicons";
    neovim-plugin-nvim-web-devicons.flake = false;
    neovim-plugin-nui.url = "github:MunifTanjim/nui.nvim";
    neovim-plugin-nui.flake = false;
    neovim-plugin-editorconfig.url = "github:gpanders/editorconfig.nvim";
    neovim-plugin-editorconfig.flake = false;

    ## text
    neovim-plugin-vim-better-whitespace.url = "github:ntpeters/vim-better-whitespace";
    neovim-plugin-vim-better-whitespace.flake = false;
    neovim-plugin-vim-endwise.url = "github:tpope/vim-endwise";
    neovim-plugin-vim-endwise.flake = false;
    neovim-plugin-auto-pairs.url = "github:jiangmiao/auto-pairs";
    neovim-plugin-auto-pairs.flake = false;
    neovim-plugin-vim-grepper.url = "github:mhinz/vim-grepper";
    neovim-plugin-vim-grepper.flake = false;
    neovim-plugin-vim-surround.url = "github:tpope/vim-surround";
    neovim-plugin-vim-surround.flake = false;
    neovim-plugin-leap-nvim.url = "github:ggandor/leap.nvim";
    neovim-plugin-leap-nvim.flake = false;

    ## Snippets
    neovim-plugin-ultisnips.url = "github:SirVer/ultisnips";
    neovim-plugin-ultisnips.flake = false;
    neovim-plugin-vim-snippets.url = "github:honza/vim-snippets";
    neovim-plugin-vim-snippets.flake = false;

    ## colorscheme
    neovim-plugin-tokyo-night.url = "github:folke/tokyonight.nvim";
    neovim-plugin-tokyo-night.flake = false;

    ## Rust
    neovim-plugin-rust-tools.url = "github:simrat39/rust-tools.nvim";
    neovim-plugin-rust-tools.flake = false;
    neovim-plugin-crates.url = "github:saecki/crates.nvim";
    neovim-plugin-crates.flake = false;

    ## lua
    neovim-plugin-lua-dev.url = "github:folke/lua-dev.nvim";
    neovim-plugin-lua-dev.flake = false;

    ## Markdown
    neovim-plugin-markdown-preview.url = "github:iamcco/markdown-preview.nvim";
    neovim-plugin-markdown-preview.flake = false;

    neovim-plugin-glow-nvim.url = "github:ellisonleao/glow.nvim";
    neovim-plugin-glow-nvim.flake = false;

    ## Terraform
    neovim-plugin-vim-terraform.url = "github:hashivim/vim-terraform";
    neovim-plugin-vim-terraform.flake = false;

    ## CUE
    neovim-plugin-vim-cue.url = "github:jjo/vim-cue";
    neovim-plugin-vim-cue.flake = false;

    ## Nix
    neovim-plugin-vim-nix.url = "github:LnL7/vim-nix";
    neovim-plugin-vim-nix.flake = false;
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , master
    , neovim-nightly
    , nixos-generators
    , fenix
    , utils
    , unstable
    , nix
    , pre-commit-hooks
    , ...
    }@inputs:
    let
      inherit (builtins) listToAttrs attrValues attrNames readDir filter match;
      inherit (nixpkgs) lib;
      inherit (lib) removeSuffix;

      linux64BitSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      pkgsConfig = {
        overlays = attrValues overlays;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
          allowBroken = true;
          # contentAddressedByDefault = true;
        };
      };

      mkOverlays = dir:
        listToAttrs (
          map
            (
              name: {
                name = removeSuffix ".nix" name;
                value = import (dir + "/${name}") inputs;
              }
            )
            (filter (name: match "^.+\.nix$" name != null)
              (attrNames (readDir dir))
            )
        );

      overlays = {
        unstable = final: _prev: {
          unstable = import inputs.unstable {
            inherit (final) system;
            config.allowUnfree = true;
            overlays = attrValues (mkOverlays ./overlays/unstable);
          };
        };
        master = final: _prev: {
          master = import inputs.master {
            inherit (final) system;
            config.allowUnfree = true;
            overlays = attrValues (mkOverlays ./overlays/master);
          };
        };
        neovim-nightly = neovim-nightly.overlay;
        comma = final: _prev: {
          comma = import inputs.comma { inherit (final) pkgs; };
        };
        fenix = fenix.overlay;
      } // (mkOverlays ./overlays);
    in
    {
      homeManagerModules = import ./home/modules { };

      darwinConfigurations.bootstrap = darwin.lib.darwinSystem {
        system = utils.lib.system.x86_64-darwin;
        inherit inputs;
        modules = [
          { nixpkgs = pkgsConfig; }
          ./modules/darwin/bootstrap.nix
        ];
      };

      darwinConfigurations.bootstrap-aarch = darwin.lib.darwinSystem {
        system = utils.lib.system.aarch64-darwin;
        inherit inputs;
        modules = [
          { nixpkgs = pkgsConfig; }
          ./modules/darwin/bootstrap.nix
        ];
      };

      darwinConfigurations.work-mac = import ./modules/darwin/systems/work-mac.nix {
        inherit darwin inputs pkgsConfig;
      };
      work-mac = self.darwinConfigurations.work-mac.system;

      darwinConfigurations.dev-mac = import ./modules/darwin/systems/dev-mac.nix {
        inherit darwin inputs pkgsConfig;
      };
      dev-mac = self.darwinConfigurations.dev-mac.system;

      darwinConfigurations.bt-mac = import ./modules/darwin/systems/bt-mac.nix {
        inherit darwin inputs pkgsConfig;
      };
      bt-mac = self.darwinConfigurations.bt-mac.system;

      nixosConfigurations.dev-vm = import ./modules/linux/systems/dev-vm.nix {
        inherit pkgsConfig;
        pkgs = nixpkgs;
      };
      dev-vm = self.nixosConfigurations.dev-vm.config.system.build.toplevel;

      homeConfigurations.vincent_desjardins = import ./home/config/vincent_desjardins.nix {
        inherit home-manager;
        pkgs = import nixpkgs {
          system = utils.lib.system.x86_64-linux;
          inherit (pkgsConfig) config overlays;
        };
      };
      vincent_desjardins = self.homeConfigurations.vincent_desjardins.activationPackage;

      homeConfigurations.inf10906 = import ./home/config/inf10906.nix {
        inherit home-manager;
        pkgs = import nixpkgs {
          system = utils.lib.system.x86_64-darwin;
          inherit (pkgsConfig) config overlays;
        };
      };
      inf10906 = self.homeConfigurations.inf10906.activationPackage;

      homeConfigurations.vince = import ./home/config/vince.nix {
        inherit home-manager;
        pkgs = import nixpkgs {
          system = utils.lib.system.aarch64-linux;
          inherit (pkgsConfig) config overlays;
        };
      };
      vince = self.homeConfigurations.vince.activationPackage;

      homeConfigurations.vince-mac = import ./home/config/vince-mac.nix {
        inherit home-manager;
        pkgs = import nixpkgs {
          system = utils.lib.system.aarch64-darwin;
          inherit (pkgsConfig) config overlays;
        };
      };
      vince-mac = self.homeConfigurations.vince-mac.activationPackage;

      homeConfigurations.bt-mac = import ./home/config/bt-mac.nix {
        inherit home-manager;
        pkgs = import nixpkgs {
          system = utils.lib.system.aarch64-darwin;
          inherit (pkgsConfig) config overlays;
        };
      };
      hm-bt-mac = self.homeConfigurations.bt-mac.activationPackage;

      os-images.vmware.dev-vm = import ./modules/linux/vm-images/dev-vm.nix {
        inherit pkgsConfig nixos-generators;
        pkgs = unstable;
      };

      packages = listToAttrs
        (builtins.map
          (system: {
            name = system;
            value = {
              "dockerImage/vm-builder" = import ./modules/linux/containers/vm-builder.nix {
                inherit nixpkgs nix;
                inherit system;
                crossSystem = system;
              };
            };
          })
          linux64BitSystems) //
      {
        aarch64-darwin."dockerImage/vm-builder" = import ./modules/linux/containers/vm-builder.nix {
          inherit nixpkgs nix;
          system = utils.lib.system.aarch64-darwin;
          crossSystem = utils.lib.system.aarch64-linux;
        };
      };

      inherit overlays;
    } // utils.lib.eachDefaultSystem (
      system: {
        legacyPackages = import nixpkgs {
          inherit system;
          inherit (pkgsConfig) config overlays;
        };
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              statix.enable = true;
              stylua.enable = true;
            };
          };
        };
        devShell = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}

