{pkgs, ...}: let
  comma = pkgs.stdenv.mkDerivation {
    name = "comma";
    version = "1.0.0";

    buildInputs = with pkgs; [coreutils nix-index wget];

    src = ./src;

    phases = ["unpackPhase" "installPhase" "fixupPhase" "postFixupPhase"];

    postFixupPhase = ''
      substituteInPlace $out/bin/update-nix-index \
        --replace "wget " "${pkgs.wget}/bin/wget "
      substituteInPlace $out/bin/update-nix-index \
        --replace "uname " "${pkgs.coreutils}/bin/uname "
      substituteInPlace $out/bin/update-nix-index \
        --replace "tr " "${pkgs.coreutils}/bin/tr "
      substituteInPlace $out/bin/update-nix-index \
        --replace "nix-locate " "${pkgs.nix-index}/bin/nix-locate "
      substituteInPlace $out/bin/update-nix-index \
        --replace "mkdir " "${pkgs.coreutils}/bin/mkdir "
      substituteInPlace $out/bin/update-nix-index \
        --replace "ln " "${pkgs.coreutils}/bin/ln "
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp update-nix-index $out/bin
      cp , $out/bin
    '';
  };
in {
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  home.packages = with pkgs; [
    comma
  ];
}
