{ config, pkgs, ... }:

{
  xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
}
