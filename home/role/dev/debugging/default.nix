{ pkgs, ... }: {
  home.packages = with pkgs; [ xxd gdb cgdb gdbgui rr-unstable binutils ];
}
