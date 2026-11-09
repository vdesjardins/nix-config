{pkgs, ...}: {
  homebrew = {
    enable = true;
    taps = ["anomalyco/tap"];
    casks = ["anomalyco/tap/hex"];
    brewPrefix =
      if pkgs.stdenv.hostPlatform.system == "aarch64-darwin"
      then "/opt/homebrew/bin"
      else "/usr/local/bin";
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
