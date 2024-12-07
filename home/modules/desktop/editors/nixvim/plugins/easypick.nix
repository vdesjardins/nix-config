{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      easypick-nvim
    ];

    extraConfigLua = ''
      local easypick = require("easypick")

      local list_make_targets = [[
      sed -n 's/^##//p' Makefile | column -t -s ':' |  sed -e 's/^/ /'
      ]]

      easypick.setup({
          pickers = {
              -- list modified files
              {
                  name = "modified_files",
                  command = "git diff --name-only --diff-filter=d; git diff --name-only --cached; git ls-files --exclude-standard -o",
                  previewer = easypick.previewers.file_diff(),
                  opts = require("telescope.themes").get_dropdown({}),
              },

              -- list files that have conflicts with diffs in preview
              {
                  name = "conflicts",
                  command = "git diff --name-only --diff-filter=U --relative",
                  previewer = easypick.previewers.file_diff(),
                  opts = require("telescope.themes").get_dropdown({}),
              },

              -- list make targets to exec
              {
                  name = "make_targets",
                  command = list_make_targets,
                  action = easypick.actions.nvim_commandf("1TermExec name=make cmd=\"make %s\""),
                  opts = require("telescope.themes").get_dropdown({}),
              },
          },
      })
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>Easypick conflicts<cr>";
        options.desc = "File Conflicts";
      }
      {
        mode = "n";
        key = "<leader>fM";
        action = "<cmd>Easypick modified_files<cr>";
        options.desc = "Files Modified";
      }
      {
        mode = "n";
        key = "<leader>em";
        action = "<cmd>Easypick make_targets<cr>";
        options.desc = "Make Targets";
      }
    ];
  };
}
