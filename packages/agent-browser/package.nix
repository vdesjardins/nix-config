{
  lib,
  stdenv,
  nodejs,
  fetchurl,
  makeWrapper,
  chromium,
}:
stdenv.mkDerivation {
  pname = "agent-browser";
  version = "0.8.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/agent-browser/-/agent-browser-0.8.5.tgz";
    hash = "sha512-A9mHhju6J5bIALVYpq6eO82S0PurLIYMMLte4p4IxP7pj3/D35orp4Ulinv3BJu9iJ//camM4FHoSoXQeENXqw==";
  };

  nativeBuildInputs = [makeWrapper];

  buildInputs = [nodejs chromium];

  phases = ["unpackPhase" "installPhase" "fixupPhase"];

  installPhase = ''
    # Create output directories
    mkdir -p $out/{bin,lib/node_modules/agent-browser}
    mkdir -p $out/skills

    # Copy the package content from the unpacked source
    cp -r . $out/lib/node_modules/agent-browser/

    # Create wrapper script for the CLI
    makeWrapper ${nodejs}/bin/node $out/bin/agent-browser \
      --add-flags $out/lib/node_modules/agent-browser/bin/agent-browser.js \
      --set CHROMIUM_PATH ${chromium}/bin/chromium \
      --set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1

    # Extract and expose the skill if it exists
    if [ -d "$out/lib/node_modules/agent-browser/skills/agent-browser" ]; then
      cp -r $out/lib/node_modules/agent-browser/skills/agent-browser $out/skills/
    fi
  '';

  meta = with lib; {
    description = "Headless browser automation CLI for AI agents";
    homepage = "https://github.com/vercel-labs/agent-browser";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "agent-browser";
  };
}
