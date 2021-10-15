inputs: _self: super:
let
  rustPlatform = super.makeRustPlatform {
    inherit (inputs.fenix.packages.${super.system}.minimal) cargo rustc;
  };
in
{
  aws-find-profile = rustPlatform.buildRustPackage {
    name = "aws-find-profile";


    src = inputs.aws-find-profile;

    cargoSha256 = "sha256-2emQMeArq59xzgswa8eji8XOMHZznDaV3HQpXL9DNSA=";

    meta = with super.lib; {
      description = "A small tool to retreive the AWS config profile name from an account ID";
      homepage = "https://github.com/vdesjardins/aws-find-profile";
      license = licenses.asl20;
      maintainers = [ maintainers.vdesjardins ];
    };
  };
}
