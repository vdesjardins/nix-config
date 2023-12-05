{pkgs, ...}: {
  home.packages = with pkgs.gitAndTools; [
    gh
  ];

  # TODO: a ~/.config/gh/hosts.yml file need to be created with credentials
  # ex.:
  # github.com:
  #   user: vdesjardins
  #   oauth_token: <REDACTED>
  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";

      aliases = {
        co = "pr checkout";
        c = "pr create";
        cf = "pr create -f";
        m = "pr merge -r -d";
        s = "pr status";
        ch = "pr checks";
        pw = "pr view --web";
      };
    };
  };

  programs.zsh.initExtraBeforeCompInit = ''
    source <(gh completion -s zsh)
  '';
}
