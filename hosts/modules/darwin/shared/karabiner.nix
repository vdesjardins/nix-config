{pkgs, ...}: {
  services.karabiner-elements.enable = true;

  environment.systemPackages = with pkgs; [
    karabiner-elements
  ];
}
