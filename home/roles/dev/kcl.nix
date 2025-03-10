{pkgs, ...}: {
  home.packages = with pkgs; [
    kcl
    kcl-language-server
  ];
}
