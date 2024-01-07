{pkgs, ...}: {
  home.packages = with pkgs;
    [
      binutils
      gdb
      gdbgui
      lldb
      mitmproxy
      mitmproxy2swagger
      xxd
    ]
    ++ lib.optionals stdenv.isLinux [
      cgdb
      uftrace # Function graph tracer for C/C++/Rust
      rr-unstable
    ];
}
