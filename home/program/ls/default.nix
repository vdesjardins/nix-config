{ config, pkgs, ... }: {
  home.file.".dircolors".source = builtins.fetchurl {
    name = "dircolors";
    url =
      "https://raw.githubusercontent.com/trapd00r/LS_COLORS/a7017a72ff04579d150551f5ec2cb26145aff6e7/LS_COLORS";
    sha256 = "10cb84hnhqggcn93h1njcvlgabmfyg06q76imjd10c248ff4ky13";
  };

  programs.zsh.initExtra = ''
    source <(dircolors ${
      config.home.homeDirectory + "/" + config.home.file.".dircolors".target
    })
  '';
}
