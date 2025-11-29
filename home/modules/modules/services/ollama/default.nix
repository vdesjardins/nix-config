{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;

  cfg = config.modules.services.ollama;
in {
  options.modules.services.ollama = {
    enable = lib.mkEnableOption "Server for local large language models";

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        The host address which the ollama server HTTP interface listens to.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 11434;
      description = ''
        Which port the ollama server listens to.
      '';
    };

    acceleration = mkOption {
      type = types.nullOr (
        types.enum [
          null
          false
          "rocm"
          "cuda"
          "vulkan"
        ]
      );
      default = null;
      example = "rocm";
      description = ''
        What interface to use for hardware acceleration.

        - `null`: default behavior
          - if `nixpkgs.config.rocmSupport` is enabled, uses `"rocm"`
          - if `nixpkgs.config.cudaSupport` is enabled, uses `"cuda"`
          - otherwise defaults to `false`
        - `false`: disable GPU, only use CPU
        - `"rocm"`: supported by most modern AMD GPUs
          - may require overriding gpu type with `services.ollama.rocmOverrideGfx`
            if rocm doesn't detect your AMD gpu
        - `"cuda"`: supported by most modern NVIDIA GPUs
        - `"vulkan"`: supported by older GPUs
      '';
    };

    environmentVariables = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        OLLAMA_LLM_LIBRARY = "cpu";
        HIP_VISIBLE_DEVICES = "0,1";
      };
      description = ''
        Set arbitrary environment variables for the ollama service.

        Be aware that these are only seen by the ollama server (systemd service),
        not normal invocations like `ollama run`.
        Since `ollama run` is mostly a shell around the ollama server, this is usually sufficient.
      '';
    };

    package = lib.mkPackageOption pkgs "ollama" {};
  };

  config =
    lib.mkIf cfg.enable
    {
      services.ollama = {
        enable = true;

        inherit (cfg) host port acceleration package environmentVariables;
      };

      home.packages = with pkgs; [gollama];
    };
}
