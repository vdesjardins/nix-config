_inputs: _self: super: {
  wezterm = super.wezterm.overrideAttrs (old: {
    buildInputs = old.buildInputs ++
      super.lib.optionals super.stdenv.isDarwin (with super.pkgs.darwin.apple_sdk.frameworks; [
        UserNotifications
      ]);
    meta = with super.libs; {
      platforms = super.platforms.unix;
      broken = false;
    };
  });
}
