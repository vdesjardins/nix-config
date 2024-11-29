{
  programs.nixvim = {
    plugins.flash = {
      enable = true;

      settings = {
        modes = {
          search = {
            enabled = true;
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "s";
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash";
      }
      {
        mode = "x";
        key = "s";
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash";
      }
      {
        mode = "o";
        key = "s";
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash";
      }
      {
        mode = "n";
        key = "S";
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash Treesitter";
      }
      {
        mode = "x";
        key = "S";
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash Treesitter";
      }
      {
        mode = "o";
        key = "S";
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash Treesitter";
      }
      {
        mode = "o";
        key = "r";
        action.__raw = ''function() require("flash").remote() end'';
        options.desc = "Remote Flash";
      }
      {
        mode = "o";
        key = "R";
        action.__raw = ''function() require("flash").treesitter_search() end'';
        options.desc = "Treesitter Search";
      }
      {
        mode = "x";
        key = "R";
        action.__raw = ''function() require("flash").treesitter_search() end'';
        options.desc = "Treesitter Search";
      }
      {
        mode = "c";
        key = "<c-s>";
        action.__raw = ''function() require("flash").toggle() end'';
        options.desc = "Toggle Flash Search";
      }
    ];
  };
}