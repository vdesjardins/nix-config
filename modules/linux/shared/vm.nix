{pkgs, ...}: {
  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
