{pkgs, ...}: {
  modules.services.ollama = {
    enable = true;
    acceleration = "rocm";
    package = pkgs.unstable.ollama;
  };

  # needed until support is added for gfx1103
  home.sessionVariables.HSA_OVERRIDE_GFX_VERSION = "gfx1102";
}
