{pkgs, ...}: {
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = true;

      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
    };

    plugins.blink-copilot = {
      enable = true;
    };
  };
}
