{
  config,
  inputs,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};

  cfg = config.modules.desktop.editors.nixvim;
in {
  config = {
    home.packages = [
      inputs.mcp-hub.packages.${pkgs.system}.default
    ];

    programs.nixvim = {
      extraPlugins = [
        inputs.mcp-hub-nvim.packages.${pkgs.system}.default
      ];

      extraConfigLua = ''
        require("mcphub").setup({
          auto_approve = true,
          mcp_request_timeout = 120000,
        })
      '';

      plugins.codecompanion = {
        settings = {
          extensions = {
            mcphub = {
              callback = "mcphub.extensions.codecompanion";
              opts = {
                show_result_in_chat = true; # Show the mcp tool result in the chat buffer
                make_vars = true; # make chat #variables from MCP server resources
                make_slash_commands = true; # make /slash_commands from MCP server prompts
              };
            };
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>cm";
          action = "<cmd>MCPHub<cr>";
          options.desc = "Open (MCPHub)";
        }
      ];
    };

    xdg.configFile = {
      "mcphub/servers.json".source = jsonFormat.generate "servers.json" {
        nativeMCPServers = {
          "neovim" = {
            "disabled_tools" = [];
          };
        };

        inherit (cfg.ai) mcpServers;
      };
    };
  };
}
