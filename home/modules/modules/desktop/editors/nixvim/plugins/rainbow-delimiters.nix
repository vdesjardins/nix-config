{...}: {
  programs.nixvim.plugins.rainbow-delimiters = {
    enable = true;
    # The upstream 0.11.0 source already incorporates the nil-parser guard
    # (combining 'if not success then return end' and 'if not parser then
    # return end' into 'if not success or not parser then return end'), so
    # no patch is needed.
  };
}
