{pkgs, ...}: {
  modules.desktop = {
    browsers = {
      firefox.enable = true;
      tridactyl.enable = true;
      bitwarden.enable = true;
    };
    tools = {
      buku.enable = true;
    };
    extensions = {
      rofi-buku.enable = pkgs.stdenv.isLinux;
    };
  };
}
