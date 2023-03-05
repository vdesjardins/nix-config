{pkgs, ...}: {
  programs.gpg = {
    enable = true;

    # ref: https://github.com/NixOS/nixpkgs/issues/155629
    scdaemonSettings = pkgs.lib.optionals pkgs.hostPlatform.isDarwin {
      disable-ccid = true;
    };

    publicKeys = [
      {
        source = ./pubkeys.txt;
      }
    ];
  };
}
