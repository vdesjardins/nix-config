local null_ls = require("null-ls")
-- register any number of sources simultaneously
local sources = {
  null_ls.builtins.formatting.lua_format,
  null_ls.builtins.formatting.shfmt,
  null_ls.builtins.diagnostics.vale,
  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.diagnostics.markdownlint,
  null_ls.builtins.diagnostics.yamllint,
  null_ls.builtins.diagnostics.hadolint,
  null_ls.builtins.diagnostics.cppcheck,
}

null_ls.setup({ sources = sources })