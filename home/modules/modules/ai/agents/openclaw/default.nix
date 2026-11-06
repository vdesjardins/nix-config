{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.agents.openclaw;
in {
  options.modules.ai.agents.openclaw = {
    enable = mkEnableOption "OpenClaw AI assistant";

    gateway = {
      enable = mkEnableOption "OpenClaw gateway user service (Linux/systemd)";

      port = mkOption {
        type = types.port;
        default = 18789;
        description = "Loopback port for the OpenClaw gateway";
      };

      tailscale = {
        enable = mkEnableOption "tailnet-only HTTPS through a named Tailscale Service (never Funnel)";
        serviceName = mkOption {
          type = types.strMatching "[a-z0-9][a-z0-9-]*";
          default = "openclaw";
          description = "Named Tailscale Service (requires a tagged and approved host)";
        };
      };

      environmentFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "%h/.config/openclaw/gateway.env";
        description = ''
          Runtime environment file for secrets such as OPENCLAW_GATEWAY_TOKEN
          and provider API keys. Keep this file outside the Nix store.
        '';
      };
    };

    package = mkOption {
      type = types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.openclaw.overrideAttrs (old: {
        postInstall =
          (old.postInstall or "")
          + ''
            # Compiled extension directories are one level deeper than their
            # sources, so pnpm's copied relative links no longer reach the store.
            root="$out/lib/openclaw"
            for extension in extensions/diffs dist/extensions/diffs dist-runtime/extensions/diffs; do
              for dependency in '@pierre/diffs' '@shikijs/langs'; do
                source="$root/extensions/diffs/node_modules/$dependency"
                target=$(readlink -f "$source")
                test -f "$target/package.json"
                if [ "$extension" != extensions/diffs ]; then
                  mkdir -p "$root/$extension/node_modules/$(dirname "$dependency")"
                  ln -sfn "$target" "$root/$extension/node_modules/$dependency"
                fi
              done
            done
          '';
      });
      description = "The OpenClaw package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    assertions = [
      {
        assertion = !cfg.gateway.enable || pkgs.stdenv.hostPlatform.isLinux;
        message = "The OpenClaw gateway service currently requires Linux/systemd.";
      }
    ];

    systemd.user.services.openclaw-tailscale = mkIf (cfg.gateway.enable && cfg.gateway.tailscale.enable && pkgs.stdenv.hostPlatform.isLinux) {
      Unit = {
        Description = "Named tailnet-only HTTPS service for OpenClaw";
        After = ["openclaw-gateway.service"];
        Requires = ["openclaw-gateway.service"];
        PartOf = ["openclaw-gateway.service"];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe pkgs.tailscale} serve --yes --bg --service=svc:${cfg.gateway.tailscale.serviceName} --https=443 http://127.0.0.1:${toString cfg.gateway.port}";
        ExecStop = "${lib.getExe pkgs.tailscale} serve clear svc:${cfg.gateway.tailscale.serviceName}";
        Restart = "on-failure";
        RestartSec = 10;
      };
      Install.WantedBy = ["default.target"];
    };

    systemd.user.services.openclaw-gateway = mkIf cfg.gateway.enable {
      Unit = {
        Description = "OpenClaw gateway";
        After = ["network-online.target"];
      };
      Service = {
        ExecStart = lib.escapeShellArgs [
          (lib.getExe cfg.package)
          "gateway"
          "run"
          "--allow-unconfigured"
          "--bind"
          "loopback"
          "--auth"
          "token"
          "--port"
          (toString cfg.gateway.port)
          "--tailscale"
          "off"
        ];
        Environment = ["PATH=${lib.makeBinPath [pkgs.tailscale pkgs.coreutils pkgs.nodejs]}:%h/.nix-profile/bin:/run/current-system/sw/bin"];
        EnvironmentFile = lib.optional (cfg.gateway.environmentFile != null) cfg.gateway.environmentFile;
        Restart = "on-failure";
        RestartSec = 10;
        UMask = "0077";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
