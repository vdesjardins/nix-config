{
  programs.nixvim = {
    plugins = {
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
        settings = {
          sync = true;
        };
      };

      lsp = {
        enable = true;

        inlayHints = true;

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
            signs = {
              text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.INFO] = " ",
                [vim.diagnostic.severity.HINT] = "󰌵 ",
              },
              linehl = {
                [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
              },
              numhl = {
                [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
              },
            },
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

      # lsp
      {
        mode = "n";
        key = "<leader>ld";
        action.__raw = "Snacks.picker.lsp_definitions";
        options.desc = "LSP Definitions (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>lD";
        action.__raw = "Snacks.picker.lsp_declarations";
        options.desc = "LSP Declarations (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>li";
        action.__raw = "Snacks.picker.lsp_implementations";
        options.desc = "LSP Implementations (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>lR";
        action.__raw = "Snacks.picker.lsp_references";
        options.desc = "LSP References (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>ls";
        action.__raw = "Snacks.picker.lsp_symbols";
        options.desc = "LSP Symbols (Snacks)";
      }
      {
        mode = "n";
        key = "gd";
        action.__raw = "Snacks.picker.lsp_definitions";
        options.desc = "LSP Definitions (Snacks)";
      }
      {
        mode = "n";
        key = "gD";
        action.__raw = "Snacks.picker.lsp_declarations";
        options.desc = "LSP Declarations (Snacks)";
      }
      {
        mode = "n";
        key = "gi";
        action.__raw = "Snacks.picker.lsp_implementations";
        options.desc = "LSP Implementations (Snacks)";
      }
      {
        mode = "n";
        key = "gr";
        action.__raw = "Snacks.picker.lsp_references";
        options.desc = "LSP References (Snacks)";
      }
      {
        mode = "n";
        key = "gS";
        action.__raw = "Snacks.picker.lsp_symbols";
        options.desc = "LSP Symbols (Snacks)";
      }

      {
        mode = "n";
        key = "<leader>lt";
        action.__raw = "Snacks.picker.lsp_type_definitions";
        options.desc = "LSP Type Definitions (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>lw";
        action.__raw = "Snacks.picker.lsp_workspace_symbols";
        options.desc = "LSP Workspace Symbols (Snacks)";
      }

      {
        key = "<leader>lT";
        action.__raw = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
        options.desc = "Toggle Inlay Hints";
      }
      {
        key = "<leader>lr";
        action.__raw = "function() vim.lsp.buf.rename() end";
        options.desc = "Rename";
      }
      {
        key = "<leader>la";
        action = ":<C-U>lua vim.lsp.buf.range_code_action()<CR>";
        options.desc = "Range Code Action";
        mode = "v";
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
        action = "<cmd>checkhealth lsp<cr>";
        options.desc = "Show LSP health";
      }

      # logging
      {
        mode = "n";
        key = "<leader>lxo";
        action.__raw = ''
          function()
            local log_path = vim.lsp.get_log_path()
            vim.cmd.split(log_path)
          end'';
        options.desc = "Open LSP Log File";
      }
      {
        mode = "n";
        key = "<leader>lxe";
        action.__raw = "function() vim.lsp.log.set_level(vim.lsp.log.levels.DEBUG) end";
        options.desc = "Enable LSP Logging";
      }
      {
        mode = "n";
        key = "<leader>lxd";
        action.__raw = "function() vim.lsp.log.set_level(vim.lsp.log.levels.OFF) end";
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
