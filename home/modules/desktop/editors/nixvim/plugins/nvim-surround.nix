{
  programs.nixvim.plugins.nvim-surround = {
    enable = true;

    # conflict with Flash. Going for 'c' as for 'circling'
    # TODO: why those keymaps doesn't appear in which-key?
    settings = {
      keymaps = {
        insert = "<C-g>c";
        insert_line = "<C-g>C";
        normal = "yc";
        normal_cur = "ycs";
        normal_line = "yC";
        normal_cur_line = "yCS";
        visual = "C";
        visual_line = "gC";
        delete = "dc";
        change = "cc";
        change_line = "cC";
      };
    };
  };
}
