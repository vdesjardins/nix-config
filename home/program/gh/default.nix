{ pkgs, ... }: {
  home.packages = with pkgs; [ gitAndTools.gh ];

  programs.gh = {
    enable = true;

    gitProtocol = "ssh";

    aliases = {
      co = "pr checkout";
      c = "pr create -f";
      m = "pr merge -r -d";
      s = "pr status";
    };
  };

  programs.zsh.initExtraBeforeCompInit = ''
    source <(gh completion -s zsh)
  '';
}
