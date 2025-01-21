{
  programs.nixvim = {
    plugins = {
      yanky = {
        enable = true;
      };

      lspkind = {
        cmp = {
          menu = {
            cmp_yanky = "⧉";
          };
        };
      };

      cmp_yanky.enable = true;
    };
  };
}
