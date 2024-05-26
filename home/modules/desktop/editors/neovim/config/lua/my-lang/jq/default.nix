{pkgs, ...}: {
  packages = with pkgs; [
    unstable.jq-lsp
  ];
}
