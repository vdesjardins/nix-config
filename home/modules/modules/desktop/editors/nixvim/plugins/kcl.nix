{my-packages, ...}: {
  programs.nixvim = {
    extraPlugins = [
      my-packages.vimPlugins-kcl
    ];

    extraConfigLua = ''
      -- Setup KCL LSP using the new vim.lsp.config API (neovim 0.11+)
      -- Replaces deprecated require('lspconfig') framework
      -- Uses KCL LSP v0.12.3 from GitHub main branch
      vim.lsp.config.kcl = {
        cmd = { '${my-packages.kcl-language-server}/bin/kcl-language-server' },
        filetypes = { 'kcl' },
        root_markers = { '.git', '.jj', 'kcl.mod' },
        settings = {},
      }

      vim.lsp.enable({ 'kcl' })
    '';
  };
}
