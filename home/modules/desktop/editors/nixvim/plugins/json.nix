{
  programs.nixvim = {
    plugins = {
      lsp.servers.jsonls = {
        enable = true;
        settings = {
          validate = {
            enable = true;
          };
        };
      };

      schemastore = {
        enable = true;
        json = {
          enable = true;
        };
      };
    };
  };
}
