{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.docker = true;

  home.packages = with pkgs;
    [
      buildkit
      dive
      grype # vulnerability scanner
      podman
      skopeo
      colima
    ]
    ++ lib.optionals stdenv.isLinux [
      cntr # container debugging tool
      nerdctl # docker compatible containerd cli
    ];
}
