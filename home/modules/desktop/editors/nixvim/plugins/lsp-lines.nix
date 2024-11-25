{
  programs.nixvim.plugins.lsp-lines = {
    enable = true;

    luaConfig.post =
      /*
      lua
      */
      ''
        -- Disable virtual_text since it's redundant due to lsp_lines.
        vim.diagnostic.config({
            virtual_text = false,
        })
      '';
  };
}
