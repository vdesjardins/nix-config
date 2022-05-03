{ ... }: {
  home-manager.useGlobalPkgs = true;

  home-manager.sharedModules = [ ../modules ];

  home-manager.users.inf10906 = { ... }: {
    home.sessionVariables = {
      EDITOR = "vi";
      NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = 1;
    };

    home.sessionVariables = {
      VAULT_USERNAME = "inf10906";
      VAULT_ADDR = "https://vault.gcp.internal";
    };

    imports = [
      ./default.nix

      ../programs/alacritty
      ../programs/gcloud
      ../programs/karabiner
      ../programs/ssh
      ../programs/wezterm
      ../roles/dev/bash
      ../roles/dev/json
      ../roles/dev/nix
      ../roles/dev/rust
      ../roles/dev/yaml
      ../roles/utils
      ../services/gpg-agent
    ];
  };
}
