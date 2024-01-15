{...}: let
  username = "vince";
  hostname = "dev-mac";
in {
  homebrew.casks = [
    "Rectangle"
    "alt-tab"
    "bitwarden"
    "brave-browser"
    "docker"
    "firefox"
    "flameshot"
    "google-chrome"
    "google-drive"
    "hammerspoon"
    "maccy"
    "middleclick"
    "stats"
    "vmware-fusion"
  ];

  networking.hostName = hostname;

  imports = [
    ../shared
    (import ../services/spotifyd {device_name = hostname;})
    (../users + "/${username}.nix")
  ];

  users.knownUsers = [username];
}
