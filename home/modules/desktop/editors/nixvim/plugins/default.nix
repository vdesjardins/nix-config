{
  imports = [
    ./img-clip.nix

    ./auto-save.nix
    ./auto-session.nix

    # moves
    ./flash.nix
    ./which-key.nix
    ./rsi.nix

    ./buffers.nix
    ./dressing.nix
    ./lualine.nix
    ./treesitter.nix

    ./fugitive.nix
    ./git-conflict.nix
    ./neogit.nix

    ./comment.nix

    ./autopairs.nix
    ./rainbow-delimiters.nix
    ./text-case.nix
    ./treesj.nix
    ./ts-autotag.nix
    ./matchup.nix

    ./guess-indent.nix

    ./noice.nix
    ./trouble.nix
    ./bqf.nix
    ./project.nix
    ./grapple.nix
    ./exec.nix
    ./diagnostic.nix
    ./snacks.nix
    ./mini.nix
    ./dropbar.nix
    ./oil.nix
    ./helpview.nix
    ./nvim-surround.nix

    # snippets
    ./luasnip.nix
    ./friendly-snippets.nix

    # clipboard
    ./yanky.nix

    # lsp
    ./blink-cmp.nix
    ./lsp.nix
    ./lsp-signature.nix
    ./none-ls.nix
    ./dap.nix
    ./blink-dictionary.nix

    # languages
    ./nix.nix
    ./lazydev.nix
    ./markdown.nix
    ./terraform.nix
    ./bash.nix
    ./go.nix
    ./python.nix
    ./rust.nix
    ./lua.nix
    ./yaml.nix
    ./json.nix
    ./zig.nix
    ./toml.nix
    ./kcl.nix

    # nav
    ./smart-splits.nix

    # terminal
    ./terminal.nix
    ./rest.nix

    # AI
    ./copilot.nix
    ./codecompanion.nix
    ./mcphub.nix
  ];

  programs.nixvim = {
    plugins = {
      web-devicons.enable = true;

      gitsigns = {
        enable = true;
      };

      nvim-autopairs.enable = true;

      notify.enable = true;
      nui.enable = true;

      colorizer = {
        enable = true;
      };

      trim = {
        enable = true;
        settings = {
          highlight = false;
          ft_blocklist = [
            "checkhealth"
            "floaterm"
            "lspinfo"
          ];
        };
      };
    };
  };
}
