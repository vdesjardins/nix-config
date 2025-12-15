{pkgs, ...}: {
  services.karabiner-elements.enable = false;

  environment.systemPackages = with pkgs; [
    karabiner-elements
  ];
}
