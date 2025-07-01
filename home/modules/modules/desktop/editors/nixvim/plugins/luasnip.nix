{
  programs.nixvim = {
    plugins.luasnip = {
      enable = true;

      fromLua = [
        {}
        {
          paths = ./snippets;
        }
      ];

      settings = {
        history = true;
        updateevents = ["TextChanged" "TextChangedI"];
        region_check_events = "CursorHold";
        delete_check_events = "InsertLeave";
        ext_opts.__raw = ''
        {
          [require('luasnip.util.types').choiceNode] = {
            active = {
              virt_text = { { 'choice <c-c>', 'Comment' } },
              hl_mode = 'combine',
            },
          },
        }
        '';
      };
    };

    keymaps = [
      {
        mode = "i";
        key = "<c-c>";
        action.__raw = ''function() require("luasnip.extras.select_choice")() end'';
        options.desc = "Search";
      }
    ];
  };
}
