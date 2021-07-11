{
  imports = [
    ../shared.nix
    ./nix.nix
    ./nixpkgs.nix
    ./system.nix
    ./homebrew.nix
    ./programs/gnupg.nix
  ];

  programs = {
    vim.enable = true;
    zsh.enable = true;
  };
}
