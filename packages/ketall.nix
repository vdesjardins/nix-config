{
  buildGoModule,
  fetchFromGitHub,
  lib,
  ...
}: let
  versioning = builtins.fromJSON (builtins.readFile ./ketall.json);
in
  buildGoModule {
    pname = "ketall";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "corneliusweig";
      repo = "ketall";
      rev = versioning.revision;
      sha256 = versioning.hash;
    };

    vendorHash = versioning.vendorHash;

    meta = {
      description = "Like `kubectl get all`, but get really all resources";
      homepage = "https://github.com/corneliusweig/ketall";
      license = lib.licenses.asl20;
      platforms = with lib.platforms; all;
      maintainers = with lib.maintainers; [vdesjardins];
    };
  }
