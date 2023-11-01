{pkgs, ...}: {
  packages = with pkgs; [
    unstable.regols
  ];
}
