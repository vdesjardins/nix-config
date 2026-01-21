{
  pkgs,
  my-packages,
  ...
}: {
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

          keymap = {
            preset = "enter";
            "<Tab>".__raw = ''
              {
                "snippet_forward",
                function() -- sidekick next edit suggestion
                  return require("sidekick").nes_jump_or_apply()
                end,
                function() -- if you are using Neovim's native inline completions
                  return vim.lsp.inline_completion.get()
                end,
                "fallback",
              }
            '';
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
              "omni"
              "cmp_yanky"
              "copilot"
              "emoji"
              "lazydev"
              "dictionary"
            ];

            per_filetype = {
              codecompanion = ["codecompanion"];
            };

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
                module = "blink-yanky";
                opts = {
                  minLength = 5;
                  onlyCurrentFiletype = true;
                  kind_icon = "󰅍";
                };
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

    extraPlugins = [
      my-packages.vimPlugins-blink-emoji
      my-packages.vimPlugins-blink-cmp-yanky
    ];

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, 'BlinkCmpKindDict', { default = false, fg = '#a6e3a1' })

      -- Add arrow key and Tab/Shift+Tab navigation for cmdline completions
      local cmp = require('blink.cmp')

      -- Up arrow: navigate menu or go to previous command
      vim.keymap.set('c', '<Up>', function()
        if cmp.is_visible() then
          cmp.select_prev()
          return
        end
        -- Let default behavior handle it (command history)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n', false)
      end, { noremap = true })

      -- Down arrow: navigate menu or go to next command
      vim.keymap.set('c', '<Down>', function()
        if cmp.is_visible() then
          cmp.select_next()
          return
        end
        -- Let default behavior handle it (command history)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n', false)
      end, { noremap = true })

      -- Tab: select next in menu
      vim.keymap.set('c', '<Tab>', function()
        if cmp.is_visible() then
          cmp.select_next()
        else
          -- Default tab behavior
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
        end
      end, { noremap = true })

      -- Shift+Tab: select previous in menu
      vim.keymap.set('c', '<S-Tab>', function()
        if cmp.is_visible() then
          cmp.select_prev()
        else
          -- Default shift+tab behavior
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 'n', false)
        end
      end, { noremap = true })
    '';
  };
}
