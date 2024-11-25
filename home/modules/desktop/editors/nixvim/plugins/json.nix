{
  programs.nixvim = {
    plugins = {
      lsp.servers.jsonls.enable = true;

      schemastore = {
        enable = true;
        json = {
          enable = true;
        };
      };
    };
  };
}
