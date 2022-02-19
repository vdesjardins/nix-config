{ pkgs, ... }: {
  homebrew = {
    enable = true;
    brewPrefix =
      if pkgs.system == "aarch64-darwin" then "/opt/homebrew/bin" else "/usr/local/bin";
    casks = [ "karabiner-elements" "raycast" "google-chrome" "Rectangle" "docker" "utm" ];
  };
}
