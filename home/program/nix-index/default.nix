{ pkgs, ... }:
{
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.packages = [
    (pkgs.stdenv.mkDerivation {
      name = "comma";
      version = "1.0.0";

      src = ./src;

      installPhase = ''
        mkdir -p $out/bin
        cp update-nix-index $out/bin
        cp , $out/bin
      '';
    })
  ];
}
