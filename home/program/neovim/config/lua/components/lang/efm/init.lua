local cfg = {}

function cfg.lsp_setup()
  return {
    init_options = { documentFormatting = true, codeAction = true },
    filetypes = {
      "lua",
      "vim",
      "make",
      "markdown",
      "yaml",
      "dockerfile",
      "sh",
      "zsh",
      "json",
      "cpp",
      "c",
    },
    settings = {
      rootMarkers = { ".git/", ".git", ".root" },
      languages = {
        lua = { { formatCommand = "lua-format -i", formatStdin = true } },
        vim = { { lintCommand = "vint -", lintStdin = true } },
        make = { { lintCommand = "checkmake", lintStdin = true } },
        markdown = {
          {
            lintCommand = "markdownlint -s",
            lintStdin = true,
            lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
          },
        },
        yaml = { { lintCommand = "yamllint -f parsable -", lintStdin = true } },
        dockerfile = {
          { lintCommand = "hadolint", lintFormats = { "%f:%l %m" } },
        },
        sh = {
          {
            lintCommand = "shellcheck -f gcc -x",
            lintSource = "shellcheck",
            lintFormat = {
              "%f:%l:%c: %trror: %m",
              "%f:%l:%c: %tarning: %m",
              "%f:%l:%c: %tote: %m",
            },
          },
          { formatCommand = "shfmt -ci -s -bn", formatStdin = true },
        },
        json = { { lintCommand = "jq ." }, { formatCommand = "fixjson" } },
        cpp = { { lintCommand = "cppcheck -q --language=c++ --enable=style" } },
        c = { { lintCommand = "cppcheck -q --language=c --enable=style" } },
      },
    },
  }
end

function cfg.lsp_name() return "efm" end

return cfg
