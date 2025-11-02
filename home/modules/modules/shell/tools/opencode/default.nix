{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.opencode;
in {
  options.modules.shell.tools.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      settings = {
        plugin = [
          "${my-packages.opencode-skills}/lib/node_modules/opencode-skills/dist/index.js"
        ];
      };
    };
  };
}
