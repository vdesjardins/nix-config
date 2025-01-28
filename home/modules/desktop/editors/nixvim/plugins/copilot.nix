{pkgs, ...}: {
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = true;

      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.blink-copilot
    ];

    extraConfigLua = ''
      require("blink-copilot").setup({})
    '';
  };
}
