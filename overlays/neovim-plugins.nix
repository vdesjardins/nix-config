inputs: _self: super: let
  inherit (builtins) getAttr listToAttrs attrNames filter match map;
  inherit (super.pkgs.lib) removePrefix;
  inherit (super.vimUtils) buildVimPluginFrom2Nix;

  plugins =
    map (removePrefix "neovim-plugin-")
    (filter (name: match "^neovim-plugin-.+$" name != null) (attrNames inputs));

  buildPlugin = pname:
    buildVimPluginFrom2Nix {
      inherit pname;
      version = "main";
      src = getAttr "neovim-plugin-${pname}" inputs;
    };
in {
  neovimPlugins =
    listToAttrs
    (map (name: {
        inherit name;
        value = buildPlugin name;
      })
      plugins);
}
