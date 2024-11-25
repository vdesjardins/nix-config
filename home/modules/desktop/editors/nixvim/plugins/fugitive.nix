{
  programs.nixvim = {
    plugins.fugitive = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>sP";
        action = "<cmd>Git pull<cr>";
        options.desc = "Pull (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sa";
        action.__raw =
          # lua
          ''
            function()
                local f = vim.api.nvim_buf_get_name(0)
                vim.cmd("Git add " .. f)
            end
          '';
        options.desc = "Add (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sc";
        action = "<cmd>Git commit<cr>";
        options.desc = "Commit (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>Gdiffsplit<cr>";
        options.desc = "Diff (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>se";
        action = "<cmd>Gedit<cr>";
        options.desc = "Edit (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sf";
        action = "<cmd>diffget //2<cr>";
        options.desc = "Diff Get Left (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sj";
        action = "<cmd>diffget //3<cr>";
        options.desc = "Diff Get Right (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sl";
        action = "<cmd>Gclog<cr>";
        options.desc = "Log (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = "<cmd>Git push<cr>";
        options.desc = "Push (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sr";
        action = "<cmd>Gread<cr>";
        options.desc = "Read (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>Git<cr>";
        options.desc = "Status (fugitive)";
      }
      {
        mode = "n";
        key = "<leader>sw";
        action = "<cmd>Gwrite<cr>";
        options.desc = "Write (fugitive)";
      }
    ];
  };
}
