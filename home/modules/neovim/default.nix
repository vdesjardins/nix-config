{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.myNeovim;
in
{
  options.programs.myNeovim = {
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
      viml = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable vimscript language support
        '';
      };
    };
  };

  config = mkIf cfg.enable
    (
      let
        nvimConfig = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-config";
          src = ./config;
        };

        plugins = pkgs.neovimPlugins // {
          nvim-treesitter = pkgs.neovimPlugins.nvim-treesitter.overrideAttrs
            (_: {
              postPatch =
                let
                  grammars = pkgs.unstable.tree-sitter.withPlugins (_: generateTreeSitterGrammars);
                in
                ''
                  rm -r parser
                  ln -s ${grammars} parser
                '';
            });
        };

        activeLanguages = filter (name: (getAttr name cfg.lang))
          (attrNames cfg.lang);

        generateLuaRequires = concatStringsSep "\n"
          (map
            (
              name: "require(\"my-lang.${name}\")"
            )
            activeLanguages
          );

        generatePackages = concatLists
          (map
            (
              name: (pkgs.callPackage (./config/lua/my-lang + "/${name}") { }).packages
            )
            (
              activeLanguages ++ [ "null-ls" ]
            ));

        generateTreeSitterGrammars =
          map
            (
              name: (getAttr "tree-sitter-${name}" pkgs.unstable.tree-sitter-grammars)
            )
            (filter (name: (hasAttr "tree-sitter-${name}" pkgs.unstable.tree-sitter-grammars))
              activeLanguages
            );

        pkgNeovim = pkgs.wrapNeovim cfg.package
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
                start = (builtins.attrValues plugins) ++ [ nvimConfig ];
              };
            };
          };
      in
      {
        home.packages = with pkgs;
          [
            pkgNeovim
            python3
            python3Packages.pynvim
            pkgs.unstable.tree-sitter
            (pkgs.unstable.tree-sitter.withPlugins (_: generateTreeSitterGrammars))

            # tools
            fzf
            bat
            ripgrep
            curl
          ] ++ generatePackages;
      }
    );
}

