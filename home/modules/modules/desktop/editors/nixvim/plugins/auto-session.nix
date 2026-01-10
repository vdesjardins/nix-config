{
  programs.nixvim = {
    plugins.auto-session.enable = true;

    extraConfigLua = ''
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    '';
  };
}
