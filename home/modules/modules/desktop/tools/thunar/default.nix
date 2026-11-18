{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.tools.thunar;
in {
  options.modules.desktop.tools.thunar.enable = lib.mkEnableOption "Thunar file manager";

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "Thunar" pkgs lib.platforms.linux)
    ];

    home.packages = [pkgs.thunar];

    xfconf.settings.thunar = {
      default-view = "ThunarDetailsView";
      last-view = "ThunarDetailsView";
      last-show-hidden = true;
      misc-single-click = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications."inode/directory" = ["thunar.desktop"];
    };
  };
}
