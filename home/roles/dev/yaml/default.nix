{pkgs, ...}: {
  programs.nvim.lang.yaml = true;

  home.packages = with pkgs; [
    yamllint
  ];

  imports = [
    ../../../programs/yamllint
  ];
}
