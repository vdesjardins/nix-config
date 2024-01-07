{lib, ...}: let
  findModules =
    map
    (
      name: ./${name}
    )
    (
      lib.filter (name: builtins.match "^default.nix$" name == null)
      (lib.attrNames (builtins.readDir ./.))
    );
in {
  imports = findModules;
}
