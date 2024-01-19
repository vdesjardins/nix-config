local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.gotmpl = {
    install_info = {
        url = "https://github.com/ngalaiko/tree-sitter-go-template",
        files = { "src/parser.c" },
    },
    filetype = "gotmpl",
    used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
}

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.yml", "*.yaml", "*.tpl" },
    command = [[if search('{{-.\+}}', 'nw') | setlocal filetype=gotmpl | endif]],
})

local current_file_path = debug.getinfo(1).source:match("@?(.*/)")
vim.opt.runtimepath:append(current_file_path)
