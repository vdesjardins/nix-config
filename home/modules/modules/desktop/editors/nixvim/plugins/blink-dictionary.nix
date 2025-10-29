{
  my-packages,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins.blink-cmp-dictionary = {
      enable = true;

      package = my-packages.vimPlugins-blink-cmp-dictionary;
    };

    extraPackages = with pkgs; [
      wordnet
    ];
  };

  home.file.".config/dictionaries/english-words.txt".source = "${my-packages.english-words}/share/english-words/words.txt";
}
