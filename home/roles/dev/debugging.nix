{pkgs, ...}: {
  modules.shell.tools.gdb.enable = pkgs.stdenv.isLinux;

  home.packages = with pkgs;
    [
      binutils
      lldb
      # mitmproxy
      # mitmproxy2swagger
      xxd
    ]
    ++ lib.optionals stdenv.isLinux [
      gdbgui
      cgdb
      uftrace # Function graph tracer for C/C++/Rust
      rr-unstable
    ];
}
