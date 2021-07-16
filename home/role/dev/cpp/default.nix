{ pkgs, ... }: {
  home.packages = with pkgs; [ gcc poco cmake clang-tools cppcheck ];
}
