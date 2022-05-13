_inputs: _self: super: {
  wezterm = super.wezterm.overrideAttrs (drv: rec {
    name = "wezterm-main";

    src = super.fetchFromGitHub {
      owner = "wez";
      repo = "wezterm";
      rev = "64921bf8a187a9505743a26b3bc5e2007abae1f5";
      fetchSubmodules = true;
      sha256 = "sha256-WgGLmagi7PMOFO45q7xIB1LHac+2DA01WXSUkhTHcvM=";
    };

    cargoDeps = drv.cargoDeps.overrideAttrs (super.lib.const {
      name = "${name}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-Ic/ap/QlH7HhO39QaLHk9zohp49PBmWKpBNxxSIYWO4=";
    });

    buildInputs = drv.buildInputs ++
      super.lib.optionals super.stdenv.isDarwin (with super.pkgs.darwin.apple_sdk.frameworks; [
        UserNotifications
      ]);

    meta = with super.libs; {
      broken = false;
    };
  });
}
