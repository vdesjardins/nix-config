{pkgs, ...}: {
  programs.nixvim.plugins.avante = {
    enable = true;

    settings = {
      provider = "ollama";

      claude = {
        api_key_name = "cmd:${pkgs.passage}/bin/passage /apis/ai/anthropic";
      };
      openai = {
        api_key_name = "cmd:${pkgs.passage}/bin/passage /apis/ai/openai";
      };

      vendors = {
        ollama = {
          api_key_name = "";
          endpoint = "http://localhost:11434/v1";
          model = "ajindal/llama3.1-storm:8b";
          parse_curl_args.__raw = ''
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
                  messages = require("avante.providers").copilot.parse_messages(code_opts),
                  max_tokens = opts.max_tokens,
                  stream = true,
                },
              }
            end'';
          parse_response_data.__raw = ''
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
        files = {
          add_current = "<leader>cc";
        };
      };
    };
  };
}
