{
  programs.nixvim = {
    plugins = {
      comment = {
        enable = true;
      };

      ts-context-commentstring.enable = true;

      todo-comments = {
        enable = true;
        settings = {
          highlight.pattern = ".*<(KEYWORDS)\\s*";
          search.pattern = "\\b(KEYWORDS)\\b";
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>Tq";
        action = "<cmd>TodoQuickFix<cr>";
        options.desc = "Quickfix";
      }
      {
        mode = "n";
        key = "<leader>Tl";
        action = "<cmd>TodoLocList<cr>";
        options.desc = "Loclist";
      }
      {
        mode = "n";
        key = "<leader>Tt";
        action = "<cmd>Trouble todo<cr>";
        options.desc = "Trouble";
      }
      {
        mode = "n";
        key = "<leader>Ts";
        action = "<cmd>TodoTelescope<cr>";
        options.desc = "Search";
      }
    ];
  };
}
