{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      codecompanion = {
        enable = true;

        package = pkgs.vimPlugins.codecompanion;

        settings = {
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
          };

          opts = {
            send_code = true;
            use_default_actions = true;
            use_default_prompts = true;
          };

          strategies = {
            agent = {
              adapter = "copilot";
            };
            chat = {
              adapter = "copilot";
            };
            inline = {
              adapter = "copilot";
            };
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
    ];
  };
}
