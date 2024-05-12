{
  description = "VinceD's dotfiles flake";

  inputs = {
    # Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    comma.url = "github:nix-community/comma";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    tmux-tokyo-night.url = "github:/fabioluciano/tmux-tokyo-night";
    tmux-tokyo-night.flake = false;

    # languages
    rust-overlay.url = "github:oxalica/rust-overlay";

    # tree-sitter grammars
    tree-sitter-grammars-vim.url = "github:neovim/tree-sitter-vim";
    tree-sitter-grammars-vim.flake = false;
    tree-sitter-grammars-bash.url = "github:tree-sitter/tree-sitter-bash";
    tree-sitter-grammars-bash.flake = false;
    tree-sitter-grammars-cpp.url = "github:tree-sitter/tree-sitter-cpp";
    tree-sitter-grammars-cpp.flake = false;
    tree-sitter-grammars-cue.url = "github:eonpatapon/tree-sitter-cue";
    tree-sitter-grammars-cue.flake = false;
    tree-sitter-grammars-dockerfile.url = "github:camdencheek/tree-sitter-dockerfile";
    tree-sitter-grammars-dockerfile.flake = false;
    tree-sitter-grammars-gotmpl.url = "github:ngalaiko/tree-sitter-go-template";
    tree-sitter-grammars-gotmpl.flake = false;
    tree-sitter-grammars-go.url = "github:tree-sitter/tree-sitter-go";
    tree-sitter-grammars-go.flake = false;
    tree-sitter-grammars-gomod.url = "github:camdencheek/tree-sitter-go-mod";
    tree-sitter-grammars-gomod.flake = false;
    tree-sitter-grammars-hcl.url = "github:MichaHoffmann/tree-sitter-hcl";
    tree-sitter-grammars-hcl.flake = false;
    tree-sitter-grammars-javascript.url = "github:tree-sitter/tree-sitter-javascript";
    tree-sitter-grammars-javascript.flake = false;
    tree-sitter-grammars-json.url = "github:tree-sitter/tree-sitter-json";
    tree-sitter-grammars-json.flake = false;
    tree-sitter-grammars-jq.url = "github:flurie/tree-sitter-jq";
    tree-sitter-grammars-jq.flake = false;
    tree-sitter-grammars-lua.url = "github:MunifTanjim/tree-sitter-lua";
    tree-sitter-grammars-lua.flake = false;
    tree-sitter-grammars-make.url = "github:alemuller/tree-sitter-make";
    tree-sitter-grammars-make.flake = false;
    tree-sitter-grammars-markdown.url = "github:MDeiml/tree-sitter-markdown";
    tree-sitter-grammars-markdown.flake = false;
    tree-sitter-grammars-markdown-inline.url = "github:MDeiml/tree-sitter-markdown";
    tree-sitter-grammars-markdown-inline.flake = false;
    tree-sitter-grammars-nix.url = "github:cstrahan/tree-sitter-nix";
    tree-sitter-grammars-nix.flake = false;
    tree-sitter-grammars-python.url = "github:tree-sitter/tree-sitter-python";
    tree-sitter-grammars-python.flake = false;
    tree-sitter-grammars-query.url = "github:nvim-treesitter/tree-sitter-query";
    tree-sitter-grammars-query.flake = false;
    tree-sitter-grammars-rust.url = "github:tree-sitter/tree-sitter-rust";
    tree-sitter-grammars-rust.flake = false;
    tree-sitter-grammars-sql.url = "github:derekstride/tree-sitter-sql";
    tree-sitter-grammars-sql.flake = false;
    tree-sitter-grammars-toml.url = "github:tree-sitter/tree-sitter-toml";
    tree-sitter-grammars-toml.flake = false;
    tree-sitter-grammars-yaml.url = "github:ikatyang/tree-sitter-yaml";
    tree-sitter-grammars-yaml.flake = false;
    tree-sitter-grammars-zig.url = "github:maxxnino/tree-sitter-zig";
    tree-sitter-grammars-zig.flake = false;
    tree-sitter-grammars-rego.url = "github:FallenAngel97/tree-sitter-rego";
    tree-sitter-grammars-rego.flake = false;
    tree-sitter-grammars-regex.url = "github:tree-sitter/tree-sitter-regex";
    tree-sitter-grammars-regex.flake = false;

    # Neovim
    ## LSP
    neovim-plugin-nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    neovim-plugin-nvim-lspconfig.flake = false;
    neovim-plugin-lspkind-nvim.url = "github:onsails/lspkind-nvim";
    neovim-plugin-lspkind-nvim.flake = false;
    neovim-plugin-nvim-lightbulb.url = "github:kosayoda/nvim-lightbulb";
    neovim-plugin-nvim-lightbulb.flake = false;
    neovim-plugin-none-ls.url = "github:nvimtools/none-ls.nvim";
    neovim-plugin-none-ls.flake = false;
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

    neovim-plugin-copilot.url = "github:zbirenbaum/copilot.lua";
    neovim-plugin-copilot.flake = false;
    neovim-plugin-copilot-cmp.url = "github:zbirenbaum/copilot-cmp";
    neovim-plugin-copilot-cmp.flake = false;

    # ## Debugging
    neovim-plugin-nvim-dap.url = "github:mfussenegger/nvim-dap";
    neovim-plugin-nvim-dap.flake = false;
    neovim-plugin-nvim-dap-ui.url = "github:rcarriga/nvim-dap-ui";
    neovim-plugin-nvim-dap-ui.flake = false;
    neovim-plugin-telescope-dap.url = "github:nvim-telescope/telescope-dap.nvim";
    neovim-plugin-telescope-dap.flake = false;
    neovim-plugin-nvim-dap-go.url = "github:leoluz/nvim-dap-go";
    neovim-plugin-nvim-dap-go.flake = false;
    neovim-plugin-nvim-nio.url = "github:nvim-neotest/nvim-nio";
    neovim-plugin-nvim-nio.flake = false;

    ## Treesitter
    neovim-plugin-nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter";
    neovim-plugin-nvim-treesitter.flake = false;
    neovim-plugin-nvim-treesitter-textobjects.url = "github:nvim-treesitter/nvim-treesitter-textobjects";
    neovim-plugin-nvim-treesitter-textobjects.flake = false;
    neovim-plugin-nvim-treesitter-context.url = "github:nvim-treesitter/nvim-treesitter-context";
    neovim-plugin-nvim-treesitter-context.flake = false;
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
    neovim-plugin-blame-nvim.url = "github:FabijanZulj/blame.nvim";
    neovim-plugin-blame-nvim.flake = false;
    neovim-plugin-vim-fugitive.url = "github:tpope/vim-fugitive";
    neovim-plugin-vim-fugitive.flake = false;
    neovim-plugin-vim-rhubarb.url = "github:tpope/vim-rhubarb";
    neovim-plugin-vim-rhubarb.flake = false;
    neovim-plugin-vim-diffview.url = "github:sindrets/diffview.nvim";
    neovim-plugin-vim-diffview.flake = false;

    ## Telescope
    neovim-plugin-telescope-nvim.url = "github:nvim-telescope/telescope.nvim";
    neovim-plugin-telescope-nvim.flake = false;
    neovim-plugin-telescope-ui-select.url = "github:nvim-telescope/telescope-ui-select.nvim";
    neovim-plugin-telescope-ui-select.flake = false;
    neovim-plugin-telescope-frecency.url = "github:nvim-telescope/telescope-frecency.nvim";
    neovim-plugin-telescope-frecency.flake = false;
    neovim-plugin-telescope-file-browser.url = "github:nvim-telescope/telescope-file-browser.nvim";
    neovim-plugin-telescope-file-browser.flake = false;
    neovim-plugin-easypick.url = "github:axkirillov/easypick.nvim";
    neovim-plugin-easypick.flake = false;

    ## Misc
    neovim-plugin-neodev-nvim.url = "github:folke/neodev.nvim";
    neovim-plugin-neodev-nvim.flake = false;
    neovim-plugin-which-key-nvim.url = "github:folke/which-key.nvim";
    neovim-plugin-which-key-nvim.flake = false;
    neovim-plugin-trouble-nvim.url = "github:folke/trouble.nvim";
    neovim-plugin-trouble-nvim.flake = false;
    neovim-plugin-flash-nvim.url = "github:folke/flash.nvim";
    neovim-plugin-flash-nvim.flake = false;
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
    neovim-plugin-vim-smart-splits.url = "github:mrjones2014/smart-splits.nvim";
    neovim-plugin-vim-smart-splits.flake = false;
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
    neovim-plugin-harpoon.url = "github:ThePrimeagen/harpoon/harpoon2";
    neovim-plugin-harpoon.flake = false;
    neovim-plugin-gitignore.url = "github:wintermute-cell/gitignore.nvim";
    neovim-plugin-gitignore.flake = false;
    neovim-plugin-undotree.url = "github:mbbill/undotree";
    neovim-plugin-undotree.flake = false;
    neovim-plugin-vim-floatterm.url = "github:voldikss/vim-floaterm";
    neovim-plugin-vim-floatterm.flake = false;
    neovim-plugin-vim-toggleterm.url = "github:akinsho/toggleterm.nvim";
    neovim-plugin-vim-toggleterm.flake = false;
    neovim-plugin-noice.url = "github:folke/noice.nvim";
    neovim-plugin-noice.flake = false;
    neovim-plugin-nvim-notify.url = "github:rcarriga/nvim-notify";
    neovim-plugin-nvim-notify.flake = false;
    neovim-plugin-oil.url = "github:stevearc/oil.nvim";
    neovim-plugin-oil.flake = false;
    neovim-plugin-edgy.url = "github:folke/edgy.nvim";
    neovim-plugin-edgy.flake = false;
    neovim-plugin-nvim-luadev.url = "github:bfredl/nvim-luadev";
    neovim-plugin-nvim-luadev.flake = false;

    ## AI
    neovim-plugin-ogpt.url = "github:huynle/ogpt.nvim";
    neovim-plugin-ogpt.flake = false;

    ## text
    neovim-plugin-vim-better-whitespace.url = "github:ntpeters/vim-better-whitespace";
    neovim-plugin-vim-better-whitespace.flake = false;
    neovim-plugin-vim-endwise.url = "github:tpope/vim-endwise";
    neovim-plugin-vim-endwise.flake = false;
    neovim-plugin-auto-pairs.url = "github:windwp/nvim-autopairs";
    neovim-plugin-auto-pairs.flake = false;
    neovim-plugin-vim-grepper.url = "github:mhinz/vim-grepper";
    neovim-plugin-vim-grepper.flake = false;
    neovim-plugin-vim-surround.url = "github:kylechui/nvim-surround";
    neovim-plugin-vim-surround.flake = false;
    neovim-plugin-text-case.url = "github:johmsalas/text-case.nvim";
    neovim-plugin-text-case.flake = false;
    neovim-plugin-dressing.url = "github:stevearc/dressing.nvim";
    neovim-plugin-dressing.flake = false;

    ## Snippets
    neovim-plugin-ultisnips.url = "github:SirVer/ultisnips";
    neovim-plugin-ultisnips.flake = false;
    neovim-plugin-vim-snippets.url = "github:honza/vim-snippets";
    neovim-plugin-vim-snippets.flake = false;

    ## colorscheme [theme]
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
    neovim-plugin-vim-markdown-toc.url = "github:mzlogin/vim-markdown-toc";
    neovim-plugin-vim-markdown-toc.flake = false;
    neovim-plugin-vim-table-mode.url = "github:dhruvasagar/vim-table-mode";
    neovim-plugin-vim-table-mode.flake = false;

    ## Terraform
    neovim-plugin-vim-terraform.url = "github:hashivim/vim-terraform";
    neovim-plugin-vim-terraform.flake = false;

    ## CUE
    neovim-plugin-vim-cue.url = "github:jjo/vim-cue";
    neovim-plugin-vim-cue.flake = false;

    ## Nix
    neovim-plugin-vim-nix.url = "github:LnL7/vim-nix";
    neovim-plugin-vim-nix.flake = false;

    ## YAML
    neovim-plugin-vim-yaml-companion.url = "github:someone-stole-my-name/yaml-companion.nvim";
    neovim-plugin-vim-yaml-companion.flake = false;
  };

  outputs = {
    comma,
    deploy-rs,
    home-manager,
    master,
    neovim-nightly,
    nix,
    nix-darwin,
    nix-index-database,
    nixos-generators,
    nixos-hardware,
    nixpkgs,
    nur,
    pre-commit-hooks,
    rust-overlay,
    self,
    unstable,
    utils,
    ...
  } @ inputs: let
    inherit (lib.attrsets) genAttrs listToAttrs attrValues attrNames;
    inherit (builtins) readDir filter match;
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
          lib.attrsets.nameValuePair (lib.strings.removeSuffix ".nix" name) (prev.callPackage ./packages/${name} {})
      ) (builtins.readDir ./packages);

    myOverlays =
      {
        unstable = mkChildOverlays "unstable";
        master = mkChildOverlays "master";
        myPkgs = mkPackagesOverlay;
      }
      // (mkOverlays ./overlays/nixpkgs);

    extraOverlays =
      {
        nur = nur.overlay;
        neovim-nightly = neovim-nightly.overlay;
        rust-overlay = rust-overlay.overlays.default;
      }
      // comma.overlays;

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

    lib = nixpkgs.lib.extend (final: prev: {
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
      unstable = mkOverlays ./overlays/unstable;
    };

    devShells = forAllSupportedSystems (system:
      with pkgs.${system}; {
        default = mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      });

    checks = forAllSupportedSystems (
      system:
        with pkgs.${system}; {
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
