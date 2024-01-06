{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.nvim;
in {
  options.programs.nvim = {
    enable = mkEnableOption "My own neovim module";

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      defaultText = literalExpression "pkgs.neovim-unwrapped";
      description = "The package to use for the neovim binary.";
    };

    lang = {
      rust = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable rust language support
        '';
      };
      lua = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable lua language support
        '';
      };
      python = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable python language support
        '';
      };
      cue = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable cue language support
        '';
      };
      nix = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable nix language support
        '';
      };
      terraform = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable terraform language support
        '';
      };
      docker = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable docker language support
        '';
      };
      go = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable go language support
        '';
      };
      json = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable json language support
        '';
      };
      jq = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable jq language support
        '';
      };
      yaml = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable yaml language support
        '';
      };
      cpp = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable cpp language support
        '';
      };
      bash = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable bash language support
        '';
      };
      vim = mkOption {
        type = types.bool;
        default = true;
        description = ''
          enable vimscript language support
        '';
      };
      query = mkOption {
        type = types.bool;
        default = true;
        description = ''
          enable query parser support
        '';
      };
      zig = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable zig language support
        '';
      };
      gotmpl = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable go-template language support
        '';
      };
      make = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable make language support
        '';
      };
      markdown = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable markdown language support
        '';
      };
      rego = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable rego language support
        '';
      };
      regex = mkOption {
        type = types.bool;
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
              (name: builtins.pathExists (./config/lua/my-lang + "/${name}"))
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
                (name: builtins.pathExists (./config/lua/my-lang + "/${name}"))
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
