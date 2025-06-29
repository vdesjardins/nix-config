{
  config,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
in {
  home.packages = with pkgs; [
    mcp-hub
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
        mcp-server-git = {
          command = "${pkgs.mcp-server-git}/bin/mcp-server-git";
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

        context7 = {
          command = "${pkgs.context7}/bin/context7-mcp";
        };

        desktop-commander = {
          command = "${pkgs.desktop-commander-mcp}/bin/desktop-commander";
        };

        serena = {
          command = "${pkgs.serena}/bin/serena-mcp-server";
          args = [
            "--context"
            "ide-assistant"
          ];
          env = {
            XDG_CONFIG_HOME = "${config.xdg.configHome}";
          };
        };
      };
    };
  };

  programs.zsh.initContent = ''
    mkdir -p ~/.local/share/github-cmp-server/
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(${pkgs.passage}/bin/passage apis/github/${config.home.username}/default 2>/dev/null || echo 'not-set')"
  '';
}
