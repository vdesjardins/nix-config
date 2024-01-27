inputs: _self: super: let
  inherit (builtins) getAttr listToAttrs attrNames filter match map;
  inherit (super.pkgs.lib) removePrefix;
  inherit (super.vimUtils) buildVimPlugin;

  plugins =
    map (removePrefix "neovim-plugin-")
    (filter (name: match "^neovim-plugin-.+$" name != null) (attrNames inputs));

  buildPlugin = name:
    buildVimPlugin {
      inherit name;
      version = "main";
      src = getAttr "neovim-plugin-${name}" inputs;
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
