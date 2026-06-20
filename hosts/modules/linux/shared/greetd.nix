{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd hyprland";
    };
  };
}
