{ pkgs, ... }: {
  home.packages = with pkgs; [ checkmake ];
}
