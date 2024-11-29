{pkgs, ...}: {
  home.packages = with pkgs; [
    yamllint
  ];

  modules.dev.yamllint.enable = true;
}
