{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrsOf anything lines package;

  cfg = config.modules.ai.agents.pi;

  hasSettings = cfg.settings != {};
in {
  options.modules.ai.agents.pi = {
    enable = mkEnableOption "pi coding agent";

    package = mkOption {
      type = package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
      description = "pi coding agent package";
    };

    settings = mkOption {
      type = attrsOf anything;
      description = ''
        Global pi settings written to ~/.pi/agent/settings.json.
        See https://pi.dev/docs/settings for all available options.
      '';
      default = {};
      example = {
        defaultProvider = "anthropic";
        defaultThinkingLevel = "medium";
        theme = "dark";
      };
    };

    prompts = mkOption {
      type = attrsOf lines;
      description = ''
        Prompt templates installed to ~/.pi/agent/prompts/<name>.md.
        Each key becomes the template name (invoked with /<name> in pi).
        Content uses the same markdown + frontmatter format as opencode commands:
          ---
          description: What this template does
          ---
          The prompt body...
      '';
      default = {};
      example = {
        review = ''
          ---
          description: Review staged changes
          ---
          Review the staged changes for bugs and security issues.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    home.file = lib.mkMerge [
      (lib.mkIf hasSettings {
        ".pi/agent/settings.json".text = builtins.toJSON cfg.settings;
      })
      (lib.mapAttrs' (
          name: content:
            lib.nameValuePair ".pi/agent/prompts/${name}.md" {text = content;}
        )
        cfg.prompts)
    ];

    programs.zsh.shellAliases = {
      pii = "pi";
      pic = "pi -c";
      pir = "pi --resume";
    };

    modules.shell.nushell.globalAliases = {
      pii = "pi";
      pic = "pi -c";
      pir = "pi --resume";
    };
  };
}
