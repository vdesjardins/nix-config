{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<Space>";
      action = "<NOP>";
      options = {
        noremap = true;
        silent = true;
      };
    }

    # better window movement
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {silent = true;};
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<C-\\><C-n><C-w>h";
      options = {silent = true;};
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<C-\\><C-n><C-w>j";
      options = {silent = true;};
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<C-\\><C-n><C-w>k";
      options = {silent = true;};
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<C-\\><C-n><C-w>l";
      options = {silent = true;};
    }
    {
      mode = "t";
      key = "<esc><esc>";
      action = "<C-\\><C-n>";
      options = {silent = true;};
    }

    # resize with arrows
    {
      mode = "n";
      key = "<C-Up>";
      action = "resize -2<CR>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "resize +2<CR>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "vertical resize -2<CR>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "vertical resize +2<CR>";
      options = {silent = true;};
    }

    # Disable arrow keys
    {
      mode = "n";
      key = "<up>";
      action = "<nop>";
    }
    {
      mode = "n";
      key = "<down>";
      action = "<nop>";
    }
    {
      mode = "n";
      key = "<left>";
      action = "<nop>";
    }
    {
      mode = "n";
      key = "<right>";
      action = "<nop>";
    }
    {
      mode = "i";
      key = "<up>";
      action = "<nop>";
    }
    {
      mode = "i";
      key = "<down>";
      action = "<nop>";
    }
    {
      mode = "i";
      key = "<left>";
      action = "<nop>";
    }
    {
      mode = "i";
      key = "<right>";
      action = "<nop>";
    }
  ];
}
