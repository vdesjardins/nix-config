{pkgs, ...}: {
  programs.tmux.extraConfig = "run-shell ${pkgs.vimPlugins.smart-splits-nvim}/smart-splits.tmux";

  programs.nixvim = {
    plugins.smart-splits = {
      enable = true;
      settings = {
        disable_multiplexer_nav_when_zoomed = false;
      };
    };

    keymaps = [
      # resizing splits
      #-- these keymaps will also accept a range;
      #-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      {
        mode = "n";
        key = "<A-h>";
        action.__raw = ''require("smart-splits").resize_left'';
        options.desc = "Resize Buffer Left";
      }
      {
        mode = "n";
        key = "<A-j>";
        action.__raw = ''require("smart-splits").resize_down'';
        options.desc = "Resize Buffer Down";
      }
      {
        mode = "n";
        key = "<A-k>";
        action.__raw = ''require("smart-splits").resize_up'';
        options.desc = "Resize Buffer Up";
      }
      {
        mode = "n";
        key = "<A-l>";
        action.__raw = ''require("smart-splits").resize_right'';
        options.desc = "Resize Buffer Right";
      }

      # moving between splits
      {
        mode = "n";
        key = "<C-h>";
        action.__raw = ''require("smart-splits").move_cursor_left'';
        options.desc = "Move Cursor Left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action.__raw = ''require("smart-splits").move_cursor_down'';
        options.desc = "Move Cursor Down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action.__raw = ''require("smart-splits").move_cursor_up'';
        options.desc = "Move Cursor Up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action.__raw = ''require("smart-splits").move_cursor_right'';
        options.desc = "Move Cursor Right";
      }

      # swapping buffers between windows
      {
        mode = "n";
        key = "<leader>Bh";
        action.__raw = ''require("smart-splits").swap_buf_left'';
        options.desc = "Swap Buffer Left";
      }
      {
        mode = "n";
        key = "<leader>Bj";
        action.__raw = ''require("smart-splits").swap_buf_down'';
        options.desc = "Swap Buffer Down";
      }
      {
        mode = "n";
        key = "<leader>Bk";
        action.__raw = ''require("smart-splits").swap_buf_up'';
        options.desc = "Swap Buffer Up";
      }
      {
        mode = "n";
        key = "<leader>Bl";
        action.__raw = ''require("smart-splits").swap_buf_right'';
        options.desc = "Swap Buffer Right";
      }
    ];
  };
}
