{
  programs.nixvim.plugins.lualine = {
    enable = true;

    settings = {
      options = {
        theme = "auto";
        section_separators = {
          left = "";
          right = "";
        };
        component_separators = {
          left = "";
          right = "";
        };
        icons_enabled = true;
      };
      extensions = ["fzf"];
      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "mode";
            upper = true;
          }
        ];
        lualine_b = [
          {
            __unkeyed-1 = "filename";
            file_status = true;
            symbols = {
              modified = " ";
              readonly = " ";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "branch";
            icon = "";
          }
          {__unkeyed-1 = "diff";}
          {
            __unkeyed-1.__raw = ''
              function()
                return " "
              end
            '';
            color.__raw = ''
              function()
                local status = require("sidekick.status").get()
                if status then
                  return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
                end
              end
            '';
            cond.__raw = ''
              function()
                local status = require("sidekick.status")
                return status.get() ~= nil
              end
            '';
          }
          {
            __unkeyed-1 = "diagnostics";
            sources = {__unkeyed-1 = "nvim_diagnostic";};
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰌵 ";
            };
          }
          {
            __unkeyed-1.__raw = ''
              function()
                  local client_names = {}
                  local nb_clients = 0
                  local msg = "No Active Lsp"
                  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                  local clients = vim.lsp.get_active_clients()
                  if next(clients) == nil then
                      return msg
                  end
                  for _, client in ipairs(clients) do
                      local filetypes = client.config.filetypes
                      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                          table.insert(client_names, client.name)
                          nb_clients = nb_clients + 1
                      end
                  end
                  if nb_clients > 0 then
                      return table.concat(client_names, ",")
                  end
                  return msg
              end
            '';
            icon = " LSP:";
            padding = 15;
            color = {
              fg = "#7195e1";
              gui = "bold";
            };
          }
        ];
        lualine_x = [
          {
            __unkeyed-1.__raw = ''
              function()
                local status = require("sidekick.status").cli()
                return " " .. (#status > 1 and #status or "")
              end
            '';
            cond.__raw = ''
              function()
                return #require("sidekick.status").cli() > 0
              end
            '';
            color.__raw = ''
              function()
                return "Special"
              end
            '';
          }
          {
            __unkeyed-1.__raw = ''require ("noice").api.status.message.get_hl'';
            cond.__raw = ''require("noice").api.status.message.has'';
          }
          {
            __unkeyed-1.__raw = ''require("noice").api.status.command.get'';
            cond.__raw = ''require("noice").api.status.command.has'';
            color = {fg = "#ff9e64";};
          }
          {
            __unkeyed-1.__raw = ''require("noice").api.status.mode.get'';
            cond.__raw = ''require("noice").api.status.mode.has'';
            color = {fg = "#ff9e64";};
          }
          {
            __unkeyed-1.__raw = ''require("noice").api.status.search.get'';
            cond.__raw = ''require("noice").api.status.search.has'';
            color = {fg = "#ff9e64";};
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = ["progress"];
        lualine_z = ["location"];
      };
      inactive_sections = {
        lualine_a = null;
        lualine_b = null;
        lualine_c = [{__unkeyed-1 = "filename";}];
        lualine_x = [{__unkeyed-1 = "location";}];
        lualine_y = null;
        lualine_z = null;
      };
    };
  };
}
