{
  fetchFromGitHub,
  gnugrep,
  jq,
  lib,
  stdenv,
  tmux,
}:
stdenv.mkDerivation {
  pname = "skill-tmux";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "master";
    sha256 = "sha256-a4CYvUoWVrvWo79G8uakuBtgaJkiq8t70yYDQGtKVQQ=";
  };

  sourceRoot = "source/plugins/tmux";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/tmux
    cp -r . ${placeholder "out"}/skills/tmux

    # Create PATH with all required tools
    PATH_LINE="export PATH=\"${lib.makeBinPath [tmux jq gnugrep]}:\$PATH\""

    # Inject PATH into all shell scripts (after shebang on line 2)
    find ${placeholder "out"}/skills/tmux/tools -maxdepth 2 -type f -name "*.sh" | while read script; do
      sed -i "2i $PATH_LINE" "$script"
      chmod +x "$script"
    done
  '';
}
