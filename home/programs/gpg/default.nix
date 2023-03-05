{pkgs, ...}: {
  programs.gpg = {
    enable = true;

    # ref: https://github.com/NixOS/nixpkgs/issues/155629
    scdaemonSettings =
      if pkgs.hostPlatform.isDarwin
      then {
        disable-ccid = true;
      }
      else {};

    publicKeys = [
      {
        source = ./pubkeys.txt;
      }
    ];
  };
}
