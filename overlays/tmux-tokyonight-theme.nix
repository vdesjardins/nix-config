inputs: _self: super: {
  tmuxPlugins =
    super.tmuxPlugins
    // {
      tokyo-night = super.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tokyonight";
        version = "unstable";
        src = inputs.tmux-tokyo-night;
        rtpFilePath = "tmux-tokyo-night.tmux";
      };
    };
}
