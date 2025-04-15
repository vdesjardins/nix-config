{pkgs, ...}: {
  hardware.graphics = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
}
