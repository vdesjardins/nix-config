{ pkgs, ... }: {
  home.packages = with pkgs; [ xxd gdb cgdb gdbgui binutils lldb ] ++ lib.optionals stdenv.isLinux [
    rr-unstable
  ];
}
