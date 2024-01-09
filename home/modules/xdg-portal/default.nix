{pkgs, ...}: {
  xdg.portal = {
    config.common.default = ["wlr" "gtk"];
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
