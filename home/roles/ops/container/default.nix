{ pkgs, ... }: {
  programs.myNeovim.lang.docker = true;

  home.packages = with pkgs; [
    buildkit
    dive
    podman
    skopeo
    unstable.colima
  ] ++ lib.optionals stdenv.isLinux [
    cntr # container debugging tool
    unstable.nerdctl # docker compatible containerd cli
  ];
}
