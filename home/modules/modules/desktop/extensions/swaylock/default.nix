{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.extensions.swaylock;

  lockScreen = pkgs.writeShellScriptBin "lock-screen" ''
    wallpaper="$(${pkgs.findutils}/bin/find -L ${config.home.homeDirectory}/Pictures/Wallpapers -maxdepth 1 -type f | ${pkgs.coreutils}/bin/shuf -n 1)"

    if [[ -z "$wallpaper" ]]; then
      exec ${pkgs.swaylock}/bin/swaylock -f
    fi

    dimmed="$(${pkgs.coreutils}/bin/mktemp --suffix=.png)"
    trap '${pkgs.coreutils}/bin/rm -f "$dimmed"' EXIT
    ${pkgs.imagemagick}/bin/magick "$wallpaper" -fill "#1a1b26" -colorize 55 "$dimmed"
    ${pkgs.swaylock}/bin/swaylock -f --image "$dimmed"
  '';
in {
  options.modules.desktop.extensions.swaylock = {
    enable = mkEnableOption "swaylock";

    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [lockScreen];

    programs.swaylock = {
      inherit (cfg) enable;

      package = pkgs.swaylock;

      settings = {
        inherit (cfg) font;

        ignore-empty-password = true;
        disable-caps-lock-text = true;
        color = "1a1b26";

        text-ver-color = "00000000";
        text-wrong-color = "00000000";
        text-clear-color = "00000000";
        inside-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        ring-color = "00000000";
        ring-ver-color = "00000000";
        ring-wrong-color = "00000000";
        ring-clear-color = "00000000";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-ver-color = "00000000";
        key-hl-color = "00000000";
        bs-hl-color = "00000000";
        caps-lock-bs-hl-color = "00000000";
        caps-lock-key-hl-color = "00000000";
        separator-color = "00000000";

        scaling = "fill";
        indicator = true;
        clock = true;
        timestr = "%I:%M %p";
        datestr = "%A, %d %B";
        indicator-x-position = "250";
        indicator-y-position = "975";
        indicator-radius = "200";
        font-size = "100";
        text-color = "c0caf5";
      };
    };
  };
}
