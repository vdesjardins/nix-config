{pkgs, ...}: {
  programs.nvim.lang.cpp = true;

  home.packages = with pkgs; [gcc poco cmake clang-tools cppcheck];
}
