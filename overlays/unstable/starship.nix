inputs: _self: super:
let
  rustPlatform = super.makeRustPlatform {
    inherit (inputs.fenix.packages."${super.system}".minimal) cargo rustc;
  };

  inherit (super) lib nixosTests stdenv installShellFiles fetchFromGitHub pkgs pkg-config;
  inherit (pkgs) openssl libiconv;
  inherit (pkgs.darwin.apple_sdk.frameworks) Security Foundation;
in
{
  starship = rustPlatform.buildRustPackage rec {
    pname = "starship";
    version = "1.5.4";

    src = fetchFromGitHub {
      owner = "starship";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-nLzqfSRmA+D310MDvX+g8nNsoaiSixG+j+g87CPzYMs=";
    };

    nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.isLinux [ pkg-config ];

    buildInputs = lib.optionals stdenv.isLinux [ openssl ]
      ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation ];

    postInstall = ''
      for shell in bash fish zsh; do
        STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
        installShellCompletion starship.$shell
      done
    '';

    cargoSha256 = "sha256-FXzAvO11NIr6dxF2OeV5XJWHG2kgZiASuBnoC6mSps8=";

    preCheck = ''
      HOME=$TMPDIR
    '';

    passthru.tests = {
      inherit (nixosTests) starship;
    };

    NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin [
      # disable modules, otherwise we get redeclaration errors
      "-fno-modules"
    ];

    meta = with lib; {
      description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
      homepage = "https://starship.rs";
      license = licenses.isc;
      maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
    };
  };
}
