{pkgs, ...}: {
  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd sway
      '';
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
    zsh
  '';
}
