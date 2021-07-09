LspLanguages = {}
LspLanguages.lua = require("components.lang.lua")
LspLanguages.sh = require("components.lang.bash")
LspLanguages.nix = require("components.lang.nix")
LspLanguages.terraform = require("components.lang.terraform")
LspLanguages.tflint = require("components.lang.tflint")
LspLanguages.efm = require("components.lang.efm")
LspLanguages.docker = require("components.lang.docker")
LspLanguages.rust = require("components.lang.rust")
LspLanguages.golang = require("components.lang.golang")
LspLanguages.json = require("components.lang.json")
LspLanguages.yaml = require("components.lang.yaml")
LspLanguages.cpp = require("components.lang.cpp")

for _, cfg in pairs(LspLanguages) do
  require"lspconfig"[cfg.lsp_name()].setup(cfg.lsp_setup())
end

vim.cmd("autocmd BufWritePre * lua LangFormatBuffer()")

function LangFormatBuffer()
  local buf_ft = vim.bo.filetype
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then return end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      vim.lsp.buf.formatting_sync(nil, 1000)
      return
    end
  end
end
