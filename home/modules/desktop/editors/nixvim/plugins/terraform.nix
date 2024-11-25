{
  programs.nixvim.plugins.lsp.servers = {
    terraformls.enable = true;
    tflint = {
      enable = true;
      rootDir = "require('lspconfig.util').root_pattern('.git', '.tflint.hcl')";
    };
  };
}
