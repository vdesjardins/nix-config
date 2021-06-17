{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    # TODO: split them by component in roles/programs
    enableNix = true;
    enableLua = false;
    enableRust = true;
    enableGolang = true;
    enableTerraform = true;
    enableBash = true;
    enableCpp = true;
    enableMake = true;
    enableVim = true;
    enableYaml = true;
    enableDocker = true;
    enableJson = true;
  };
}
