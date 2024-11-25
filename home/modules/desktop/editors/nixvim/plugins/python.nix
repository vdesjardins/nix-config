{
  programs.nixvim.plugins = {
    lsp.servers = {
      pyright.enable = true;
      ruff.enable = true;
    };

    dap.extensions.dap-python.enable = true;
  };
}
