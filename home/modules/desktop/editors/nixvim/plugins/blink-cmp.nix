{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      blink-cmp = {
        enable = true;

        package = pkgs.vimPlugins.blink-cmp;

        settings = {
          cmdline = {
            enabled = true;
            completion.menu.auto_show = true;
          };

          fuzzy = {
            prebuilt_binaries = {
              download = false;
              ignore_version_mismatch = true;
            };
          };

          keymap = {
            preset = "enter";
          };

          signature = {
            # let noice handle this
            enabled = false;
            window = {
              border = "rounded";
            };
          };

          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
              "cmp_yanky"
              "copilot"
              "emoji"
              "lazydev"
              "codecompanion"
              "dictionary"
            ];

            providers = {
              copilot = {
                name = "Copilot";
                async = true;
                module = "blink-copilot";
                score_offset = 15;
                opts = {
                  max_completions = 2;
                  max_attemps = 3;
                };
              };

              cmp_yanky = {
                async = true;
                name = "cmp_yanky";
                module = "blink.compat.source";
                score_offset = -15;
                transform_items.__raw = ''
                  function(_, items)
                    return vim.tbl_map(function(item)
                      item.kind_name = "Yanky"
                      item.kind_icon = "⧉"
                      return item
                    end, items)
                  end
                '';
              };

              emoji = {
                module = "blink-emoji";
                name = "Emoji";
                score_offset = -20;
                opts = {insert = true;};
                transform_items.__raw = ''
                  function(_, items)
                    return vim.tbl_map(function(item)
                      item.kind_name = "Emoji"
                      item.kind_icon = ""
                      return item
                    end, items)
                  end
                '';
              };

              codecompanion = {
                name = "CodeCompanion";
                module = "codecompanion.providers.completion.blink";
              };

              dictionary = {
                module = "blink-cmp-dictionary";
                name = "Dict";
                score_offset = -10;
                min_keyword_length = 3;
                # TODO: throwing error
                # max_items = 5;
                opts = {
                  dictionary_directories = {
                    __unkeyed-1.__raw = ''vim.fn.expand("~/.config/dictionaries/")'';
                  };
                };
              };
            };
          };

          appearance = {
            use_nvim_cmp_as_default = false;
          };

          completion = {
            ghost_text = {
              enabled = true;
            };

            accept = {
              auto_brackets = {
                enabled = false;
              };
            };

            list = {
              selection = {
                preselect.__raw = ''
                  function(ctx)
                    return ctx.mode ~= 'cmdline' and not require('blink.cmp').snippet_active({ direction = 1 })
                  end
                '';
                auto_insert = false;
              };
            };

            documentation = {
              auto_show = true;
              auto_show_delay_ms = 500;
              treesitter_highlighting = true;
              window = {
                border = "rounded";
              };
            };

            menu = {
              border = "rounded";

              auto_show = true;

              draw = {
                treesitter = ["lsp"];
              };
            };
          };

          snippets = {
            preset = "luasnip";
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

      blink-compat = {
        enable = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      blink-emoji
    ];

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, 'BlinkCmpKindDict', { default = false, fg = '#a6e3a1' })
    '';
  };
}
