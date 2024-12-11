{
  programs.nixvim.plugins.mini = {
    enable = true;

    modules = {
      icons = {};
      files = {};
      surround = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };
    };
  };
}
