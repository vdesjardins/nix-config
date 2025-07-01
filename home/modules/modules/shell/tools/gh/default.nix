{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.gh;
in {
  options.modules.shell.tools.gh = {
    enable = mkEnableOption "github cli";
  };

  config = mkIf cfg.enable {
    # TODO: a ~/.config/gh/hosts.yml file need to be created with credentials
    # ex.:
    # github.com:
    #   user: vdesjardins
    #   oauth_token: <REDACTED>
    programs.gh = {
      inherit (cfg) enable;

      package = pkgs.gitAndTools.gh;

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
          pv = "pr view -c";
          pu = "pr view --json url";
          pd = "pr diff";
          rw = "repo view --web";
          ru = "repo view --json url -q .url";
          rl = "run list";
          rv = "run view";
        };
      };

      extensions = with pkgs; [
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
      ghrc = "gh ru | pbcopy";
      ghfrl = "gh run view --log $(gh run list --status failure --json 'databaseId,createdAt' --jq 'sort_by(.createdAt) | last | .databaseId')";
      ghfr = "gh run view $(gh run list --status failure --json 'databaseId,createdAt' --jq 'sort_by(.createdAt) | last | .databaseId')";
    };
  };
}
