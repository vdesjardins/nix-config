{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.debugging;
in {
  options.roles.dev.debugging = {
    enable = mkEnableOption "dev.debugging";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.gdb.enable = pkgs.stdenv.isLinux;

    modules.shell.tools.nix-function-calls.enable = true;

    home.packages = with pkgs;
      [
        binutils
        # lldb
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
  };
}
