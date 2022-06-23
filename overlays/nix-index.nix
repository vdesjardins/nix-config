_inputs: _self: super: {
  nix-index-unwrapped = super.nix-index-unwrapped.overrideAttrs
    (drv: rec {
      src = super.pkgs.fetchFromGitHub {
        owner = "bennofs";
        repo = "nix-index";
        rev = "2b0773a7bd1252714285c0bcf591747db47e157e";
        sha256 = "sha256-eP/o0GdZYSAE6MEi07uMkvuTb0Rxq4LZRGMERipE8oE=";
      };

      cargoDeps = drv.cargoDeps.overrideAttrs (super.lib.const {
        inherit src;
        outputHash = "sha256-2Yhnacsx8EWsfZfcfKhV687cblyFDmsfdqGZoK6Lulo=";
      });

      doCheck = false;
    });
}
