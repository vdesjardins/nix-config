{ pkgs, ... }:
{
  home.packages = with pkgs; [ open-policy-agent ];
}
