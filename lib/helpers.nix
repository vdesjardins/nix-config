{lib, ...}: let
  inherit (builtins) foldl' isAttrs attrNames;
  inherit (lib) isDerivation;

  flattenAttrs = attrs: prefix:
    foldl' (
      acc: key: let
        value = attrs.${key};
        fullKey =
          if prefix == ""
          then key
          else "${prefix}.${key}";
      in
        if isAttrs value && !(isDerivation value)
        then acc // (flattenAttrs value fullKey)
        else acc // {"${fullKey}" = value;}
    ) {} (attrNames attrs);
  flattenAttrs' = attrs: flattenAttrs attrs "";

  filterScopes = attrs:
    foldl' (
      acc: key: let
        value = attrs.${key};
      in
        if isAttrs value && !isDerivation value
        then let
          child = filterScopes value;
        in
          if child != {}
          then acc // {"${key}" = child;}
          else acc
        else if isDerivation value
        then acc // {"${key}" = value;}
        else acc
    ) {} (attrNames attrs);
in {
  inherit filterScopes flattenAttrs flattenAttrs';
}
