{
  programs.nixvim = {
    plugins.vim-matchup = {
      enable = true;

      treesitter.enable = true;
    };
  };

  xdg.configFile."nvim/queries/nix/matchup.scm".text = let
    delim = "''";
  in ''
    (indented_string_expression
      "${delim}" @open.string
      (string_fragment)
      "${delim}" @close.string) @scope.string
  '';
}
