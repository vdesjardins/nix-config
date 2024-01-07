{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.openssl;
in {
  options.programs.openssl = {
    enable = mkEnableOption "openssl";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [openssl];

    xdg.configFile."zsh/functions/tls-server-dump".source =
      mkIf config.programs.zsh.enable ./zsh/functions/tls-server-dump;
    xdg.configFile."zsh/functions/tls-decode-bundle".source =
      mkIf config.programs.zsh.enable ./zsh/functions/tls-decode-bundle;
  };
}
