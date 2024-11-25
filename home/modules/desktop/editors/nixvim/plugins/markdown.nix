{
  # TODO: see if those are still needed
  # glow
  # markdown-preview
  # vim-markdown-toc
  # vim-render-markdown
  programs.nixvim = {
    plugins = {
      markview = {
        enable = true;
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
        callback =
          /*
          lua
          */
          ''
            function()
              vim.opt_local.conceallevel = 2
            end
          '';
      }
    ];
  };
}
