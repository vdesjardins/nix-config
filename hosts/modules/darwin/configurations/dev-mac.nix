{...}: let
  username = "vince";
  hostname = "dev-mac";
in {
  system.stateVersion = 5;

  homebrew.casks = [
    "Rectangle"
    "alt-tab"
    "bitwarden"
    "docker"
    "firefox"
    "flameshot"
    "google-chrome"
    "google-drive"
    "maccy"
    "middleclick"
    "stats"
    "ukelele"
    "vmware-fusion"
    "ghostty"
  ];

  networking.hostName = hostname;
  modules.services.spotifyd.enable = true;
  modules.services.spotifyd.deviceName = hostname;

  imports = [
    ../../tailscale.nix
    ../shared
    ../shared/spotifyd.nix
    (../users + "/${username}.nix")
  ];

  users.knownUsers = [username];
}
