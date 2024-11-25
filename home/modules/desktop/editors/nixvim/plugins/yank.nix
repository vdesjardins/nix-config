{
  programs.nixvim.autoCmd = [
    {
      event = [
        "TextYankPost"
      ];
      pattern = [
        "*"
      ];
      command = "lua vim.highlight.on_yank { higroup='IncSearch', timeout=500 }";
    }
  ];
}
