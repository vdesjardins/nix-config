{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      kcl
    ];

    extraConfigLua = ''
    '';
  };
}
