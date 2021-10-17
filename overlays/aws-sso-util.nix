inputs: _self: super:
{
  aws-sso-util = super.poetry2nix.mkPoetryApplication rec {
    pname = "aws-sso-util";
    version = "latest";

    src = inputs.aws-sso-util;

    sourceRoot = "source/cli";
    projectDir = "${src}/cli";

    meta = with super.lib; {
      homepage = "https://github.com/benkehoe/aws-sso-util";
      description = "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better).";
      license = licenses.asl20;
      maintainers = [ maintainers.vdesjardins ];
    };
  };
}
