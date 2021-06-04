{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [ gdb cgdb gdbgui rr-unstable binutils ];
}
