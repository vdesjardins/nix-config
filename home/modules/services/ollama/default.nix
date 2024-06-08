{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  cfg = config.modules.services.ollama;
  ollamaPackage = cfg.package.override {
    inherit (cfg) acceleration;
  };
in {
  options.modules.services.ollama = {
    enable = lib.mkEnableOption "Server for local large language models";

    listenAddress = lib.mkOption {
      type = types.str;
      default = "127.0.0.1:11434";
      description = ''
        Specifies the bind address on which the ollama server HTTP interface listens.
      '';
    };

    acceleration = lib.mkOption {
      type = types.nullOr (types.enum ["rocm" "cuda"]);
      default = null;
      example = "rocm";
      description = ''
        Specifies the interface to use for hardware acceleration.

        - `rocm`: supported by modern AMD GPUs
        - `cuda`: supported by modern NVIDIA GPUs
      '';
    };

    package = lib.mkPackageOption pkgs "ollama" {};
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [ollamaPackage];
    }
    (lib.mkIf pkgs.stdenv.isLinux {
      systemd.user.services.ollama = {
        Unit = {
          Description = "Server for local large language models";
          After = ["network.target"];
        };

        Service = {
          ExecStart = "${lib.getExe ollamaPackage} serve";
          Environment = [
            "OLLAMA_HOST=${cfg.listenAddress}"
          ];
        };

        Install = {WantedBy = ["default.target"];};
      };
    })

    (lib.mkIf pkgs.stdenv.isDarwin {
      launchd.agents.ollama = {
        enable = true;
        config = {
          ProgramArguments = ["${lib.getExe ollamaPackage}" "serve"];
          EnvironmentVariables.OLLAMA_HOST = "${cfg.listenAddress}";
          ProcessType = "Adaptive";
          RunAtLoad = true;
          StandardOutPath = "${config.xdg.stateHome}/ollama/ollama.log";
          StandardErrorPath = "${config.xdg.stateHome}/ollama/ollama.log";
        };
      };
    })
  ]);
}
