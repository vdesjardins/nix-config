{pkgs, ...}: {
  programs.nvim.lang.docker = true;

  home.packages = with pkgs;
    [
      buildkit
      dive
      grype # vulnerability scanner
      podman
      skopeo
      unstable.colima
    ]
    ++ lib.optionals stdenv.isLinux [
      cntr # container debugging tool
      unstable.nerdctl # docker compatible containerd cli
    ];
}
