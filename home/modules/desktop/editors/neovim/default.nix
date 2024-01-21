{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) pathExists;
  inherit (lib.attrsets) attrNames getAttr hasAttr;
  inherit (lib.options) mkEnableOption mkPackageOption mkOption literalExpression;
  inherit (lib.lists) concatLists filter flatten map;
  inherit (lib.types) bool package str;
  inherit (lib.strings) concatStringsSep;

  cfg = config.modules.desktop.editors.neovim;
in {
  options.modules.desktop.editors.neovim = {
    enable = mkEnableOption "neovim editor";

    package = mkPackageOption pkgs "neovim-unwrapped" {
      default = pkgs.neovim-unwrapped;
    };

    lang = {
      rust = mkOption {
        type = bool;
        default = false;
        description = ''
          enable rust language support
        '';
      };
      lua = mkOption {
        type = bool;
        default = false;
        description = ''
          enable lua language support
        '';
      };
      python = mkOption {
        type = bool;
        default = false;
        description = ''
          enable python language support
        '';
      };
      cue = mkOption {
        type = bool;
        default = false;
        description = ''
          enable cue language support
        '';
      };
      nix = mkOption {
        type = bool;
        default = false;
        description = ''
          enable nix language support
        '';
      };
      terraform = mkOption {
        type = bool;
        default = false;
        description = ''
          enable terraform language support
        '';
      };
      docker = mkOption {
        type = bool;
        default = false;
        description = ''
          enable docker language support
        '';
      };
      go = mkOption {
        type = bool;
        default = false;
        description = ''
          enable go language support
        '';
      };
      json = mkOption {
        type = bool;
        default = false;
        description = ''
          enable json language support
        '';
      };
      jq = mkOption {
        type = bool;
        default = false;
        description = ''
          enable jq language support
        '';
      };
      yaml = mkOption {
        type = bool;
        default = false;
        description = ''
          enable yaml language support
        '';
      };
      cpp = mkOption {
        type = bool;
        default = false;
        description = ''
          enable cpp language support
        '';
      };
      bash = mkOption {
        type = bool;
        default = false;
        description = ''
          enable bash language support
        '';
      };
      vim = mkOption {
        type = bool;
        default = true;
        description = ''
          enable vimscript language support
        '';
      };
      query = mkOption {
        type = bool;
        default = true;
        description = ''
          enable query parser support
        '';
      };
      zig = mkOption {
        type = bool;
        default = false;
        description = ''
          enable zig language support
        '';
      };
      gotmpl = mkOption {
        type = bool;
        default = false;
        description = ''
          enable go-template language support
        '';
      };
      make = mkOption {
        type = bool;
        default = false;
        description = ''
          enable make language support
        '';
      };
      markdown = mkOption {
        type = bool;
        default = false;
        description = ''
          enable markdown language support
        '';
      };
      rego = mkOption {
        type = bool;
        default = false;
        description = ''
          enable rego language support
        '';
      };
      regex = mkOption {
        type = bool;
        default = false;
        description = ''
          enable regex language support
        '';
      };
    };
  };

  config =
    mkIf cfg.enable
    (
      let
        nvimConfig = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-config";
          src = ./config;
        };

        plugins =
          pkgs.neovimPlugins
          // {
            nvim-treesitter =
              pkgs.neovimPlugins.nvim-treesitter.overrideAttrs
              (_: {
                postPatch = let
                  grammars = pkgs.unstable.tree-sitter.withPlugins (_: generateTreeSitterGrammars);
                in ''
                  rm -r parser
                  ln -s ${grammars} parser
                '';
              });
          };

        treeSitterMapping = {
          terraform = ["hcl"];
          docker = ["dockerfile"];
          markdown = ["markdown" "markdown-inline"];
        };

        activeLanguages =
          filter (name: (getAttr name cfg.lang))
          (attrNames cfg.lang);

        treeSitterLanguages = flatten (map
          (name:
            if (hasAttr name treeSitterMapping)
            then getAttr name treeSitterMapping
            else name)
          activeLanguages);

        generateLuaRequires =
          concatStringsSep "\n"
          (map
            (
              name: "require(\"my-lang.${name}\")"
            )
            (
              filter
              (name: pathExists (./config/lua/my-lang + "/${name}"))
              activeLanguages
            ));

        generatePackages =
          concatLists
          (map
            (
              name: (pkgs.callPackage (./config/lua/my-lang + "/${name}") {}).packages
            )
            ((
                filter
                (name: pathExists (./config/lua/my-lang + "/${name}"))
                activeLanguages
              )
              ++ ["null-ls"]));

        generateTreeSitterGrammars =
          map
          (
            name: (getAttr "tree-sitter-${name}" pkgs.unstable.tree-sitter-grammars)
          )
          (
            filter (name: (hasAttr "tree-sitter-${name}" pkgs.unstable.tree-sitter-grammars))
            treeSitterLanguages
          );

        pkgNeovim =
          pkgs.wrapNeovim cfg.package
          {
            viAlias = true;
            vimAlias = true;
            # vimdiffAlias = true;

            withPython3 = true;
            withNodeJs = true;
            withRuby = false;

            configure = {
              customRC = ''
                luafile ${nvimConfig.out}/init.lua

                lua << EOF
                -- must be first
                require("my-lang")
                -- languages support
                ${generateLuaRequires}
                -- must be last
                require("my-lang.null-ls")
                EOF
              '';

              packages.myVimPackage = {
                start = (builtins.attrValues plugins) ++ [nvimConfig];
              };
            };
          };
      in {
        home.packages = with pkgs;
          [
            pkgNeovim
            unstable.python311
            python3Packages.pynvim
            pkgs.unstable.tree-sitter
            (pkgs.unstable.tree-sitter.withPlugins (_: generateTreeSitterGrammars))

            # tools
            fzf
            bat
            ripgrep
            curl
          ]
          ++ generatePackages;
      }
    );
}
