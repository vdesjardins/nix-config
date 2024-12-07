{
  programs.nixvim = {
    plugins = {
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };

      lsp = {
        enable = true;

        inlayHints = true;

        preConfig = ''
          vim.lsp.set_log_level('off')
        '';

        postConfig = ''
          vim.lsp.protocol.CompletionItemKind = {
              "   (Text) ",
              "   (Method)",
              "   (Function)",
              "   (Constructor)",
              " ﴲ  (Field)",
              "[] (Variable)",
              "   (Class)",
              " ﰮ  (Interface)",
              "   (Module)",
              " 襁 (Property)",
              "   (Unit)",
              "   (Value)",
              " 練 (Enum)",
              "   (Keyword)",
              " ﬌  (Snippet)",
              "   (Color)",
              "   (File)",
              "   (Reference)",
              "   (Folder)",
              "   (EnumMember)",
              " ﲀ  (Constant)",
              " ﳤ  (Struct)",
              "   (Event)",
              "   (Operator)",
              "   (TypeParameter)",
          }

          vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = true,
            severity_sort = false,
          })

          vim.fn.sign_define("DiagnosticSignError", {
              text = " ",
              numhl = "DiagnosticSignError",
              texthl = "DiagnosticSignError",
          })
          vim.fn.sign_define("DiagnosticSignWarn", {
              text = " ",
              numhl = "DiagnosticSignWarn",
              texthl = "DiagnosticSignWarn",
          })
          vim.fn.sign_define("DiagnosticSignInfo", {
              text = " ",
              numhl = "DiagnosticSignInfo",
              texthl = "DiagnosticSignInfo",
          })
          vim.fn.sign_define("DiagnosticSignHint", {
              text = " ",
              numhl = "DiagnosticSignHint",
              texthl = "DiagnosticSignHint",
          })
        '';

        servers = {
          clangd.enable = true;
          cssls.enable = true;
          dockerls.enable = true;
          helm_ls.enable = true;
          html.enable = true;
          sqls.enable = true;
          ts_ls.enable = true;
          zls.enable = true;
        };
      };
    };

    keymaps = [
      {
        key = "<leader>la";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code Action";
      }
      {
        key = "<leader>lD";
        action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
        options.desc = "Goto Declaration";
      }
      {
        key = "<leader>ld";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Goto Definition";
      }
      {
        key = "<leader>li";
        action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
        options.desc = "Goto Implementation";
      }
      {
        key = "<leader>lr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        options.desc = "Goto References";
      }
      {
        key = "<leader>lT";
        action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
        options.desc = "Toggle Inlay Hints";
      }
      {
        key = "<leader>lr";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "Rename";
      }
      {
        key = "<leader>la";
        action = ":<C-U>lua vim.lsp.buf.range_code_action()<CR>";
        options.desc = "Range Code Action";
        mode = "v";
      }

      {
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
        options.desc = "Goto Declaration";
      }
      {
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Goto Definition";
      }
      {
        key = "gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
        options.desc = "Goto Implementation";
      }
      {
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "Goto References";
      }

      # jump
      {
        mode = "n";
        key = "<C-p>";
        action = "<cmd>lua vim.diagnostic.goto_prev({})<CR>";
        options.desc = "Goto Diagnostic Previous";
      }
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>lua vim.diagnostic.goto_next({})<CR>";
        options.desc = "Goto Diagnostic Next";
      }

      # extra
      {
        mode = "n";
        key = "<leader>ll";
        action.__raw = "function() vim.lsp.codelens.refresh() end";
        options.desc = "LSP CodeLens Refresh";
      }
      {
        mode = "n";
        key = "<leader>lL";
        action.__raw = "function() vim.lsp.codelens.run() end";
        options.desc = "LSP CodeLens Run";
      }
      {
        mode = "n";
        key = "<leader>lI";
        action = "<cmd>LspInfo<cr>";
        options.desc = "Show LSP Info";
      }

      # logging
      {
        mode = "n";
        key = "<leader>lxo";
        action = "<cmd>LspLog<cr>";
        options.desc = "Open LSP Log File";
      }
      {
        mode = "n";
        key = "<leader>lxe";
        action.__raw = "function() vim.lsp.set_log_level('debug') end";
        options.desc = "Enable LSP Logging";
      }
      {
        mode = "n";
        key = "<leader>lxd";
        action.__raw = "function() vim.lsp.set_log_level('off') end";
        options.desc = "Disable LSP Logging";
      }
      {
        mode = "n";
        key = "<leader>lxc";
        action = "<cmd>LspLogClear<cr>";
        options.desc = "Clear LSP Log File";
      }
    ];

    extraConfigLua = ''
      vim.api.nvim_create_user_command("LspLogClear", function()
        local lsplogpath = vim.fn.stdpath("state") .. "/lsp.log"
        if io.close(io.open(lsplogpath, "w+b")) == false then vim.notify("Clearning LSP Log failed.", vim.log.levels.WARN) end
      end, { nargs = 0 })
    '';
  };
}
