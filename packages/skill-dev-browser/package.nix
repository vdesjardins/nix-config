{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
  nodejs,
  bash,
  stdenv,
  chromium,
}: let
  skill-dev-browser = buildNpmPackage rec {
    pname = "skill-dev-browser";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "SawyerHood";
      repo = "dev-browser";
      rev = "v${version}";
      hash = "sha256-PRd6e5RN4wQ43qdNtPCtAIZ5RZOHn6UD8aYxJOfe7RA=";
    };

    sourceRoot = "${src.name}/skills/dev-browser";

    npmDepsHash = "sha256-jox766OaC9P6LH1xg5oHDifl8fz1wdkuzE6mnrOkg+o=";

    nativeBuildInputs = [];

    # Runtime dependencies needed for Playwright to work on NixOS
    buildInputs = [bash chromium];

    dontNpmBuild = true;

    # Tell npm to install both prod and dev dependencies
    npmFlags = ["--include=dev"];

    # Prevent Playwright from trying to download its own Chromium binary
    # We'll use the Nix-packaged chromium instead
    npm_config_ignore_scripts = true;

    preBuild = ''
      # Patch the source code to point to Nix's chromium binary
      # This modifies index.ts to pass the executable path to Playwright
      sed -i 's|headless,|headless,\n    executablePath: "${chromium}/bin/chromium",|' src/index.ts

      # Patch start-server.ts to use environment variables for tmp/profiles directories
      # This allows isolated temp directories to work properly with symlinked scripts/
      # Use printf and read to avoid sed escaping complexities
      {
        tmpdir_orig='const tmpDir = join(__dirname, "..", "tmp");'
        tmpdir_new='const tmpDir = process.env.DEV_BROWSER_TMP_DIR || join(__dirname, "..", "tmp");'
        sed -i "s^$tmpdir_orig^$tmpdir_new^" scripts/start-server.ts

        profiledir_orig='const profileDir = join(__dirname, "..", "profiles");'
        profiledir_new='const profileDir = process.env.DEV_BROWSER_PROFILES_DIR || join(__dirname, "..", "profiles");'
        sed -i "s^$profiledir_orig^$profiledir_new^" scripts/start-server.ts
      }
    '';

    postInstall = ''
      # Copy the entire skill directory structure
      mkdir -p $out/skills/dev-browser
      cp -r . $out/skills/dev-browser/

      # Copy wrapper scripts and shared setup from local directory
      cp ${./setup-work-env.sh} "$out/skills/dev-browser/setup-work-env.sh"
      cp ${./server.sh} "$out/skills/dev-browser/server.sh"
      cp ${./start-extension.sh} "$out/skills/dev-browser/start-extension.sh"
      cp ${./run-script.sh} "$out/skills/dev-browser/run-script.sh"

      # Substitute Nix paths into the shared setup script
      substituteInPlace "$out/skills/dev-browser/setup-work-env.sh" \
        --replace-quiet '@nodejs@' '${nodejs}' \
        --replace-quiet '@chromium@' '${chromium}'

      # Substitute Nix paths into the wrapper scripts
      substituteInPlace "$out/skills/dev-browser/server.sh" \
        --replace-quiet '@nodejs@' '${nodejs}' \
        --replace-quiet '@chromium@' '${chromium}'

      substituteInPlace "$out/skills/dev-browser/start-extension.sh" \
        --replace-quiet '@nodejs@' '${nodejs}' \
        --replace-quiet '@chromium@' '${chromium}'

      substituteInPlace "$out/skills/dev-browser/run-script.sh" \
        --replace-quiet '@nodejs@' '${nodejs}' \
        --replace-quiet '@chromium@' '${chromium}'

      patchShebangs $out/skills/dev-browser/

      # Make all wrapper scripts and setup executable
      chmod +x "$out/skills/dev-browser/setup-work-env.sh"
      chmod +x "$out/skills/dev-browser/server.sh"
      chmod +x "$out/skills/dev-browser/start-extension.sh"
      chmod +x "$out/skills/dev-browser/run-script.sh"

      # Patch SKILL.md to use our patched scripts instead of npm commands
      substituteInPlace "$out/skills/dev-browser/SKILL.md" \
        --replace-quiet 'cd skills/dev-browser && npm i && npm run start-extension &' './skills/dev-browser/start-extension.sh &'

      # Also patch the inline script examples to use run-script.sh wrapper
      substituteInPlace "$out/skills/dev-browser/SKILL.md" \
        --replace-quiet 'cd skills/dev-browser && npx tsx' './skills/dev-browser/run-script.sh'
    '';

    postFixup = ''
      # Create a wrapper script for Playwright to find the Chromium binary
      # This helps Playwright detect and use the Nix-packaged Chromium
      mkdir -p $out/bin
      cat > $out/bin/chromium-wrapper << 'WRAPPER'
      #!/bin/bash
      # This wrapper ensures Playwright can find Chromium on NixOS
      export CHROMIUM_PATH="${chromium}/bin/chromium"
      export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
      exec "${chromium}/bin/chromium" "$@"
      WRAPPER
      chmod +x $out/bin/chromium-wrapper
    '';

    passthru.tests = {
      basic = stdenv.mkDerivation {
        name = "dev-browser-tests";
        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;

        buildPhase = ''
          cat > run-tests.sh << 'TEST_SCRIPT'
          #!/bin/bash
          # Test suite for dev-browser package

          PKG="''${1:-.}"
          PASSED=0
          FAILED=0

          test_check() {
            local name="$1"
            local cmd="$2"

            if eval "$cmd" >/dev/null 2>&1; then
              echo "✓ $name"
              PASSED=$((PASSED + 1))
            else
              echo "✗ $name"
              FAILED=$((FAILED + 1))
            fi
          }

          echo "=== dev-browser Package Tests ==="
          echo ""
          # Test scripts exist
          test_check "setup-work-env.sh shared function" "[ -x \"$PKG/skills/dev-browser/setup-work-env.sh\" ]"
          test_check "server.sh script" "[ -x \"$PKG/skills/dev-browser/server.sh\" ]"
          test_check "start-extension.sh script" "[ -x \"$PKG/skills/dev-browser/start-extension.sh\" ]"
          test_check "run-script.sh wrapper" "[ -x \"$PKG/skills/dev-browser/run-script.sh\" ]"

          # Test shebangs are valid
          test_check "setup-work-env.sh shebang patched" "head -1 \"$PKG/skills/dev-browser/setup-work-env.sh\" | grep -E 'bash|env'"
          test_check "server.sh shebang patched" "head -1 \"$PKG/skills/dev-browser/server.sh\" | grep -E 'bash|env'"
          test_check "start-extension.sh shebang patched" "head -1 \"$PKG/skills/dev-browser/start-extension.sh\" | grep -E 'bash|env'"

          # Test scripts use shared setup function
          test_check "server.sh sources setup-work-env.sh" "grep -q 'source.*setup-work-env.sh' \"$PKG/skills/dev-browser/server.sh\""
          test_check "start-extension.sh sources setup-work-env.sh" "grep -q 'source.*setup-work-env.sh' \"$PKG/skills/dev-browser/start-extension.sh\""
          test_check "run-script.sh sources setup-work-env.sh" "grep -q 'source.*setup-work-env.sh' \"$PKG/skills/dev-browser/run-script.sh\""

          # Test scripts do NOT have npm install (deps already packaged)
          test_check "server.sh has no npm install" "! grep -q 'npm install' \"$PKG/skills/dev-browser/server.sh\""
          test_check "start-extension.sh has no npm install" "! grep -q 'npm install' \"$PKG/skills/dev-browser/start-extension.sh\""

          # Test file structure
          test_check "package.json exists" "[ -f \"$PKG/skills/dev-browser/package.json\" ]"
          test_check "src directory" "[ -d \"$PKG/skills/dev-browser/src\" ]"
          test_check "scripts directory" "[ -d \"$PKG/skills/dev-browser/scripts\" ]"
          test_check "node_modules installed" "[ -d \"$PKG/skills/dev-browser/node_modules\" ]"

          # Test key dependencies
          test_check "playwright installed" "[ -d \"$PKG/skills/dev-browser/node_modules/playwright\" ]"
          test_check "hono installed" "[ -d \"$PKG/skills/dev-browser/node_modules/hono\" ]"
          test_check "express installed" "[ -d \"$PKG/skills/dev-browser/node_modules/express\" ]"
          test_check "tsx installed" "[ -d \"$PKG/skills/dev-browser/node_modules/tsx\" ]"

          # Test npm-style installation
          test_check "npm-style node_modules" "[ -d \"$PKG/lib/node_modules/dev-browser\" ]"

          # Test SKILL.md is patched
          test_check "SKILL.md has no npm i" "! grep -q 'npm i' \"$PKG/skills/dev-browser/SKILL.md\""
          test_check "SKILL.md uses start-extension.sh" "grep -q './skills/dev-browser/start-extension.sh' \"$PKG/skills/dev-browser/SKILL.md\""

          echo ""
          echo "=== Results ==="
          echo "Passed: $PASSED"
          echo "Failed: $FAILED"

          if [ $FAILED -eq 0 ]; then
            echo "✓ All tests passed!"
            exit 0
          else
            echo "✗ Some tests failed!"
            exit 1
          fi
          TEST_SCRIPT
          chmod +x run-tests.sh
          bash run-tests.sh ${skill-dev-browser}
        '';

        installPhase = "mkdir -p $out && touch $out/test-passed";
      };
    };

    meta = with lib; {
      description = "A Claude Skill to give your agent the ability to use a web browser";
      homepage = "https://github.com/SawyerHood/dev-browser";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
in
  skill-dev-browser
