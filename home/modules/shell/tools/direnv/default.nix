{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.direnv;
in {
  options.modules.shell.tools.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      inherit (cfg) enable;

      nix-direnv = {
        enable = true;
      };

      config = {
        global = {
          hide_env_diff = true;
        };
      };

      stdlib = ''
        # move .direnv cache to xdg cache home
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';

      enableZshIntegration = true;
    };

    home.sessionVariables.DIRENV_LOG_FORMAT = "";
  };
}
