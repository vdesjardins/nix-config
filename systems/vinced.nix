inputs: {
  system = "x86_64-linux";
  username = "vincent_desjardins";
  homeDirectory = "/home/vincent_desjardins";

  extraModules = [ inputs.vde-neovim.hmModule ];

  configuration =
    { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = inputs.vde-neovim.overlays;

      home.sessionVariables = {
        VAULT_USERNAME = "inf10906";
        VAULT_ADDR = "https://vault.gcp.internal";
      };

      xdg.enable = true;

      home.stateVersion = "20.09";

      imports = [ ../user/vincent_desjardins.nix ];
    };
}
