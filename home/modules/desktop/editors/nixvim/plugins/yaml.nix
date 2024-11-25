{
  programs.nixvim = {
    plugins = {
      lsp.servers.yamlls.enable = true;

      schemastore = {
        enable = true;
        yaml = {
          enable = true;
          settings = {
            keyOrdering = false;
            schemaStore = {
              enable = false;
              url = "";
            };
            schemas =
              # lua
              ''
                require("schemastore").yaml.schemas({
                    ignore = {
                        "Deployer Recipe",
                    },
                }
              '';
          };
        };
      };
    };
  };
}
