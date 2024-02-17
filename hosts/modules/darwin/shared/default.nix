{...}: {
  imports = [
    ../../shared.nix
    ../../desktop.nix
    ./nix.nix
    ./nixpkgs.nix
    ./fonts-fix.nix # TODO: remove when https://github.com/LnL7/nix-darwin/issues/752
    ./system.nix
    ./homebrew.nix
    ./karabiner.nix
    ../programs/gnupg.nix
  ];

  nix.gc.interval = {
    Weekday = 0;
    Hour = 3;
    Minute = 0;
  };

  programs = {
    zsh.enable = true;
  };
}
