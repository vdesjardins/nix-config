_G.LspLanguages = {}
_G.LspLanguages.lua = require("components.lang.lua")
_G.LspLanguages.sh = require("components.lang.bash")
_G.LspLanguages.nix = require("components.lang.nix")
_G.LspLanguages.terraform = require("components.lang.terraform")
_G.LspLanguages.tflint = require("components.lang.tflint")
_G.LspLanguages.efm = require("components.lang.efm")
_G.LspLanguages.docker = require("components.lang.docker")
_G.LspLanguages.rust = require("components.lang.rust")
_G.LspLanguages.golang = require("components.lang.golang")
_G.LspLanguages.json = require("components.lang.json")
_G.LspLanguages.yaml = require("components.lang.yaml")
_G.LspLanguages.cpp = require("components.lang.cpp")

for _, cfg in pairs(_G.LspLanguages) do
  require"lspconfig"[cfg.lsp_name()].setup(cfg.lsp_setup())
end

vim.cmd("autocmd BufWritePre * lua _G.LangFormatBuffer()")

function _G.LangFormatBuffer()
  local buf_ft = vim.bo.filetype
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then return end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      vim.lsp.buf.formatting_sync(nil, 1500)
      return
    end
  end
end
