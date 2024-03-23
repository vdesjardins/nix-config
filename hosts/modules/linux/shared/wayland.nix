{
  config,
  pkgs,
  ...
}: {
  environment.sessionVariables = {
    TERM = "xterm-256color";
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
    GDK_BACKEND = "wayland,x11";
    _JAVA_AWS_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
  };
}
