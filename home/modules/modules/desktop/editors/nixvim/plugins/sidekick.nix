{my-packages, ...}: {
  programs.nixvim = {
    plugins.sidekick = {
      enable = true;
      package = my-packages.vimPlugins-sidekick-nvim;

      settings = {
        cli = {
          win = {
            keys = {
              buffers = {
                __unkeyed-1 = "<C-b>";
                __unkeyed-2 = "buffers";
                mode = "t";
                desc = "open buffer picker";
              };
              files = {
                __unkeyed-1 = "<C-f>";
                __unkeyed-2 = "files";
                mode = "t";
                desc = "open file picker";
              };
            };
          };
        };
      };
    };

    keymaps = [
      {
        key = "<tab>";
        action.__raw = ''
          function()
            -- if there is a next edit, jump to it, otherwise apply it if any
            if not require("sidekick").nes_jump_or_apply() then
              return "<Tab>" -- fallback to normal tab
            end
          end'';
        options.expr = true;
        options.desc = "Goto/Apply Next Edit Suggestion";
      }
      {
        key = "<c-.>";
        action.__raw = ''function() require("sidekick.cli").toggle() end'';
        options.desc = "Sidekick Toggle";
        mode = ["n" "t" "i" "x"];
      }
      {
        key = "<leader>aa";
        action.__raw = ''function() require("sidekick.cli").toggle() end'';
        options.desc = "Sidekick Toggle CLI";
      }
      {
        key = "<leader>as";
        action.__raw = ''function() require("sidekick.cli").select({ filter = { installed = true } }) end'';
        options.desc = "Select CLI";
      }
      {
        key = "<leader>ad";
        action.__raw = ''function() require("sidekick.cli").close() end'';
        options.desc = "Detach a CLI Session";
      }
      {
        key = "<leader>at";
        action.__raw = ''function() require("sidekick.cli").send({ msg = "{this}" }) end'';
        mode = ["x" "n"];
        options.desc = "Send This";
      }
      {
        key = "<leader>af";
        action.__raw = ''function() require("sidekick.cli").send({ msg = "{file}" }) end'';
        options.desc = "Send File";
      }
      {
        key = "<leader>av";
        action.__raw = ''function() require("sidekick.cli").send({ msg = "{selection}" }) end'';
        mode = ["x"];
        options.desc = "Send Visual Selection";
      }
      {
        key = "<leader>ap";
        action.__raw = ''function() require("sidekick.cli").prompt() end'';
        mode = ["n" "x"];
        options.desc = "Sidekick Select Prompt";
      }
      {
        key = "<leader>ac";
        action.__raw = ''function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end'';
        options.desc = "Sidekick Toggle Codex";
      }
      {
        key = "<leader>aC";
        action.__raw = ''function() require("sidekick.cli").toggle({ name = "claud", focus = true }) end'';
        options.desc = "Sidekick Toggle Claude";
      }
      {
        key = "<leader>ag";
        action.__raw = ''function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end'';
        options.desc = "Sidekick Toggle Copilot";
      }
      {
        key = "<leader>ao";
        action.__raw = ''function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end'';
        options.desc = "Sidekick Toggle Opencode";
      }
    ];
  };
}
