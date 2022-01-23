{ ... }: {
  home-manager.useGlobalPkgs = true;
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

      ../role/utils
      ../role/dev/nix
      ../role/dev/yaml
      ../role/dev/json
      ../role/dev/bash
      ../role/dev/rust
      ../program/alacritty
      # ../program/wezterm
      ../program/karabiner
      ../service/gpg-agent
      ../program/ssh
      ../program/gcloud
    ];
  };
}
