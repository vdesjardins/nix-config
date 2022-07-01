inputs: _self: super:
let
  rustPlatform = super.makeRustPlatform {
    inherit (inputs.fenix.packages."${super.system}".minimal) cargo rustc;
  };

  inherit (super) lib nixosTests stdenv installShellFiles fetchFromGitHub pkgs pkg-config;
  inherit (pkgs) openssl libiconv;
  inherit (pkgs.darwin.apple_sdk.frameworks) Security Foundation Cocoa AppKit;
in
{
  starship = rustPlatform.buildRustPackage rec {
    pname = "starship";
    version = "1.9.1";

    src = fetchFromGitHub {
      owner = "starship";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-IujaGyAGYlBb4efaRb13rsPSD2gWAg5UgG10iMp9iQE=";
    };

    nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.isLinux [ pkg-config ];

    buildInputs = lib.optionals stdenv.isLinux [ openssl ]
      ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation Cocoa AppKit ];

    postInstall = ''
      for shell in bash fish zsh; do
        STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
        installShellCompletion starship.$shell
      done
    '';

    cargoSha256 = "sha256-HrSMNNrldwb6LMMuxdQ84iY+/o5L2qwe+Vz3ekQt1YQ=";

    preCheck = ''
      HOME=$TMPDIR
    '';

    passthru.tests = {
      inherit (nixosTests) starship;
    };

    # from https://github.com/NixOS/nixpkgs/issues/160876#issuecomment-1060113970
    NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin [
      # disable modules, otherwise we get redeclaration errors
      "-fno-modules"
      # link AppKit since we don't get it from modules now
      "-framework"
      "AppKit"
    ];

    meta = with lib; {
      description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
      homepage = "https://starship.rs";
      license = licenses.isc;
      maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
    };
  };
}
