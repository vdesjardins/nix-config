{...}: {
  imports = [
    ../../shared.nix
    ./nix.nix
    ./nixpkgs.nix
    ./fonts-fix.nix # TODO: remove when https://github.com/LnL7/nix-darwin/issues/752
    ./system.nix
    ./homebrew.nix
    ../programs/gnupg.nix
  ];

  programs = {
    zsh.enable = true;
  };
}
