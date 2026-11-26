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
  version = "0.61.0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "9697a122369ef8fb4eee8822765b9d96bf770831";
    sha256 = "sha256-sH6qGztZD2azM9/YLp1yy8+aVZVK6e0XkhFuDUEgGQs=";
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
