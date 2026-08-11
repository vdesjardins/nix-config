{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;

        nixvimInjections = true;
        highlight.enable = true;
        indent.enable = true;
      };

      hmts = {
        enable = true;
        # Patch hmts.nvim for nvim 0.13+ nightly: match tables now map
        # capture names to lists of nodes, not single nodes. Both handlers
        # must extract [1] from the list before calling node methods.
        package = pkgs.vimPlugins.hmts-nvim.overrideAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              substituteInPlace plugin/hmts.lua \
                --replace-fail \
                'local node = match[predicate[2]]:parent()' \
                'local _caps = match[predicate[2]]; local _cap = _caps and _caps[1]; if not _cap then return false end; local node = _cap:parent(); if not node then return false end'
              substituteInPlace plugin/hmts.lua \
                --replace-fail \
                'local path_node = match[predicate[2]]' \
                'local _pn = match[predicate[2]]; local path_node = _pn and _pn[1]; if not path_node then return end'
            '';
        });
      };

      treesitter-context = {
        enable = true;

        settings = {
          max_lines = 4;
          min_window_height = 40;
          multiwindow = true;
          separator = "-";
        };
      };

      treesitter-textobjects.enable = true;
    };

    extraConfigLua = ''
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local swap = require("nvim-treesitter-textobjects.swap")
      local move = require("nvim-treesitter-textobjects.move")

      local function map_select(key, query, description)
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end, { desc = description })
      end

      map_select("af", "@function.outer", "Select outer part of function")
      map_select("if", "@function.inner", "Select inner part of function")
      map_select("ac", "@class.outer", "Select outer part of class")
      map_select("ic", "@class.inner", "Select inner part of class")

      vim.keymap.set("n", "<leader>ln", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>lp", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap with previous parameter" })

      local function map_move(key, method, query, description)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          move[method](query, "textobjects")
        end, { desc = description })
      end

      map_move("]m", "goto_next_start", "@function.outer", "Goto next function start")
      map_move("]]", "goto_next_start", "@class.outer", "Goto next class start")
      map_move("]M", "goto_next_end", "@function.outer", "Goto next function end")
      map_move("][", "goto_next_end", "@class.outer", "Goto next class end")
      map_move("[m", "goto_previous_start", "@function.outer", "Goto previous function start")
      map_move("[[", "goto_previous_start", "@class.outer", "Goto previous class start")
      map_move("[M", "goto_previous_end", "@function.outer", "Goto previous function end")
      map_move("[]", "goto_previous_end", "@class.outer", "Goto previous class end")
    '';

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
