{
  darwin,
  inputs,
  lib,
  pkgsConfig,
}:
with lib; let
  findFiles = attrNames (builtins.readDir ./darwin);
  decl = f:
    import ./darwin/${f} {
      inherit darwin inputs pkgsConfig;
    };
  configs = builtins.listToAttrs (map (f: {
      name = builtins.replaceStrings [".nix"] [""] f;
      value = decl f;
    })
    findFiles);
in
  configs
