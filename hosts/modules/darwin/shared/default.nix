{...}: {
  imports = [
    ../../shared.nix
    ../../desktop.nix
    ./nix.nix
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
