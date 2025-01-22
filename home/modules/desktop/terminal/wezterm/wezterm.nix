{
  pkgs,
  key_leader ? "-",
  mods_leader ? "CTRL",
  color-scheme,
  font,
}:
with pkgs; let
  os =
    if hostPlatform.isLinux
    then "linux"
    else "darwin";

  findModules = dir:
    map
    (
      name: (lib.replaceStrings ["/"] ["."] dir) + "." + (lib.removeSuffix ".lua" name)
    )
    (
      lib.filter (name: builtins.match "^.+\.lua$" name != null)
      (lib.attrNames (builtins.readDir ./${dir}))
    );

  modules = (findModules "my-config/common") ++ (findModules "my-config/${os}");

  moduleImports = lib.concatMapStrings (s: "require('" + s + "').configure(config, globals)\n") modules;
in
  # lua
  ''
    local globals = {
      key_leader = "${key_leader}",
      mods_leader = "${mods_leader}",
      font = "${font}",
      color_scheme = "${color-scheme}",
    }

    local config = {
      check_for_updates = false,

      exit_behavior = "Close",
    }

    ${moduleImports}

    return config
  ''
