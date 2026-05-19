{
  programs.nixvim.plugins.dropbar = {
    enable = true;
    settings.bar.update_events.buf = [
      # 'BufModifiedSet' is not available in this Neovim build
      "FileChangedShellPost"
      "TextChanged"
      "ModeChanged"
    ];
  };
}
