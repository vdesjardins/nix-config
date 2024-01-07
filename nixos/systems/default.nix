{
  darwin,
  inputs,
  lib,
  pkgsConfig,
  nixpkgs,
}:
with lib; let
  findFiles =
    filter (name: builtins.match "^default.nix$" name == null)
    (attrNames (builtins.readDir ./.));
  decl = f:
    import ./${f} {
      inherit darwin inputs nixpkgs pkgsConfig;
    };
  configs = builtins.listToAttrs (map (f: {
      name = builtins.replaceStrings [".nix"] [""] f;
      value = decl f;
    })
    findFiles);
in
  configs
