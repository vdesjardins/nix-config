inputs: _self: super:
let
  rust-pkgs = import inputs.nixpkgs {
    system = super.system;
    overlays = [ inputs.rust-overlay.overlay ];
  };
  rustPlatform = super.makeRustPlatform {
    cargo = rust-pkgs.rust-bin.stable.latest.default;
    rustc = rust-pkgs.rust-bin.stable.latest.default;
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
