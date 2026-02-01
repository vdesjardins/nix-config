{
  bubblewrap,
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "opencode-sandbox";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [];

  dontBuild = false;

  # Substitute variables in scripts with resolved paths
  buildPhase = ''
    for script in bin/*; do
      if [ -f "$script" ]; then
        substituteInPlace "$script" \
          --replace '@bubblewrap@' '${bubblewrap}'
        chmod +x "$script"
      fi
    done
  '';

  installPhase = ''
    mkdir -p $out/bin

    # Copy and install bin scripts
    for script in bin/*; do
      if [ -f "$script" ]; then
        scriptName=$(basename "$script")
        install -m 755 "$script" $out/bin/$scriptName
      fi
    done
  '';

  meta = {
    description = "Minimal bubblewrap sandbox for AI agents - supports arbitrary commands, network isolation, and custom mounts";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "opencode-sandbox";
  };
}
