{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    # TODO: waiting for harpoon2 landing in nixvim
    # plugins.harpoon = {
    #   enable = true;
    #   enableTelescope = true;
    # };

    plugins.telescope = {
      settings = {
        pickers = {
          harpoon = {
            theme = "dropdown";
          };
        };
      };
    };

    keymaps =
      [
        {
          key = "<leader>ga";
          action.__raw =
            # lua
            ''
              function()
                require("harpoon"):list():append()
              end
            '';
          options.desc = "Add File";
        }
        {
          key = "<leader>gq";
          action.__raw =
            # lua
            ''
              function()
                harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
              end
            '';
          options.desc = "Quick Menu";
        }
        {
          key = "<leader>gn";
          action.__raw =
            # lua
            ''
              function()
                require("harpoon"):list():next()
              end
            '';
          options.desc = "Next";
        }
        {
          key = "<leader>gp";
          action.__raw =
            # lua
            ''
              function()
                require("harpoon"):list():prev()
              end
            '';
          options.desc = "Previous";
        }
        {
          mode = "n";
          key = "<leader>fh";
          action.__raw =
            #lua
            ''
              function()
                  local conf = require("telescope.config").values
                  local harpoon_files = require("harpoon"):list()

                  local file_paths = {}
                  for _, item in ipairs(harpoon_files.items) do
                      table.insert(file_paths, item.value)
                  end

                  require("telescope.pickers").new({}, {
                      prompt_title = "Harpoon",
                      finder = require("telescope.finders").new_table({
                          results = file_paths,
                      }),
                      previewer = conf.file_previewer({}),
                      sorter = conf.generic_sorter({}),
                      theme = require("telescope.themes").get_dropdown({}),
                  }):find()

              end
            '';
          options.desc = "Harpoon";
        }
      ]
      ++ builtins.map (i: {
        mode = "n";
        key = "<leader>g${toString i}";
        action.__raw =
          # lua
          ''
            function()
                require("harpoon"):list():select(${toString i})
            end
          '';
        options.desc = "Goto ${toString i}";
      }) (lib.lists.range 1 9);

    extraPlugins = with pkgs.vimPlugins; [
      harpoon2
    ];
  };
}
