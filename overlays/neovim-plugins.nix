inputs: _self: super:
let
  inherit (builtins) getAttr listToAttrs attrNames filter match map;
  inherit (super.pkgs.lib) removePrefix;
  inherit (super.vimUtils) buildVimPluginFrom2Nix;

  plugins = map (name: removePrefix "neovim-plugin-" name)
    (filter (name: match "^neovim-plugin-.+$" name != null) (attrNames inputs));

  buildPlugin = pname: buildVimPluginFrom2Nix {
    inherit pname;
    version = "main";
    src = getAttr "neovim-plugin-${name}" inputs;
  };
in
{
  neovimPlugins = listToAttrs
    (map (name: { inherit name; value = buildPlugin name; }) plugins);
}
