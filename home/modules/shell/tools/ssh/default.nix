{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.ssh;
in {
  options.modules.shell.tools.ssh = {
    enable = mkEnableOption "secure shell";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      inherit (cfg) enable;

      controlMaster = "auto";
      controlPath = "/tmp/%r@%h:%p";
      hashKnownHosts = false;

      extraOptionOverrides = {
        Include = "local/*_config";
      };

      matchBlocks = {
        # "vm-vince-d" = {
        #   hostname = "vm-vince-d";
        #   user = "vincent.desjardins";
        #   forwardAgent = true;
        #   localForwards = [
        #     {
        #       bind.port = 38000;
        #       host.address = "localhost";
        #       host.port = 8000;
        #     }
        #     {
        #       bind.port = 38001;
        #       host.address = "localhost";
        #       host.port = 8000;
        #     }
        #     {
        #       bind.port = 38002;
        #       host.address = "localhost";
        #       host.port = 8000;
        #     }
        #     {
        #       bind.port = 38080;
        #       host.address = "localhost";
        #       host.port = 8080;
        #     }
        #   ];
        #   dynamicForwards = [{ port = 5000; }];
        # };

        "vince-dev" = {
          hostname = "vince-dev";
          user = "vince";
          forwardAgent = true;
          dynamicForwards = [{port = 5000;}];
        };
      };
    };
  };
}
