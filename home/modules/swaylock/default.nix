{pkgs, ...}: {
  programs.swaylock = {
    package = pkgs.swaylock-effects;

    settings = {
      ignore-empty-password = true;
      disable-caps-lock-text = true;
      image = "$HOME/.config/wallpapers/wallhaven-wq1wlr.jpg";

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
}
