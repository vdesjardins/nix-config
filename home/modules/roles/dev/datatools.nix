{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.datatools;
in {
  options.roles.dev.datatools = {
    enable = mkEnableOption "data tools (json, yaml, markdown, rego)";
    json.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable JSON tools (jq, jiq, gron, fixjson)";
    };
    yaml.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable YAML tools (yamllint)";
    };
    markdown.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Markdown tools (glow, rumdl)";
    };
    rego.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Rego tools (conftest)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      (lib.optional cfg.json.enable nodePackages.fixjson)
      ++ (lib.optional cfg.json.enable jiq)
      ++ (lib.optional cfg.json.enable jq)
      ++ (lib.optional cfg.json.enable gron)
      ++ (lib.optional cfg.yaml.enable yamllint)
      ++ (lib.optional cfg.markdown.enable glow)
      ++ (lib.optional cfg.markdown.enable rumdl)
      ++ (lib.optional cfg.rego.enable conftest);

    modules.dev.yamllint.enable = cfg.yaml.enable;
  };
}
