{pkgs, ...}: {
  home.packages = with pkgs;
    [
      binutils
      cgdb
      gdb
      gdbgui
      lldb
      mitmproxy
      mitmproxy2swagger
      xxd
    ]
    ++ lib.optionals stdenv.isLinux [
      uftrace # Function graph tracer for C/C++/Rust
      rr-unstable
    ];
}
