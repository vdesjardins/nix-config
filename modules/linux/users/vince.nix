{ pkgs, ... }:
{
  users.users.vince = {
    isNormalUser = true;
    home = "/home/vince";
    description = "Vincent Desjardins";
    createHome = true;
    shell = "${pkgs.zsh}/bin/zsh";
    group = "vince";
    extraGroups = [ "wheel" "docker" ];
    hashedPassword = "$6$kaRo9lU9dfyHIG9g$oS9AFUCBETz9.qOFVeub7Op0Ksb5rLMlhFB0Q8SeSpg2wYfrZ/IXf5Wwg7HEfuxAZ8YuZtIUEg3UVLmNXeKKk1";
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgxpgEH5tK2ewNgzYK9YO+bQsjlIARESJLGfLPydNfcYMoLAKeDImFAQT86UNV7Tn36Y4Ms5b+2S8tW/VdY9SXuwkyGBBsxhNiz+or0HJzJ0yFY4JJ/3Iksb8zeZIxktI/Y4sZggk4KOztD2U10O4yQfa/D7Jjockj/pG93hNaZ3EnPMy82ewvFEWNy9R8lCIB6fvMLwObU4lkb/QfeGRgP6XID9Dq9Q7WHMTvrUiK5WVXjIZkP0CdLD89JFNhjN9VqzM4BL5ULKI/5BuwKUnY3Ch5KNg1uvGsfF4ifOZbx2Og73OKWVMS88EANbjlopltk1zFMkJfriYRpXO5dCYl cardno:000608623089" ];
  };

  users.groups.vince = { };
}
