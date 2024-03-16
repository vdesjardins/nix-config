{pkgs, ...}: {
  packages = with pkgs; [
    alejandra
    statix
    nixd
  ];

  zsh.shellAliases = {
    proot = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"'';
    wh-system-profiles = ''sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 2d'';
    wh-hm-profiles = ''nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --older-than 2d'';
    wh-h-profiles = ''nix profile wipe-history --profile ~/.local/state/nix/profiles/profile --older-than 2d'';
  };
}
