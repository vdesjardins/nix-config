{
  programs.nixvim.plugins = {
    lsp.servers.lua_ls = {
      enable = true;

      settings = {
        runtime = {
          version = "LuaJIT";
        };
        hint = {
          enable = true;
          setType = true;
        };
        codeLens = {
          enable = true;
        };
        completion = {
          callSnippet = "Replace";
          postfix = ".";
          showWord = "Disable";
          workspaceWord = false;
        };
        formatter = {enable = false;};
        diagnostics = {
          globals = ["vim"];
        };
      };
    };
  };

  # TODO: lazydev.enable = true;
}
