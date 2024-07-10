{pkgs, ...}: {
  home.packages = with pkgs;
    [
      binutils
      lldb
      mitmproxy
      mitmproxy2swagger
      xxd
    ]
    ++ lib.optionals stdenv.isLinux [
      gdb
      gdbgui
      cgdb
      uftrace # Function graph tracer for C/C++/Rust
      rr-unstable
    ];
}
