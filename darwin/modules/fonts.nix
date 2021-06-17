{ pkgs, ... }:

{
  fonts.enableFontDir = true;
  fonts.fonts = [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "VictorMono" ]; })
  ];
}
