{ pkgs, ... }:
pkgs.tcpdump.overrideDerivation (
  oldAttrs: {
    name = "static-tcpdump";
    postInstall = ''
      mv $out/bin/tcpdump $out/bin/static-tcpdump
    '';
    makeFlags = [ "CFLAGS=-static" ];
    configureFlags = oldAttrs.configureFlags ++ [ "--without-crypto" ];
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.glibc pkgs.glibc.static ];
  }
)
