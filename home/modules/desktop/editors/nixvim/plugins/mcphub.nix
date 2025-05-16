{
  config,
  pkgs,
  ...
}: let
  inherit (config.modules.home) configDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  home.packages = with pkgs; [mcp-hub];

  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      mcphub
    ];

    extraConfigLua = ''
      require("mcphub").setup({
        auto_approve = true,
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
    "mcphub/servers.json".source =
      mkOutOfStoreSymlink "${configDirectory}/desktop/editors/nixvim/plugins/mcphub/servers.json";
  };
}
