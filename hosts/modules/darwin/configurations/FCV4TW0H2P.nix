{...}: let
  username = "inf10906";
  hostname = "FCV4TW0H2P";
in {
  system.stateVersion = 5;

  system.primaryUser = username;

  homebrew.casks = [
    "Rectangle"
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

  nix.enable = false;
}
