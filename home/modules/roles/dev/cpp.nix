{pkgs, ...}: {
  home.packages = with pkgs; [
    clang-tools
    cmake
    cppcheck
    gcc
    poco
  ];
}
