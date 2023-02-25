vim.g.UltiSnipsExpandTrigger = "<TAB>"
vim.g.UltiSnipsJumpForwardTrigger = "<TAB>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-TAB>"
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", "ultisnips" }

-- add all language snippets to runtimepath
local Path = require("plenary.path")
local current_file_path = debug.getinfo(1).source:match("@?(.*/)")
local my_lang_path = current_file_path .. "../../my-lang/"
for _, p in
    ipairs(vim.fs.find("ultisnips", { path = my_lang_path, type = "directory", limit = 50 }))
do
    vim.opt.runtimepath:append(Path:new(p .. "/.."):absolute())
end
