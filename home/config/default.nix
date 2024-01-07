{
  home-manager,
  lib,
  nix-index-database,
  nixpkgs,
  pkgsConfig,
  utils,
  ...
}:
with lib; let
  dirs = attrNames (filterAttrs (n: v: v == "directory") (builtins.readDir ./.));
  files = flatten (map (dir: (map (f: "${dir}/${f}") (attrNames (filterAttrs (n: v: v == "regular") (builtins.readDir ./${dir}))))) dirs);
  decl = f:
    import ./${f} {
      inherit home-manager nix-index-database nixpkgs utils pkgsConfig;
    };
  configs = builtins.listToAttrs (map (f: {
      name = builtins.replaceStrings [".nix"] [""] f;
      value = decl f;
    })
    files);
in
  configs
