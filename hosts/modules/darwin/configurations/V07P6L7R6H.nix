{...}: let
  username = "inf10906";
  hostname = "V07P6L7R6H";
in {
  system.stateVersion = 5;

  system.primaryUser = username;

  ids.gids.nixbld = 30000;

  homebrew.casks = [
    "Rectangle"
    "alt-tab"
    "ghostty"
    "google-chrome"
    "google-drive"
    "insomnia"
    "logseq"
    "maccy"
    "middleclick"
    "stats"
    "wezterm"
    "ghostty"
  ];

  networking.hostName = hostname;

  imports = [
    ../shared
    (../users + "/${username}.nix")
  ];

  users.knownUsers = [username];
}
