{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.wallpapers;
in {
  options.roles.desktop.wallpapers = {
    enable = mkEnableOption "desktop.wallpapers";
  };

  config = mkIf cfg.enable {
    home.file = {
      "Pictures/Wallpapers/wallhaven-8586my.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/85/wallhaven-8586my.png";
        hash = "sha256-dDYu/P82yhc5OISu2hf5EOG//YPaX5JvALOz6zAddKM=";
      };
      "Pictures/Wallpapers/wallhaven-gpx197.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/gp/wallhaven-gpxl97.jpg";
        hash = "sha256-B2uSM3w/jBBjDhhhuKI8RKN25ni7FnJySKZTtet3Tts=";
      };
      "Pictures/Wallpapers/wallhaven-5g8r55.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/5g/wallhaven-5g8r55.jpg";
        hash = "sha256-ycJZU5zv/VezjWr1KGFU5xm98E+JllGEfE9av48kz3w=";
      };
      "Pictures/Wallpapers/wallhaven-1pj8jg.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/1p/wallhaven-1pj8jg.png";
        hash = "sha256-sM2R+xQ35yN1r+rzp78fnsvKqvmMzT5OL0YYViGMlmw=";
      };
      "Pictures/Wallpapers/wallhaven-7poqw9.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/7p/wallhaven-7poqw9.jpg";
        hash = "sha256-51fpASwIfziX7fwztWgvntg6RHgyBlpebLRXkINXhzw=";
      };
      "Pictures/Wallpapers/wallhaven-wqery6.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/wq/wallhaven-wqery6.jpg";
        hash = "sha256-4Hn12AGPBA8C28k9IQt6FjIcTWvt666nFpSoSp8JpDQ=";
      };
      "Pictures/Wallpapers/wallhaven-y8kzjk.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/y8/wallhaven-y8kzjk.jpg";
        hash = "sha256-CJyQZa2cC2vYnHh7bcfP3XG4hsHCjx+G11jKWNh3SWc=";
      };
      # "Pictures/Wallpapers/wallhaven-3lyq66.png".source = pkgs.fetchurl {
      #   url = "https://w.wallhaven.cc/full/3l/wallhaven-3lyq66.png";
      #   hash = "sha256-wPt1Lxwndl7m0hG3rQCp1hRK5qIDC7n4gqOgY5vNP/E=";
      # };
      "Pictures/Wallpapers/wallhaven-p9kwgj.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/p9/wallhaven-p9kwgj.png";
        hash = "sha256-BWbD0UJ8JqYpxqQ7nuouiAlUwVfkck+18fVSkBw9Zog=";
      };
      "Pictures/Wallpapers/wallhaven-exyrp8.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/ex/wallhaven-exyrp8.jpg";
        hash = "sha256-Fkr3WccZ6GAX1HNduDUs9SMQ4w5L++hvNe7Hw2o/sZU=";
      };
      "Pictures/Wallpapers/wallhaven-9d5x5k.png".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/9d/wallhaven-9d5x5k.png";
        hash = "sha256-/xDwuUbad2gU1wGAWrgLJGXx1enU5zLUBHxHEUuQj/U=";
      };
      "Pictures/Wallpapers/wallhaven-m3exz9.jpg".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/m3/wallhaven-m3exz9.jpg";
        hash = "sha256-ZsW6FzEuoWplO3NmF17QjIB6j5hF72Q6TVZDpbj6gVw=";
      };
      "Pictures/Wallpapers/wallhaven-md9v29.jpg".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/md/wallhaven-md9v29.jpg";
        hash = "sha256-QAN1tQvWJSOs/JtXorBiUee4IiUoLKfUJf0dJJKUBJE=";
      };
      "Pictures/Wallpapers/wallhaven-qz691r.jpg".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/qz/wallhaven-qz691r.jpg";
        hash = "sha256-AKJKMSu0uHNJBn+K1iqgX6SgR1xiozFu++UIdydswrA=";
      };
      "Pictures/Wallpapers/wallhaven-o5oq77.jpg".source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/o5/wallhaven-o5oq77.jpg";
        hash = "sha256-MKcgbPB8V97zbc9faDv5XygA30desktop.wallpapersGx4ad0B73sDkSx4=";
      };
    };
  };
}
