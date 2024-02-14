local lspkind = require("lspkind")
local cmp = require("cmp")

lspkind.init({
    symbol_map = {
        Copilot = "",
    },
})
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_entry, vim_item)
                return vim_item
            end,
        }),
    },

    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        { name = "ultisnips" }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
        { name = "treesitter" },
        { name = "crates" },
        { name = "copilot" },
    }, { { name = "buffer" } }),

    sorting = {
        priority_weight = 2,
        comparators = {
            require("copilot_cmp.comparators").prioritize,

            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, { { name = "buffer" } }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
    sources = { { name = "buffer" } },
    mapping = cmp.mapping.preset.cmdline(),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    mapping = cmp.mapping.preset.cmdline(),
})
