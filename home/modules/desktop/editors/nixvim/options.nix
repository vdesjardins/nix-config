{
  programs.nixvim.config = {
    globals = {
      mapleader = " ";
    };

    clipboard = {
      register = "unnamedplus";
    };

    opts = {
      undofile = true; # Write undo files
      undolevels = 1000; # Increase undo levels
      backup = false; # No file backup
      swapfile = false; # No swap file

      completeopt = "menuone,noselect"; # Completion options
      hidden = true; # Enable modified buffers in background
      ignorecase = true; # Ignore case
      inccommand = "nosplit"; # Show effects of a command incrementally
      joinspaces = false; # No double spaces with join after a dot
      scrolloff = 4; # Lines of context
      fileencoding = "utf-8"; # Encode files using UTF-8
      termguicolors = true; # True color support
      background = "dark"; # Always dark background
      wildmenu = true; # Command-line completion mode
      wildmode = "longest,list,full"; # Command-line completion mode
      cmdheight = 2; # Command-line height
      timeoutlen = 500; # to to wait for mapped sequence to complete

      errorbells = false; # No sound on errors
      visualbell = false;
      mouse = "";
      splitright = true;

      winaltkeys = "no"; # Disable ALT keys for menu

      autoindent = true;
      expandtab = true;
      shiftwidth = 4;
      smartindent = true;
      softtabstop = 4;
      tabstop = 4;
      colorcolumn = "81";

      laststatus = 3;
    };

    # Window
    # vim.wo.signcolumn = "number" # Always show the sign column
    # vim.wo.list = false # Don't show invisible characters by default
    # vim.wo.listchars = "tab:▸ ,eol:¬"
  };
}
