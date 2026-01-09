{
  config,
  lib,
  my-packages,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkPackageOption mkIf getExe;
  inherit (lib.attrsets) mapAttrs';

  cfg = config.modules.mcp.utcp-code-mode;

  codeModeConfig = {
    load_variables_from = [
      {
        variable_loader_type = "dotenv";
        env_file_path = ".env";
      }
    ];
    post_processing = [
      {
        tool_post_processor_type = "filter_dict";
        only_include_keys = ["name" "description"];
        only_include_tools = ["openlibrary.*"];
      }
    ];
    tool_repository = {
      tool_repository_type = "in_memory";
    };
    tool_search_strategy = {
      tool_search_strategy_type = "tag_and_description_word_match";
    };
  };

  codeModeConfig.manual_call_templates = [
    {
      name = "mcp";
      call_template_type = "mcp";
      config = {
        inherit (cfg) mcpServers;
      };
    }
    {
      name = "openlibrary";
      call_template_type = "http";
      http_method = "GET";
      url = "https://openlibrary.org/static/openapi.json";
      content_type = "application/json";
    }
  ];

  configFile = (pkgs.formats.json {}).generate "utcp_config.json" codeModeConfig;
in {
  options.modules.mcp.utcp-code-mode = {
    enable = mkEnableOption "utcp code-mode mcp server";

    package = mkPackageOption my-packages "utcp-code-mode-mcp" {};

    mcpServers = mkOption {
      default = {};
      description = "MCP servers to enable utcp-code-mode for.";
    };

    sessionVariables = mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Session variables to set for utcp-code-mode.";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."utcp-code-mode/config.yaml".source = configFile;

    modules.desktop.editors.nixvim.ai.mcpServers.code-mode = {
      command = getExe cfg.package;
      env = {
        UTCP_CONFIG_FILE = configFile;
      };
    };

    programs.opencode.settings.mcp.utcp-code-mode = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package)];
      environment = {
        UTCP_CONFIG_FILE = configFile;
      };
    };

    modules.shell.tools.github-copilot-cli.settings.mcpServers.utcp-code-mode = {
      type = "local";
      command = getExe cfg.package;
      tools = ["*"];
      args = [];
      environment = {
        UTCP_CONFIG_FILE = configFile;
      };
    };

    home.sessionVariables =
      mapAttrs' (name: value: {
        name = "mcp_${name}";
        inherit value;
      })
      cfg.sessionVariables;
  };
}
