{lib, ...}: {
  filterPackagesWithTests = pkgs:
    lib.filterAttrs (name: pkg: pkg ? passthru.tests) pkgs;
}
