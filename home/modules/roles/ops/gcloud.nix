{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.gcloud;
in {
  options.roles.ops.gcloud = {
    enable = mkEnableOption "ops.gcloud";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.gcloud.enable = true;
  };
}
