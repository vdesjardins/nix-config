{
  programs.nixvim.plugins.oil = {
    enable = true;

    settings = {
      float = {
        preview_split = "below";
      };

      keymaps = {
        "<leader>qq" = "actions.close";
        "y." = "actions.copy_entry_path";
      };

      view_options = {
        show_hidden = true;
      };

      win_options = {
        concealcursor = "ncv";
        conceallevel = 3;
        cursorcolumn = false;
        foldcolumn = "0";
        list = false;
        signcolumn = "no";
        spell = false;
        wrap = false;
      };
    };
  };
}
