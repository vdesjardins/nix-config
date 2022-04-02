{ pkgs, ... }: {
  programs.myNeovim.lang.cpp = true;

  home.packages = with pkgs; [ gcc poco cmake clang-tools cppcheck ];
}
