{...}: {
  programs.nixvim = {
    plugins = {
      blink-cmp = {
        enable = true;

        settings = {
          accept = {
            auto_brackets = {
              enabled = false;
            };
          };
          documentation = {
            auto_show = false;
          };
          highlight = {
            use_nvim_cmp_as_default = true;
          };
          keymap = {
            preset = "enter";
          };
          trigger = {
            signature_help = {
              enabled = true;
            };
          };
          signature = {
            enabled = true;
          };

          sources = {
            default = [
              "lsp"
              "path"
              "luasnip"
              "buffer"
              # "treesitter"
              # "copilot"
              # "calc"
              # "emoji"
            ];
            # "lsp" = {};
            # "treesitter" = {};
            # "path" = {};
            # "snippets" = {};
            # "buffer" = {};
            # "copilot" = {};
            # "calc" = {};
            # "emoji" = {};
          };

          completion = {
            menu = {
              draw = {
              columns = {
                  "__unkeyed-1" = {
                    "__unkeyed-1" = "label";
                    "__unkeyed-2" = "label_description";
                    gap = 1;
                  };
                  "__unkeyed-2" = {
                    "__unkeyed-1" = "kind_icon";
                    "__unkeyed-2" = "kind";
                  };
            };
            };
            };
          };

          opts = {
            snippets = {
              expand.__raw = ''
              function(snippet) require('luasnip').lsp_expand(snippet) end
              '';
              active.__raw = ''
              function(filter)
                if filter and filter.direction then
                  return require('luasnip').jumpable(filter.direction)
                end
                return require('luasnip').in_snippet()
              end
              '';
              jump.__raw = ''
              function(direction) require('luasnip').jump(direction) end
              '';
            };
          };
        };
      };
    };
  };
}
