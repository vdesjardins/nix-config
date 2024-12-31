{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      blink-cmp = {
        enable = true;

        settings = {
          fuzzy.prebuilt_binaries = {
            download = false;
            ignore_version_mismatch = true;
          };

          appearance = {
            use_nvim_cmp_as_default = true;
          };

          keymap = {
            preset = "enter";
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
              "cmp_yanky"
              "copilot"
              "emoji"
              "lazydev"
            ];

            providers = {
              copilot = {
                async = true;
                module = "blink-cmp-copilot";
                name = "copilot";
                score_offset = 100;
              };

              cmp_yanky = {
                async = true;
                name = "cmp_yanky";
                module = "blink.compat.source";
                score_offset = 200;
              };

              emoji = {
                module = "blink-emoji";
                name = "Emoji";
                score_offset = 15;
              };
            };
          };

          completion = {
            accept = {
              auto_brackets = {
                enabled = false;
              };
            };

            list.selection.__raw = ''
              function(ctx)
                return ctx.mode == "cmdline" and "manual" or "preselect"
              end
            '';

            documentation = {
              auto_show = true;
              auto_show_delay_ms = 500;
              treesitter_highlighting = true;
            };

            menu = {
              auto_show = true;

              draw = {
                treesitter.enabled = true;
              };
            };
          };

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

      blink-compat = {
        enable = true;
        settings = {
          debug = true;
        };
      };

      blink-cmp-copilot = {
        enable = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      blink-emoji
    ];
  };
}
