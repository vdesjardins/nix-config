{pkgs, ...}: {
  programs.nixvim.plugins.rainbow-delimiters = {
    enable = true;
    # Guard against nil parser: neovim-nightly get_parser() can return nil
    # without throwing, but pcall only checks for errors, not nil returns.
    # Patch adds `if not parser then return end` after the pcall in lib.lua.
    package = pkgs.vimPlugins.rainbow-delimiters-nvim.overrideAttrs (_old: {
      postPatch = ''
        substituteInPlace lua/rainbow-delimiters/lib.lua \
          --replace-fail \
            $'\t\tsuccess, parser = pcall(get_parser, bufnr, lang)\n\t\tif not success then return end' \
            $'\t\tsuccess, parser = pcall(get_parser, bufnr, lang)\n\t\tif not success then return end\n\t\tif not parser then return end'
      '';
    });
  };
}
