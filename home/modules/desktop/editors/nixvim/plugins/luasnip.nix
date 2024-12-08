{
  programs.nixvim.plugins.luasnip = {
    enable = true;

    fromLua = [
      {}
      {
        paths = ./snippets;
      }
    ];
  };
}
