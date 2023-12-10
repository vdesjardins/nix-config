{...}: {
  programs.direnv = {
    enable = true;

    nix-direnv = {
      enable = true;
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
}
