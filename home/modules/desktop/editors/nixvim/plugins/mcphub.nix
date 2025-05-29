{
  config,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
in {
  home.packages = with pkgs;
    [
      mcp-hub
      nodejs
    ]
    ++ lib.optionals stdenv.isLinux [
      steam-run
    ];

  programs.nixvim = {
    extraPlugins = with pkgs; [
      mcp-hub-nvim
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
    "mcphub/servers.json".source = jsonFormat.generate "servers.json" {
      nativeMCPServers = {
        "neovim" = {
          "disabled_tools" = [];
        };
      };

      mcpServers = {
        puppeteer = {
          command = "steam-run";
          args = [
            "npx"
            "-y"
            "@modelcontextprotocol/server-puppeteer"
          ];
          env = {
            PUPPETEER_LAUNCH_OPTIONS = "{ \"executablePath\": \"${pkgs.firefox}/bin/firefox\", \"args\": [] }";
          };
        };

        mcp-server-git = {
          command = "steam-run";
          args = [
            "${pkgs.uv}/bin/uvx"
            "mcp-server-git"
          ];
        };

        github = {
          command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
          args = [
            "stdio"
            # "--enable-command-logging"
            # "--log-file=${config.home.homeDirectory}/.local/share/github-cmp-server/command.log"
          ];
          env = {
            # passthrough GITHUB_PERSONAL_ACCESS_TOKEN from passage
            GITHUB_PERSONAL_ACCESS_TOKEN = "";
          };
        };
      };
    };
  };

  programs.zsh.initContent = ''
    mkdir -p ~/.local/share/github-cmp-server/
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(${pkgs.passage}/bin/passage apis/github/${config.home.username}/default || 'not-set')"
  '';
}
