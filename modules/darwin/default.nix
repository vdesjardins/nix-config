{ device_name ? "spotifyd" }:
{
  imports = [
    ../shared.nix
    ./nix.nix
    ./nixpkgs.nix
    ./system.nix
    ./homebrew.nix
    ./programs/gnupg.nix
    (import ./services/spotifyd { inherit device_name; })
  ];

  programs = {
    zsh.enable = true;
  };
}
