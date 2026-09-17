{pkgs, ...}: {
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = true;
      package = pkgs.vimPlugins.copilot-lua.overrideAttrs (_old: {
        src = pkgs.fetchFromGitHub {
          owner = "zbirenbaum";
          repo = "copilot.lua";
          rev = "v3.0.4";
          hash = "sha256-kDQOm7/N6T7wOw1JlkcxNMnQrDE4oTRyGCZkvT8HZQw=";
        };
      });

      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
    };

    plugins.blink-copilot = {
      enable = true;
      package = pkgs.vimPlugins.blink-copilot;
    };
  };
}
