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
    };
  };
}
