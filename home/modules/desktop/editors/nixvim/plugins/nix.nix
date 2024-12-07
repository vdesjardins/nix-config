{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      lsp.servers.nixd = {
        enable = true;
        settings = {
          formatting = {
            command = ["${pkgs.alejandra}/bin/alejandra"];
          };
        };
      };

      none-ls = {
        sources = {
          code_actions.statix.enable = true;
          diagnostics.statix.enable = true;
        };
      };
    };
    extraPackages = with pkgs; [
      alejandra
      statix
    ];
  };
}
