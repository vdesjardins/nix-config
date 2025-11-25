{
  my-packages,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins = {
      markview = {
        enable = true;

        package = pkgs.vimPlugins.markview-nvim;

        settings = {
          preview = {
            filetypes = ["markdown" "codecompanion"];
            # when this field is set to an empty array, the field in lua is not generated
            ignore_buftypes = ["invalid-buftype"];
          };
        };
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

    extraPlugins = [
      my-packages.vimPlugins-markdown-toc-nvim
    ];
  };
}
