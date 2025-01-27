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
                      default = 'hf.co/unsloth/DeepSeek-R1-Distill-Qwen-1.5B-GGUF',
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
              adapter = "ollama";
            };
            chat = {
              adapter = "ollama";
            };
            inline = {
              adapter = "ollama";
            };
          };
        };
      };
    };
  };
}
