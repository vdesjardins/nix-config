{lib, ...}: let
  inherit (builtins) pathExists readDir isString toString;
  inherit (lib.attrsets) collect nameValuePair filterAttrs mapAttrs';
  inherit (lib.strings) hasPrefix hasSuffix removeSuffix;
  inherit (lib.trivial) id;
  inherit (lib.lists) forEach;

  mapModulesRecursive = dir: fn:
    filterAttrs (n: v: v != null)
    (
      mapAttrs' (name: value: let
        path = "${toString dir}/${name}";
      in
        if value == "directory" && pathExists "${path}/default.nix"
        then nameValuePair name (fn path)
        else if value == "directory" && !pathExists "${path}/.nixmodule"
        then nameValuePair name (mapModulesRecursive path fn)
        else if value == "regular" && name != "default.nix" && hasSuffix ".nix" name && !hasPrefix "_" name
        then nameValuePair (removeSuffix ".nix" name) (fn path)
        else nameValuePair "" null) (readDir dir)
    );
  mapModulesRecursive' = dir: fn: (forEach
    (collect isString
      (mapModulesRecursive dir id))
    fn);
in {
  inherit mapModulesRecursive mapModulesRecursive';
}
