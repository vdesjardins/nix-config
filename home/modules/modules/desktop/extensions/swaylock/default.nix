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
  swaylock = pkgs.swaylock-effects;

  lockScreen = pkgs.writeShellScriptBin "lock-screen" ''
    wallpaper="$(${pkgs.findutils}/bin/find -L ${config.home.homeDirectory}/Pictures/Wallpapers -maxdepth 1 -type f | ${pkgs.coreutils}/bin/shuf -n 1)"

    if [[ -z "$wallpaper" ]]; then
      ${swaylock}/bin/swaylock -f || exit $?
    else
      dimmed="$(${pkgs.coreutils}/bin/mktemp --suffix=.png)"
      trap '${pkgs.coreutils}/bin/rm -f "$dimmed"' EXIT
      ${pkgs.imagemagick}/bin/magick "$wallpaper" -fill "#1a1b26" -colorize 55 "$dimmed"
      ${swaylock}/bin/swaylock -f --image "$dimmed" || exit $?
    fi
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

      package = swaylock;

      settings = {
        inherit (cfg) font;

        ignore-empty-password = true;
        disable-caps-lock-text = false;
        show-failed-attempts = true;
        hide-keyboard-layout = true;
        indicator-caps-lock = true;
        color = "1a1b26";

        text-ver-color = "7aa2f7";
        text-wrong-color = "f7768e";
        text-clear-color = "9ece6a";
        text-caps-lock-color = "e0af68";
        inside-color = "1a1b26dd";
        inside-ver-color = "1a1b26dd";
        inside-wrong-color = "1a1b26dd";
        inside-clear-color = "1a1b26dd";
        inside-caps-lock-color = "1a1b26dd";
        ring-color = "565f89";
        ring-ver-color = "7aa2f7";
        ring-wrong-color = "f7768e";
        ring-clear-color = "9ece6a";
        ring-caps-lock-color = "e0af68";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-ver-color = "00000000";
        key-hl-color = "9ece6a";
        bs-hl-color = "e0af68";
        caps-lock-bs-hl-color = "f7768e";
        caps-lock-key-hl-color = "e0af68";
        layout-bg-color = "1a1b26dd";
        layout-border-color = "565f89";
        layout-text-color = "c0caf5";
        separator-color = "00000000";

        scaling = "fill";
        indicator = true;
        clock = true;
        timestr = "%I:%M %p";
        datestr = "%a, %b %d";
        indicator-x-position = "250";
        indicator-y-position = "975";
        indicator-radius = "200";
        font-size = "24";
        text-color = "c0caf5";
      };
    };
  };
}
