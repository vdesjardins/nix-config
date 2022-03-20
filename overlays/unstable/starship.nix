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
    version = "1.4.2";

    src = fetchFromGitHub {
      owner = "starship";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-eCttQQ6pL8qkA1+O5p0ufsQo5vcypOEYxq+fNhyrdCo=";
    };

    nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.isLinux [ pkg-config ];

    buildInputs = lib.optionals stdenv.isLinux [ openssl ]
      ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation ];

    buildFeatures = lib.optional (!stdenv.isDarwin) "notify-rust";

    postInstall = ''
      for shell in bash fish zsh; do
        STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
        installShellCompletion starship.$shell
      done
    '';

    cargoSha256 = "sha256-QO1zch9b74lFmlgIbktTrxgtRh5lZ6+c9niy81SZK0Q=";

    preCheck = ''
      HOME=$TMPDIR
    '';

    passthru.tests = {
      inherit (nixosTests) starship;
    };

    NIX_CFLAGS_COMPILE = [
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
