{...}: {
  imports = [../shared.nix];

  nix.settings = {trusted-users = ["@admin"];};

  services = {nix-daemon.enable = true;};

  nix.configureBuildUsers = true;

  system.stateVersion = 4;
}
