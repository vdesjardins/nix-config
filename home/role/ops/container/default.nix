{ pkgs, ... }: {
  programs.myNeovim.lang.docker = true;

  home.packages = with pkgs; [
    buildkit
    dive
    podman
    skopeo
  ] ++ lib.optionals stdenv.isLinux [
    cntr # container debugging tool
  ];
}
