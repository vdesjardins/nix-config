{
  programs.nixvim.plugins.dressing = {
    enable = true;

    settings = {
      select = {
        backend = ["nui"];
      };
    };
  };
}
