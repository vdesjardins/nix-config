_inputs: _self: super: {
  static-tcpdump = super.tcpdump.overrideDerivation (
    oldAttrs: {
      name = "static-tcpdump";
      postInstall = ''
        mv $out/bin/tcpdump $out/bin/static-tcpdump
      '';
      makeFlags = [ "CFLAGS=-static" ];
      configureFlags = oldAttrs.configureFlags ++ [ "--without-crypto" ];
      buildInputs = oldAttrs.buildInputs ++ [ super.glibc super.glibc.static ];
    }
  );
}
