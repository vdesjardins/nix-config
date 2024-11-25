{
  programs.nixvim.plugins.avante = {
    enable = true;

    settings = {
      provider = "ollama";
      vendors = {
        ollama = {
          api_key_name = "";
          endpoint = "http://localhost:11434/v1";
          model = "ajindal/llama3.1-storm:8b";
          parse_curl_args.__raw =
            # lua
            ''
              function(opts, code_opts)
                return {
                  url = opts.endpoint .. "/chat/completions",
                  headers = {
                    ["Accept"] = "application/json",
                    ["Content-Type"] = "application/json",
                    ["x-api-key"] = "ollama",
                  },
                  body = {
                    model = opts.model,
                    messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
                    max_tokens = 2048,
                    stream = true,
                  },
                }
              end'';
          parse_response_data.__raw =
            # lua
            ''
              function(data_stream, event_state, opts)
                require("avante.providers").openai.parse_response(data_stream, event_state, opts)
              end'';
        };
      };

      mappings = {
        ask = "<leader>ca";
        edit = "<leader>ce";
        refresh = "<leader>cr";
        focus = "<leader>cf";
        toggle = {
          default = "<leader>ct";
          debug = "<leader>cd";
          hint = "<leader>ch";
          suggestion = "<leader>cs";
          repomap = "<leader>cR";
        };
      };
    };
  };
}
