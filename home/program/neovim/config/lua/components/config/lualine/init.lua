local function lsp_server_name()
  local client_names = {}
  local nb_clients = 0
  local msg = "No Active Lsp"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then return msg end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      table.insert(client_names, client.name)
      nb_clients = nb_clients + 1
    end
  end
  if nb_clients > 0 then return table.concat(client_names, ",") end
  return msg
end

require("lualine").setup {
  options = {
    theme = Options.colorscheme,
    section_separators = { "", "" },
    component_separators = { "", "" },
    icons_enabled = true,
  },
  extensions = { "fzf" },
  sections = {
    lualine_a = { { "mode", upper = true } },
    lualine_b = {
      {
        "filename",
        file_status = true,
        symbols = { modified = " ", readonly = " " },
      },
    },
    lualine_c = {
      { "branch", icon = "" },
      { "diff" },
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        symbols = { error = " ", warn = " ", info = " " },
      },
      {
        lsp_server_name,
        icon = " LSP:",
        padding = 15,
        color = { fg = "#7195e1", gui = "bold" },
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
}

