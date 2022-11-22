inputs: _self: super:
let
  pname = "aws-sso-util";
  version = "latest";
  src = inputs.aws-sso-util;
  projectDir = "${src}/cli";
in
{
  aws-sso-util = super.poetry2nix.mkPoetryApplication {
    inherit pname version src projectDir;
    python = super.pkgs.python310;

    overrides = super.poetry2nix.overrides.withDefaults (self: super: {
      aws-sso-lib = super.aws-sso-lib.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ self.pkgs.python310Packages.poetry ];
        }
      );
    });

    meta = with super.lib; {
      homepage = "https://github.com/benkehoe/aws-sso-util";
      description = "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better).";
      license = licenses.asl20;
      maintainers = [ maintainers.vdesjardins ];
    };
  };
}
