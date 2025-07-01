{pkgs, ...}: {
  programs.nixvim.plugins = {
    lsp.servers.bashls = {
      enable = true;

      filetypes = ["sh" "zsh"];
    };

    none-ls = {
      sources = {
        formatting.shfmt.enable = true;
        formatting.shellharden.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    shellcheck
    shellharden
    shfmt
    nodePackages.bash-language-server
  ];
}
