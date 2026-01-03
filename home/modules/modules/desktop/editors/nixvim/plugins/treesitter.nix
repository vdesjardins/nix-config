{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;

        nixvimInjections = true;

        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = false;
              node_incremental = "v";
              node_decremental = "V";
              scope_incremental = "grc";
            };
          };
        };
      };

      # treesitter-refactor = {
      #   enable = true;
      #   settings = {
      #     highlight_definitions = {
      #       enable = true;
      #       # Set to false if you have an `updatetime` of ~100.
      #       clear_on_cursor_move = false;
      #     };
      #   };
      # };

      hmts.enable = true;

      treesitter-context.enable = true;

      # treesitter-textobjects = {
      #   enable = true;
      #   settings = {
      #     select = {
      #       enable = true;
      #       lookahead = true;
      #       keymaps = {
      #         "af" = {
      #           query = "@function.outer";
      #           desc = "Select outer part of function";
      #         };
      #         "if" = {
      #           query = "@function.inner";
      #           desc = "Select inner part of function";
      #         };
      #         "ac" = {
      #           query = "@class.outer";
      #           desc = "Select outer part of class";
      #         };
      #         "ic" = {
      #           query = "@class.inner";
      #           desc = "Select inner part of class";
      #         };
      #       };
      #     };
      #
      #     swap = {
      #       enable = true;
      #       swap_next = {
      #         "<leader>ln" = {
      #           query = "@parameter.inner";
      #           desc = "Swap with next parameter";
      #         };
      #       };
      #       swap_previous = {
      #         "<leader>lp" = {
      #           query = "@parameter.inner";
      #           desc = "Swap with previous parameter";
      #         };
      #       };
      #     };
      #
      #     move = {
      #       enable = true;
      #       set_jumps = true; # whether to set jumps in the jumplist
      #       goto_next_start = {
      #         "]m" = {
      #           query = "@function.outer";
      #           desc = "Goto Next Function Start";
      #         };
      #         "]]" = {
      #           query = "@class.outer";
      #           desc = "Goto Next Class Start";
      #         };
      #       };
      #       goto_next_end = {
      #         "]M" = {
      #           query = "@function.outer";
      #           desc = "Goto Next Function End";
      #         };
      #         "][" = {
      #           query = "@class.outer";
      #           desc = "Goto Next Class End";
      #         };
      #       };
      #       goto_previous_start = {
      #         "[m" = {
      #           query = "@function.outer";
      #           desc = "Goto Previous Function Start";
      #         };
      #         "[[" = {
      #           query = "@class.outer";
      #           desc = "Goto Previous Class Start";
      #         };
      #       };
      #       goto_previous_end = {
      #         "[M" = {
      #           query = "@function.outer";
      #           desc = "Goto Previous Function End";
      #         };
      #         "[]" = {
      #           query = "@class.outer";
      #           desc = "Goto Previous Class End";
      #         };
      #       };
      #     };
      #
      #     lsp_interop = {
      #       enable = true;
      #       border = "none";
      #
      #       peek_definition_code = {
      #         "<leader>ldf" = {
      #           query = "@function.outer";
      #           desc = "LSP Peek Function Definition";
      #         };
      #         "<leader>ldF" = {
      #           query = "@class.outer";
      #           desc = "LSP Peek Class Definition";
      #         };
      #       };
      #     };
      #   };
      # };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>mi";
        action = "<cmd>InspectTree<cr>";
        options.desc = "Inspect (Treesitter)";
      }
      {
        mode = "n";
        key = "<leader>mq";
        action = "<cmd>EditQuery<cr>";
        options.desc = "Query (Treesitter)";
      }
    ];
  };
}
