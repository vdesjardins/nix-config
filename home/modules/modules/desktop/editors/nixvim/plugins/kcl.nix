{my-packages, ...}: {
  programs.nixvim = {
    extraPlugins = [
      my-packages.vimPlugins-kcl
    ];

    extraConfigLua = ''
      require('lspconfig').kcl.setup({})
    '';
  };
}
