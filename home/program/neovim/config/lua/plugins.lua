-- auto install packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " ..
            install_path)
end

-- auto compile on plugins.lua save
vim.cmd "autocmd BufWritePost plugins.lua PackerCompile"

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- LSP
  use "neovim/nvim-lspconfig"
  use "hrsh7th/nvim-compe"
  use "glepnir/lspsaga.nvim"
  use "onsails/lspkind-nvim"
  use "kosayoda/nvim-lightbulb"

  -- Debugging
  use "mfussenegger/nvim-dap"

  -- use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- use {'andymass/vim-matchup', event = 'VimEnter'}

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "p00f/nvim-ts-rainbow"
  use { "lukas-reineke/indent-blankline.nvim", branch = "lua" }
  use "nvim-treesitter/playground"
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use "windwp/nvim-ts-autotag"

  -- status line
  use {
    "hoob3rt/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  }

  -- git
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end,
  }
  use "f-person/git-blame.nvim"
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"

  -- Tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  }

  -- Misc
  use "folke/which-key.nvim"
  use { "folke/lsp-trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }
  use "kevinhwang91/nvim-bqf" -- preview in quickfix
  -- use "airblade/vim-rooter"
  use "ahmedkhalf/lsp-rooter.nvim"
  use "tpope/vim-commentary"
  use "tpope/vim-rsi" -- emacs style keybindings in edit/cmd
  use "MattesGroeger/vim-bookmarks"
  use "christoomey/vim-tmux-navigator"
  use "mhinz/vim-startify"
  use "moll/vim-bbye" -- close buffer

  -- text
  use "ntpeters/vim-better-whitespace"
  use "tpope/vim-endwise"
  use "jiangmiao/auto-pairs"
  use "mhinz/vim-grepper"
  use "tpope/vim-surround"

  -- Snippets
  use "SirVer/ultisnips"
  use "honza/vim-snippets"

  -- colorscheme
  use "folke/tokyonight.nvim"
  -- use 'Th3Whit3Wolf/one-nvim'
  -- use 'chriskempson/base16-vim'

  -- Rust
  use "simrat39/rust-tools.nvim"

  -- Markdown
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    cmd = "MarkdownPreview",
  }

  -- Terraform
  use "hashivim/vim-terraform"

  -- Nix
  use "LnL7/vim-nix"
end)
