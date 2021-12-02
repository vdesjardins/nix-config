_inputs: _self: super: {
  luaformatter = super.luaformatter.override {
    stdenv = super.pkgs.llvmPackages_11.stdenv;
  };
  libargs = super.libargs.overrideAttrs (_old: rec {
    version = "6.2.7";
    src = super.pkgs.fetchFromGitHub {
      owner = "Taywee";
      repo = "args";
      rev = version;
      sha256 = "sha256-I297qPXs8Fj7Ibq2PN6y/Eas3DiW5Ecvqot0ePwFNTI=";
    };
  });
}
