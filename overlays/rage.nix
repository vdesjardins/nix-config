inputs: _self: super:
let
  rustPlatform = super.makeRustPlatform {
    inherit (inputs.fenix.packages."${super.system}".minimal) cargo rustc;
  };
in
{
  rage = rustPlatform.buildRustPackage rec {
    name = "rage";
    pversion = "v0.7.0";

    src = super.pkgs.fetchFromGitHub {
      owner = "str4d";
      repo = "rage";
      rev = pversion;
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };

    cargoSha256 = "0000000000000000000000000000000000000000000000000000";

    meta = with super.lib; {
      description = ''A simple, secure and modern encryption tool
    (and Rust library) with small explicit keys, no config options,
    and UNIX-style composability.'';
      homepage = "https://github.com/str4d/rage";
      license = licenses.asl20;
      maintainers = [ maintainers.vdesjardins ];
    };
  };
}
