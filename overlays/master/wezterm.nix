_inputs: _self: super: {
  wezterm = super.wezterm.overrideAttrs (drv: rec {
    name = "wezterm-main";

    src = super.fetchFromGitHub {
      owner = "wez";
      repo = "wezterm";
      rev = "20220905-102802-7d4b8249";
      fetchSubmodules = true;
      sha256 = "sha256-Xvi0bluLM4F3BFefIPhkhTF3dmRvP8u+qV70Rz4CGKI=";
    };

    cargoDeps = drv.cargoDeps.overrideAttrs (super.lib.const {
      name = "${name}-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-LPZRuYCamEeSg9nUcQs0FShosF5sssqA0lPKEKQ1z/A=";
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
