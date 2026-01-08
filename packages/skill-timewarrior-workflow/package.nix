{
  stdenv,
  lib,
  python3,
  timewarrior,
}: let
  pytest = python3.pkgs.pytest;
  skill-timewarrior-workflow = stdenv.mkDerivation {
    pname = "skill-timewarrior-workflow";
    version = "1.0.0";

    # Use local files as source
    src = ./.;

    # Make dependencies available during build
    # python3 is in nativeBuildInputs so patchShebangs will auto-discover it
    nativeBuildInputs = [python3 pytest];
    buildInputs = [timewarrior];

    # Skip default phases - we're just copying and patching
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      # Create output directory structure
      mkdir -p $out/skills/timewarrior-workflow

      # Copy SKILL.md
      cp SKILL.md $out/skills/timewarrior-workflow/

      # Copy scripts directory
      cp -r scripts $out/skills/timewarrior-workflow/

      # Make scripts executable
      chmod +x $out/skills/timewarrior-workflow/scripts/*.py

      # Patch all shebangs in one go - patchShebangs auto-discovers python3
      # from nativeBuildInputs
      patchShebangs $out/skills/timewarrior-workflow/scripts/
    '';

    checkPhase = ''
      echo "=== Running Pytest Test Suite ==="
      echo ""

      # Run pytest with verbose output
      ${pytest}/bin/pytest tests/ -v --tb=short

      echo ""
      echo "=== Test Results ==="
      echo "All tests passed successfully!"
    '';

    meta = with lib; {
      description = "Timewarrior time tracking skill for OpenCode AI with Python-based tag management and analytics";
      homepage = "https://timewarrior.net/";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = ["vdesjardins"];
    };
  };
in
  skill-timewarrior-workflow
