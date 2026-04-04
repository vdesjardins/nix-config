_inputs: _self: super: {
  vimPlugins =
    super.vimPlugins
    // {
      rainbow-delimiters-nvim = super.vimPlugins.rainbow-delimiters-nvim.overrideAttrs (_old: {
        # The upstream patch no longer applies because the source already incorporates
        # the fix (combining 'if not success then return end' and 'if not parser then
        # return end' into 'if not success or not parser then return end').
        postPatch = "";
      });
    };
}
