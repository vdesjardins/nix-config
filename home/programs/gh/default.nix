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
        ch = "pr checks -i 2 --watch";
        pw = "pr view --web";
        pu = "pr view --json url | jq '.url' -Mr | pbcopy";
      };
    };

    extensions = with pkgs.unstable; [
      gh-dash
      gh-eco
      gh-markdown-preview
      # gh-f
      # gh-get-asset
      # gh-look
      # gh-ls
      # gh-notify
      # gh-profile
      # gh-pulls
      # gh-s
      # gh-sql
    ];
  };

  # TODO: support linux
  programs.zsh.shellAliases = {
    ghpc = "gh pu | jq '.url' -Mr | pbcopy";
  };
}
