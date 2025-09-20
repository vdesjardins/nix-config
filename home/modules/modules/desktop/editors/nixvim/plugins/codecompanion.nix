{
  config,
  pkgs,
  my-packages,
  ...
}: let
  cfg = config.modules.desktop.editors.nixvim;
in {
  programs.nixvim = {
    extraPlugins = with my-packages.vimPlugins; [
      codecompanion-history
    ];

    plugins = {
      codecompanion = {
        enable = true;

        package = my-packages.vimPlugins.codecompanion;

        settings = {
          extensions = {
            history = {
              enabled = true;
              opts = {
                picker = "snacks";
              };
            };
          };

          adapters = {
            anthropic.__raw = ''
              function()
                return require('codecompanion.adapters').extend('anthropic', {
                  env = {
                    api_key = "cmd:${pkgs.passage}/bin/passage /apis/ai/anthropic"
                  }
                })
              end
            '';

            gemini.__raw = ''
              function()
                return require('codecompanion.adapters').extend('gemini', {
                  env = {
                    api_key = "cmd:${pkgs.passage}/bin/passage /apis/ai/gemini"
                  }
                })
              end
            '';
            openai.__raw = ''
              function()
                return require('codecompanion.adapters').extend('openai', {
                  env = {
                    api_key = "cmd:${pkgs.passage}/bin/passage /apis/ai/openai"
                  }
                })
              end
            '';

            deepseek.__raw = ''
              function()
                return require('codecompanion.adapters').extend('deepseek', {
                  env = {
                    api_key = "cmd:${pkgs.passage}/bin/passage /apis/ai/deepseek"
                  },
                  schema = {
                    model = {
                      default = "deepseek-reasoner",
                    },
                  },
                })
              end
            '';

            ollama.__raw = ''
              function()
                return require('codecompanion.adapters').extend('ollama', {
                  env = {
                    url = "http://127.0.0.1:11434",
                  },
                  schema = {
                    model = {
                      default = 'qwen3:4b',
                    },
                    temperature = {
                      default = 0.6,
                    },
                    num_ctx = {
                      default = 32768,
                    },
                  },
                })
              end
            '';

            tavily.__raw = ''
              function()
                return require('codecompanion.adapters').extend('tavily', {
                  env = {
                    api_key = "cmd:${pkgs.passage}/bin/passage /apis/ai/tavily",
                  },
                })
              end
            '';
          };

          opts = {
            send_code = true;
            use_default_actions = true;
            use_default_prompts = true;
          };

          strategies = {
            agent = cfg.ai.agent;
            chat =
              cfg.ai.chat
              // {
                keymaps = {
                  options = {
                    modes = {
                      n = "g?";
                    };
                    callback = "keymaps.options";
                    description = "Options";
                    hide = true;
                  };
                  next_chat = {
                    modes = {
                      n = "g}";
                    };
                    index = 11;
                    callback = "keymaps.next_chat";
                    description = "Next Chat";
                  };
                  previous_chat = {
                    modes = {
                      n = "g{";
                    };
                    index = 12;
                    callback = "keymaps.previous_chat";
                    description = "Previous Chat";
                  };
                };
              };
            inline = cfg.ai.inline;
          };

          display = {
            action_palette = {
              provider = "snacks";
            };
          };
        };
      };
    };

    keymaps = [
      {
        mode = "v";
        key = "<leader>ce";
        action = "<cmd>CodeCompanion /explain<cr>";
        options.desc = "Explain Selection / Buffer (CodeCompanion)";
      }
      {
        mode = "v";
        key = "<leader>cl";
        action = "<cmd>CodeCompanion /lsp<cr>";
        options.desc = "Explain LSP (CodeCompanion)";
      }
      {
        mode = "v";
        key = "<leader>cf";
        action = "<cmd>CodeCompanion /fix<cr>";
        options.desc = "Fix (CodeCompanion)";
      }
      {
        mode = "v";
        key = "<leader>ct";
        action = "<cmd>CodeCompanion /tests<cr>";
        options.desc = "Generate tests (CodeCompanion)";
      }
      {
        mode = "n";
        key = "<leader>cC";
        action = "<cmd>CodeCompanion /commit<cr>";
        options.desc = "Generate commit message (CodeCompanion)";
      }
      {
        mode = "n";
        key = "<leader>cc";
        action = "<cmd>CodeCompanionChat<cr>";
        options.desc = "Chat (CodeCompanion)";
      }
      {
        mode = "n";
        key = "<leader>cc";
        action = "<cmd>CodeCompanionChat<cr>";
        options.desc = "Chat (CodeCompanion)";
      }
      {
        mode = "n";
        key = "<leader>ct";
        action = "<cmd>CodeCompanionChat Toggle<cr>";
        options.desc = "Chat Toggle (CodeCompanion)";
      }
      {
        mode = "n";
        key = "<leader>cb";
        action = "<cmd>CodeCompanionChat #buffer<cr>";
        options.desc = "Chat with Buffer Content (CodeCompanion)";
      }
      {
        mode = "v";
        key = "<leader>ca";
        action = "<cmd>CodeCompanionActions<cr>";
        options.desc = "Add Selection to Chat Buffer (CodeCompanion)";
      }
      {
        mode = ["v" "n"];
        key = "<leader>ca";
        action = "<cmd>CodeCompanionActions<cr>";
        options.desc = "Actions (CodeCompanion)";
      }
      {
        mode = "n";
        key = "<leader>ch";
        action = "<cmd>CodeCompanionHistory<cr>";
        options.desc = "History (CodeCompanionHistory)";
      }
    ];
  };
}
