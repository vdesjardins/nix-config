{pkgs, ...}: {
  home.packages = with pkgs; [k9s];

  xdg.configFile."k9s/config.yml".source = ./config.yml;
  xdg.configFile."k9s/views.yml".source = ./views.yml;
}
