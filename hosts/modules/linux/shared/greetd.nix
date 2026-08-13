{
  config,
  pkgs,
  ...
}: {
  programs = {
    hyprland.enable = true;
    niri.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --user-menu --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --cmd '${pkgs.hyprland}/bin/start-hyprland --config ~/.config/hypr/hyprland.conf'";
  };
}
