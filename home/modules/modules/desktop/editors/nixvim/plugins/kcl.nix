{my-packages, ...}: {
  programs.nixvim = {
    extraPlugins = with my-packages.vimPlugins; [
      kcl
    ];

    extraConfigLua = ''
      require('lspconfig').kcl.setup({})
    '';
  };
}
