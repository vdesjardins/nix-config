{
  programs.nixvim = {
    plugins = {
      yanky = {
        enable = true;
      };

      lspkind = {
        settings = {
          cmp = {
            menu = {
              cmp_yanky = "⧉";
            };
          };
        };
      };

      cmp_yanky.enable = true;
    };
  };
}
