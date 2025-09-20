{...}: {
  nix = {
    distributedBuilds = true;

    linux-builder.enable = true;

    settings = {
      trusted-users = ["@admin"];
    };
  };
}
