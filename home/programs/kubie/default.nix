{pkgs, ...}: {
  home.packages = with pkgs; [kubie];

  programs.zsh.shellAliases = {
    kbn = "kubie ns";
    kbc = "kubie ctx";
    kbe = "kubie exec";
  };
}
