{...}: {
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;

        autoEnableSources = false;

        settings = {
          # formatting.format = /* lua */
          #     ''
          #     lspkind.cmp_format({
          #         mode = "symbol_text",     -- show only symbol annotations
          #         maxwidth = 50,            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          #
          #         ellipsis_char = "...",    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          #         show_labelDetails = true, -- show labelDetails in menu. Disabled by default
          #
          #         -- The function below will be called before any actual modifications from lspkind
          #         -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          #         before = function(_entry, vim_item)
          #             return vim_item
          #         end,
          #     }),
          #     '';

          snippet.expand =
            # lua
            ''
              function(args)
                require("luasnip").lsp_expand(args.body)
              end
            '';

          window = {
            completion.border = "rounded";
            documentation.border = "rounded";
          };

          mapping = {
            "<C-b>" = "cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' })";
            "<C-f>" = "cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' })";
            "<C-Space>" = "cmp.mapping(cmp.mapping.complete(), { 'i', 'c' })";
            "<C-e>" = "cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() })";
            "<CR>" = "cmp.mapping.confirm({ select = false })"; # Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          mappingPresets = ["insert"];

          sources.__raw =
            # lua
            ''
              cmp.config.sources({
                  {name = "nvim_lsp"},
                  {name = "nvim_lsp_signature_help"},
                  {name = "treesitter"},
                  {name = "luasnip"},
                  {name = "path"},
                  {name = "copilot"},
                }, {
                  {name = "buffer", keywordLength = 3},
                  {name = "calc" },
                  {name = "emoji" },
                }, {
                  {name = "rg", keywordLength = 3},
                  {name = "spell", keywordLength = 3},
                  {name = "fuzzy_path"},
                  {name = "cmp_yanky"},
                }, {
                  {name = "git"},
                  {name = "conventionalcommits"},
                })
            '';
        };
      };

      cmp-buffer.enable = true;
      cmp-calc.enable = true;
      cmp-cmdline.enable = true;
      cmp-emoji.enable = true;
      cmp-git.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-path.enable = true;
      cmp-rg.enable = true;
      cmp-spell.enable = true;
      cmp-treesitter.enable = true;
      cmp-fuzzy-path.enable = true;
      cmp-conventionalcommits.enable = true;
      copilot-cmp.enable = true;

      lspkind = {
        enable = true;
        cmp = {
          enable = true;
          maxWidth = 50;
          ellipsisChar = "…";
          menu = {
            nvim_lsp = "λ";
            luasnip = "⋗";
            buffer = "Ω";
            path = "";
            rg = "";
            calc = "";
            emoji = "";
            treesitter = "";
            spell = "";
          };
        };
        symbolMap = {
          Copilot = "";
          cmp_ai = "󰧑";
        };
      };
      # TODO
      # vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    };

    extraConfigLua = ''
      local cmp = require('cmp')

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        formatting = {
          fields = { "abbr" },
        },
        sources = {
          { name = 'buffer' }
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        formatting = {
          fields = { "abbr" },
        },
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    '';
  };
}
