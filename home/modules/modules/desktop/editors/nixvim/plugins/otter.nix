{
  programs.nixvim = {
    plugins.otter = {
      enable = true;
      autoActivate = true;
      autoLoad = true;

      settings = {
        handle_leading_whitespace = true;
        buffers = {
          write_to_disk = false;
        };
        lsp = {
          diagnostic_update_events = ["BufWritePost"];
        };
      };
    };
  };
}
