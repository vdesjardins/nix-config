{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;

        nixvimInjections = true;

        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      treesitter-refactor = {
        enable = true;
        highlightDefinitions = {
          enable = true;
          # Set to false if you have an `updatetime` of ~100.
          clearOnCursorMove = false;
        };
      };

      hmts.enable = true;

      treesitter-context.enable = true;

      treesitter-textobjects = {
        enable = true;
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = {
              query = "@function.outer";
              desc = "Select outer part of function";
            };
            "if" = {
              query = "@function.inner";
              desc = "Select inner part of function";
            };
            "ac" = {
              query = "@class.outer";
              desc = "Select outer part of class";
            };
            "ic" = {
              query = "@class.inner";
              desc = "Select inner part of class";
            };
          };
        };

        swap = {
          enable = true;
          swapNext = {
            "<leader>ln" = {
              query = "@parameter.inner";
              desc = "Swap with next parameter";
            };
          };
          swapPrevious = {
            "<leader>lp" = {
              query = "@parameter.inner";
              desc = "Swap with previous parameter";
            };
          };
        };

        move = {
          enable = true;
          setJumps = true; # whether to set jumps in the jumplist
          gotoNextStart = {
            "]m" = {
              query = "@function.outer";
              desc = "Goto Next Function Start";
            };
            "]]" = {
              query = "@class.outer";
              desc = "Goto Next Class Start";
            };
          };
          gotoNextEnd = {
            "]M" = {
              query = "@function.outer";
              desc = "Goto Next Function End";
            };
            "][" = {
              query = "@class.outer";
              desc = "Goto Next Class End";
            };
          };
          gotoPreviousStart = {
            "[m" = {
              query = "@function.outer";
              desc = "Goto Previous Function Start";
            };
            "[[" = {
              query = "@class.outer";
              desc = "Goto Previous Class Start";
            };
          };
          gotoPreviousEnd = {
            "[M" = {
              query = "@function.outer";
              desc = "Goto Previous Function End";
            };
            "[]" = {
              query = "@class.outer";
              desc = "Goto Previous Class End";
            };
          };
        };

        lspInterop = {
          enable = true;
          border = "none";

          peekDefinitionCode = {
            "<leader>ldf" = {
              query = "@function.outer";
              desc = "LSP Peek Function Definition";
            };
            "<leader>ldF" = {
              query = "@class.outer";
              desc = "LSP Peek Class Definition";
            };
          };
        };
      };
    };
  };
}
