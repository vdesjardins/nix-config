{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      kcl
    ];

    extraConfigLua = ''
      require('lspconfig').kcl.setup({})
    '';
  };
}
