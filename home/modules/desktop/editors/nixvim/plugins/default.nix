{
  # TODO: check if possible to load images (hologram?)
  # TODO: neorg or similar to replace logseq

  imports = [
    ./startify.nix

    # moves
    ./telescope.nix
    ./flash.nix
    ./which-key.nix
    ./rsi.nix

    ./buffers.nix
    ./dressing.nix
    ./lualine.nix
    ./treesitter.nix

    ./fugitive.nix
    ./git-conflict.nix

    ./comment.nix

    ./autopairs.nix
    ./nvim-surround.nix
    ./rainbow-delimiters.nix
    ./text-case.nix
    ./treesj.nix

    ./guess-indent.nix
    ./indent-blankline.nix

    ./noice.nix
    ./trouble.nix
    ./bqf.nix
    ./project.nix
    ./harpoon.nix
    ./easypick.nix
    ./diagnostic.nix

    # snippets
    ./luasnip.nix
    ./friendly-snippets.nix

    # clipboard
    # ./yanky.nix # TODO: cause collision with other plugins like smart-splits
    ./yank.nix # # TODO: probably not required if yanky is added

    # lsp
    ./cmp.nix
    ./lsp.nix
    ./lsp-format.nix
    ./lsp-signature.nix
    ./none-ls.nix
    ./dap.nix

    # languages
    ./nix.nix
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

    # nav
    ./smart-splits.nix

    # terminal
    ./terminal.nix

    # AI
    ./avante.nix
    ./copilot.nix

    # nvim-ts-autotag
    # vim-bookmark
    # mini-icons
    # nvim-img-clip
    # vim-better-whitespace
    # vim-endwise
    # vim-grepper
    # nvim-surround
    # vim-snippets

    # vim-clue
  ];

  programs.nixvim = {
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "storm";
      };
    };

    plugins = {
      web-devicons.enable = true;

      gitsigns = {
        enable = true;
      };

      nvim-autopairs.enable = true;

      notify.enable = true;
      nui.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };

      oil.enable = true;

      trim = {
        enable = true;
        settings = {
          highlight = true;
          ft_blocklist = [
            "checkhealth"
            "floaterm"
            "lspinfo"
            "TelescopePrompt"
          ];
        };
      };
    };
  };
}
