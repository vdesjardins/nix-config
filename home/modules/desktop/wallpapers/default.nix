{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file = {
    "Pictures/Wallpapers/wallhaven.jpg".source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/wq/wallhaven-wq1wlr.jpg";
      hash = "sha256-FcBT/iyL9erjyk+iZ6b1OLJ+lB7N5IUVXWdMxmmUnDk=";
    };
  };
}
