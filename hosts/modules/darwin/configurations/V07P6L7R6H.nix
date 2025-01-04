{...}: let
  username = "inf10906";
  hostname = "V07P6L7R6H";
in {
  system.stateVersion = 5;
  homebrew.casks = [
    "Rectangle"
    "alt-tab"
    "firefox"
    "flameshot"
    "google-chrome"
    "google-drive"
    "maccy"
    "middleclick"
    "stats"
    "logseq"
  ];

  networking.hostName = hostname;

  imports = [
    ../shared
    (../users + "/${username}.nix")
  ];

  users.knownUsers = [username];
}
