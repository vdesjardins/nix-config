{pkgs, ...}: {
  users.users.admin = {
    isNormalUser = true;
    home = "/home/admin";
    description = "admin user";
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
    group = "admin";
    extraGroups = ["wheel"];
    hashedPassword = "$6$kaRo9lU9dfyHIG9g$oS9AFUCBETz9.qOFVeub7Op0Ksb5rLMlhFB0Q8SeSpg2wYfrZ/IXf5Wwg7HEfuxAZ8YuZtIUEg3UVLmNXeKKk1";
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGEcAQHWUu856GH30Mzf3RuudwYxduwpK/07v4a2YIloCgqR1rU08neMkgv+X7QPpn5OxUHxUrOp4AHcofSQ8Bs= YubiKey #8623089 PIV Slot 9a"
    ];
  };

  users.groups.admin = {};
}
