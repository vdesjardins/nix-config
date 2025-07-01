{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader><space>s";
        action = "<cmd>source %s<cr>";
        options.desc = "Source Lua File (Lua)";
      }
      {
        mode = "n";
        key = "<leader><space>x";
        action = ":.lua<cr>";
        options.desc = "Execute Current Line (Lua)";
      }
      {
        mode = "v";
        key = "<leader><space>x";
        action = ":lua<cr>";
        options.desc = "Execute Current Selection (Lua)";
      }
    ];
  };
}
