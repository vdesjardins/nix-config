{pkgs, ...}: {
  home.packages = with pkgs;
    [
      binutils
      cgdb
      gdb
      gdbgui
      lldb
      xxd
    ]
    ++ lib.optionals stdenv.isLinux [
      uftrace # Function graph tracer for C/C++/Rust
      rr-unstable
    ];
}
