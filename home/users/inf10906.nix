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

      ../program/alacritty
      ../program/gcloud
      ../program/karabiner
      ../program/ssh
      ../program/wezterm
      ../role/dev/bash
      ../role/dev/json
      ../role/dev/nix
      ../role/dev/rust
      ../role/dev/yaml
      ../role/utils
      ../service/gpg-agent
    ];
  };
}
