_inputs: _self: super: {
  kcl-language-server = super.kclvm.override (prev: {
    rustPlatform =
      prev.rustPlatform
      // {
        buildRustPackage = args:
          prev.rustPlatform.buildRustPackage (
            args
            // {
              pname = "kcl-language-server";
              cargoBuildFlags = [
                "--manifest-path"
                "tools/src/LSP/Cargo.toml"
              ];
            }
          );
      };
  });
}
