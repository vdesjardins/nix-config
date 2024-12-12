{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
      settings = {
        notify.enabled = true;

        lsp = {
          # override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };
        # you can enable a preset for easier configuration
        presets = {
          bottom_search = true; # use a classic bottom cmdline for search
          command_palette = true; # position the cmdline and popupmenu together
          long_message_to_split = true; # long messages will be sent to a split
          inc_rename = false; # enables an input dialog for inc-rename.nvim
          lsp_doc_border = true; # add a border to hover docs and signature help
        };
      };
    };

    extraConfigLua = ''
      require("telescope").load_extension("noice")
    '';

    keymaps = [
      {
        mode = ["n" "i" "s"];
        key = "<c-f>";
        action.__raw = ''
          function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end
        '';
        options = {
          silent = true;
          expr = true;
        };
      }
      {
        mode = ["n" "i" "s"];
        key = "<c-b>";
        action.__raw = ''
          function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-b>"
            end
          end'';
        options = {
          silent = true;
          expr = true;
        };
      }
    ];
  };
}
