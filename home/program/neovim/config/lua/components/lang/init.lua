require("components.lang.lua")
require("components.lang.nix")
require("components.lang.terraform")
require("components.lang.tflint")
require("components.lang.docker")
require("components.lang.rust")
require("components.lang.golang")
require("components.lang.json")
require("components.lang.yaml")
require("components.lang.cpp")
require("components.lang.bash")
require("components.lang.null-ls")

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
