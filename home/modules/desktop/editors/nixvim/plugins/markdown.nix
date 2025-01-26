{pkgs, ...}: {
  # TODO: see if those are still needed
  # glow
  # markdown-preview
  # vim-markdown-toc
  # vim-render-markdown
  programs.nixvim = {
    plugins = {
      markview = {
        enable = true;
        package = pkgs.vimPlugins.markview-nvim;
      };
    };

    autoCmd = [
      {
        pattern = [
          ".md"
        ];
        event = [
          "BufNewFile"
          "BufRead"
        ];
        callback.__raw = ''
          function()
            vim.opt_local.conceallevel = 2
          end
        '';
      }
    ];
  };
}
