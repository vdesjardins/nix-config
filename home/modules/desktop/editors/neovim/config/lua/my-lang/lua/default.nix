{pkgs, ...}: {
  packages = with pkgs; [
    stylua
    selene
    sumneko-lua-language-server
  ];
}
