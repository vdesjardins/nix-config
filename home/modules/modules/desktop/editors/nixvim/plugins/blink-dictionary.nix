{pkgs, ...}: {
  programs.nixvim = {
    plugins.blink-cmp-dictionary = {
      enable = true;

      package = pkgs.vimPlugins.blink-cmp-dictionary;
    };

    extraPackages = with pkgs; [
      wordnet
    ];
  };

  home.file.".config/dictionaries/english-words.txt".source = "${pkgs.english-words}/share/english-words/words.txt";
}
