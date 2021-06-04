inputs: {
  modules = [
    ../modules/darwin
    inputs.home-manager.darwinModules.home-manager
    (
      { pkgs, config, ... }: {
        home-manager.users."vdesjardins" =
          { ... }: {
            imports = [ ../user/vdesjardins.nix ];

            config = {
              home.username = "vdesjardins";
              home.homeDirectory = "/Users/vdesjardins";

              home.sessionVariables = {
                NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = 1;
              };

              programs.gpg.enable = true;

              home.sessionVariables = {
                VAULT_USERNAME = "inf10906";
                VAULT_ADDR = "https://vault.gcp.internal";
              };
            };
          };
        home-manager.allowUnfree = true;
      }
    )
  ];
}
