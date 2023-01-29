{ lib, pkgs, ... }:

with lib;

{
  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      cfg = {
        enableTridactylNative = true;
      };
    };
  };
}
