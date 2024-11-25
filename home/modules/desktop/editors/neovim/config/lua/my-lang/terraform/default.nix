{pkgs, ...}: {
  packages = with pkgs; [
    terraform-ls
  ];
}
