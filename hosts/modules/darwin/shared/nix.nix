{...}: {
  services.nix-daemon.enable = true;

  nix = {
    distributedBuilds = true;

    linux-builder.enable = true;

    settings = {
      trusted-users = ["@admin"];
    };
  };
}
