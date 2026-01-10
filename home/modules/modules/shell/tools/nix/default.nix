{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.nix;
in {
  options.modules.shell.tools.nix = {
    enable = mkEnableOption "nix";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      shellAliases = {
        proot = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"'';
        wh-system-profiles = ''sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 2d'';
        wh-hm-profiles = ''nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --older-than 2d'';
        wh-h-profiles = ''nix profile wipe-history --profile ~/.local/state/nix/profiles/profile --older-than 2d'';
      };

      initContent = ''
        # Nix profile named directories
        hash -d nix-hm="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/profile"
        hash -d nix-now=/run/current-system
        hash -d nix-boot=/nix/var/nix/profiles/system
      '';
    };
  };
}
