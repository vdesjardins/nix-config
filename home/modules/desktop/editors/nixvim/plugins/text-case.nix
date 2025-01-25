{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      text-case-nvim
    ];
    extraConfigLua = ''
      require('textcase').setup({})
    '';
  };
}
