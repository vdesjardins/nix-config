{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      blink-cmp = {
        settings = {
          sources = {
            providers = {
              lazydev = {
                name = "LazyDev";
                module = "lazydev.integrations.blink";
                score_offset = 100;
              };
            };
          };
        };
      };
    };

    extraConfigLua = ''
      require("lazydev").setup({})
    '';

    extraPlugins = with pkgs.vimPlugins; [lazydev-nvim];
  };
}
