{ pkgs, ... }:
{
  packages = with pkgs; [
    vscode-langservers-extracted
  ];
}

