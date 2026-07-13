{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      # Hyprland 0.55 prefers Lua configuration by default. Pin the generated
      # Home Manager Hyprlang file so a stale/default hyprland.lua is not loaded.
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd '${pkgs.hyprland}/bin/start-hyprland --config ~/.config/hypr/hyprland.conf'";
    };
  };
}
