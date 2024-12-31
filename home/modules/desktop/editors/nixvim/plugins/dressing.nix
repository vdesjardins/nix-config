{
  programs.nixvim.plugins.dressing = {
    enable = true;

    settings = {
      select = {
        backend = ["fzf_lua" "telescope" "fzf" "builtin" "nui"];
      };
    };
  };
}
