{
  programs.nixvim.plugins = {
    lsp.servers.gopls = {
      enable = true;

      settings = {
        gopls = {
          analyses = {
            unusedparams = true;
          };
          staticcheck = true;
          gofumpt = true;
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariableTypes = true;
          };
        };
      };
    };

    dap.extensions.dap-go.enable = true;
  };
}
