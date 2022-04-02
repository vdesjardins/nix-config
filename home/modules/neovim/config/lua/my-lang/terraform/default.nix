{ pkgs, ... }:
{
  packages = with pkgs; [
    unstable.terraform-ls
  ];
}
