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
  version = "0.58.1-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "8c15cbba6eea860c4161bf3b2e0ea11be9ca4942";
    sha256 = "sha256-cr/wlwXk+SIvHEN+9kVsE59gX/0EWF+5JKYFs6Va4k8=";
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
