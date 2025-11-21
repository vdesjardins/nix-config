{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd hyprland
      '';
    };
  };

  environment.etc."greetd/environments".text = ''
    hyprland
    sway
    zsh
  '';
}
