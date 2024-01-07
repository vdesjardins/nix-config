{
  inputs,
  lib,
  pkgsConfig,
  nixpkgs,
}:
with lib; let
  findFiles = attrNames (builtins.readDir ./linux);
  decl = f:
    import ./linux/${f} {
      inherit inputs nixpkgs pkgsConfig;
    };
  configs = builtins.listToAttrs (map (f: {
      name = builtins.replaceStrings [".nix"] [""] f;
      value = decl f;
    })
    findFiles);
in
  configs
