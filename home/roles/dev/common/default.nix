{ pkgs, ... }: {
  home.packages = with pkgs; [ unstable.asdf-vm ];
}
