{pkgs, ...}: {
  packages = with pkgs; [
    glow
    unstable.gh-markdown-preview
  ];
}
