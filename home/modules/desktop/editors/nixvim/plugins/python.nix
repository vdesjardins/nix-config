{
  programs.nixvim.plugins = {
    lsp.servers = {
      pyright.enable = true;
      ruff.enable = true;
    };

    dap-python.enable = true;
  };
}
