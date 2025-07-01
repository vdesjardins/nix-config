{...}: {
  programs.nixvim.plugins = {
    neogit = {
      enable = true;
    };
    diffview = {
      enable = true;
    };
    fzf-lua = {
      enable = true;
    };
  };
}
