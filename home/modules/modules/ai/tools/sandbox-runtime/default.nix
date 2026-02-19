{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrs;

  cfg = config.modules.ai.tools.sandbox-runtime;

  defaultSettings = {
    network = {
      allowedDomains = [
        "github.com"
        "*.github.com"
        "lfs.github.com"
        "api.github.com"
        "mcp.grep.app"
      ];
      deniedDomains = [];
      allowUnixSockets = [
        "/nix/var/nix/daemon-socket/socket"
      ];
    };
    filesystem = {
      denyRead = [];
      allowWrite = ["."];
      denyWrite = [];
    };
  };

  mergedSettings = lib.recursiveUpdate defaultSettings cfg.settings;
in {
  options.modules.ai.tools.sandbox-runtime = {
    enable = mkEnableOption "sandbox-runtime for AI agent execution environments";

    settings = mkOption {
      type = attrs;
      default = {};
      description = ''
        Additional srt settings to deep-merge over the defaults.
        User-provided values take priority; arrays are replaced (not concatenated).
        See https://github.com/anthropic-experimental/sandbox-runtime for schema.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.sandbox-runtime
    ];

    home.file.".srt-settings.json".text = builtins.toJSON mergedSettings;
  };
}
