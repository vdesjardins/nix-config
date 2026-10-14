_inputs: _final: prev: {
  # Work around the dependency hash mismatch in nixpkgs' 6.0.2 package.
  typescript-language-server = prev.typescript-language-server.overrideAttrs (old: {
    pnpmDeps = old.pnpmDeps.overrideAttrs {
      outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
    };
  });
}
