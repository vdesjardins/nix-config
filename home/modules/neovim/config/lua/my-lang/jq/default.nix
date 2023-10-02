{pkgs, ...}: {
  packages = with pkgs; [
    jq-lsp
  ];
}
