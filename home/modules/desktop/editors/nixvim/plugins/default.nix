{
  # TODO: check if possible to load images (hologram?)
  # TODO: neorg or similar to replace logseq

  imports = [
    ./avante.nix
    ./buffers.nix
    ./dressing.nix
    ./flash.nix
    ./lualine.nix
    ./noice.nix
    ./startify.nix
    ./telescope.nix
    ./treesitter.nix
    ./which-key.nix
    ./yank.nix
    ./copilot.nix
    ./rsi.nix
    ./fugitive.nix
    ./autopairs.nix
    ./comment.nix
    ./nvim-surround.nix
    ./rainbow-delimiters.nix

    ./guess-indent.nix
    ./indent-blankline.nix

    ./trouble.nix
    ./bqf.nix
    ./project.nix
    ./harpoon.nix
    ./easypick.nix

    # snippets
    ./luasnip.nix
    ./friendly-snippets.nix

    # clipboard
    # ./yanky.nix # TODO: cause collision with other plugins like smart-splits

    # lsp
    ./cmp.nix
    ./lsp.nix
    ./lsp-lines.nix
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

    # nvim-ts-autotag
    # easypick
    # vim-bookmark
    # mini-icons
    # nvim-img-clip
    # vim-better-whitespace
    # vim-endwise
    # vim-grepper
    # nvim-surround
    # vim-text-case
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
