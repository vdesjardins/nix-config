{ config, lib, ... }:

with lib;

{
  programs.broot = { enable = true; };
}
