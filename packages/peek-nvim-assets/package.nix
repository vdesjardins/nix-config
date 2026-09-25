{
  cacert,
  deno,
  fetchurl,
  fetchzip,
  lib,
  stdenvNoCC,
  vimPlugins,
}: let
  version = lib.getVersion vimPlugins.peek-nvim;
  src = vimPlugins.peek-nvim.src;

  caBundle = stdenvNoCC.mkDerivation {
    pname = "peek-nvim-ca-bundle";
    inherit version;
    dontUnpack = true;
    installPhase = ''
      cat \
        ${cacert}/etc/ssl/certs/ca-bundle.crt \
        ${../../misc/certs/zscaler-from-office.pem} \
        ${../../misc/certs/zscaler-root-cert.pem} \
        > $out
    '';
  };

  patchSources = ''
    substituteInPlace app/src/markdownit.ts \
      --replace-fail "https://esm.sh/markdown-it@14.0.0" "https://cdn.jsdelivr.net/npm/markdown-it@14.0.0/+esm" \
      --replace-fail "https://esm.sh/markdown-it-emoji@3.0.0" "https://cdn.jsdelivr.net/npm/markdown-it-emoji@3.0.0/+esm" \
      --replace-fail "https://esm.sh/markdown-it-footnote@4.0.0" "https://cdn.jsdelivr.net/npm/markdown-it-footnote@4.0.0/+esm" \
      --replace-fail "https://esm.sh/markdown-it-task-lists@2.1.1" "https://cdn.jsdelivr.net/npm/markdown-it-task-lists@2.1.1/+esm" \
      --replace-fail "https://esm.sh/markdown-it-texmath@1.0.0" "https://cdn.jsdelivr.net/npm/markdown-it-texmath@1.0.0/+esm" \
      --replace-fail "https://esm.sh/katex@0.16.9" "https://cdn.jsdelivr.net/npm/katex@0.16.9/+esm"
    substituteInPlace client/src/script.ts \
      --replace-fail "https://esm.sh/morphdom@2.7.2?no-dts" "https://cdn.jsdelivr.net/npm/morphdom@2.7.2/+esm"
    substituteInPlace client/src/mermaid.ts \
      --replace-fail "import Mermaid from 'https://cdn.skypack.dev/@types/mermaid?dts';" \
        "type Mermaid = { initialize(options: Record<string, unknown>): void; render(id: string, definition: string, container: Element): Promise<{ svg: string }> };"
  '';

  emitMod = fetchurl {
    url = "https://deno.land/x/emit@0.38.1/mod.ts";
    hash = "sha256-L6ZMTSIME7nXUpM4AwVs52lHIjZ8Ppyx7ob+n4HFh/M=";
  };

  emitUtils = fetchurl {
    url = "https://deno.land/x/emit@0.38.1/_utils.ts";
    hash = "sha256-mEEu3HqinnfVkrVPutAL3sGwXQwl63cqX47cmBPgjYg=";
  };

  emitGenerated = fetchurl {
    url = "https://deno.land/x/emit@0.38.1/emit.generated.js";
    hash = "sha256-XghG1fqkeVLlRkFaVwVjCYuTIl81vYCxTrHafFky9so=";
  };

  emitWasm = fetchurl {
    url = "https://deno.land/x/emit@0.38.1/emit_bg.wasm";
    hash = "sha256-sJkr5b2hmAKZ2hy3QQrY0xnOFiGvjE9h/ZWc2IdQhVg=";
  };

  installBuildScript = ''
    cp ${./build.ts} scripts/build-nix.ts
    mkdir scripts/nix-emit
    cp ${emitMod} scripts/nix-emit/mod.ts
    cp ${emitUtils} scripts/nix-emit/_utils.ts
    cp ${emitGenerated} scripts/nix-emit/emit.generated.js
    chmod -R u+w scripts/nix-emit
    substituteInPlace scripts/nix-emit/emit.generated.js \
      --replace-fail \
        'new URL("emit_bg.wasm", import.meta.url)' \
        'new URL("file://${emitWasm}")'
  '';

  dependencies = stdenvNoCC.mkDerivation {
    pname = "peek-nvim-dependencies";
    inherit version src;

    nativeBuildInputs = [deno];

    __structuredAttrs = true;
    outputHash = "sha256-nvReWWc6BW7yEX8Fp/O+AtPRnL0JfOt10X+rFtNqmGE=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    unsafeDiscardReferences.out = true;

    postPatch = patchSources + installBuildScript;

    buildPhase = ''
      runHook preBuild

      export HOME="$TMPDIR"
      export DENO_DIR="$PWD/deno-dir"
      for attempt in 1 2 3 4 5; do
        deno run \
          --allow-import \
          --cert ${caBundle} \
          --allow-net \
          --allow-read \
          --allow-write \
          --allow-env \
          --no-check \
          scripts/build-nix.ts \
          && break
        if [ "$attempt" -eq 5 ]; then
          exit 1
        fi
        sleep 2
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r deno-dir $out/

      runHook postInstall
    '';
  };

  githubMarkdownCss = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown.min.css";
    hash = "sha256-p6FcUux1EutsFcWT+yiWFsaYfdDjPo4HLZvj/nnu2xg=";
  };

  mermaid = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/mermaid@10.9.0/dist/mermaid.min.js";
    hash = "sha256-stuqcu2FrjYCXDOytWFA5SoUE/r3nkp6gTglzNSlavU=";
  };

  katex = fetchzip {
    url = "https://registry.npmjs.org/katex/-/katex-0.16.9.tgz";
    hash = "sha256-oJFeamTkr/aHshlL4wU38a7RK81wC1i7osxN2ikZR+M=";
  };
in
  stdenvNoCC.mkDerivation {
    pname = "peek-nvim-assets";
    inherit version src;

    nativeBuildInputs = [deno];
    postPatch = patchSources + installBuildScript;

    buildPhase = ''
      runHook preBuild

      cp -r ${dependencies}/deno-dir .
      chmod -R u+w deno-dir

      export HOME="$TMPDIR"
      export DENO_DIR="$PWD/deno-dir"
      deno run \
        --cached-only \
        --deny-net \
        --allow-read \
        --allow-write \
        --allow-env \
        --no-check \
        scripts/build-nix.ts

      cp ${mermaid} public/mermaid.min.js
      cp ${katex}/dist/katex.min.css public/
      cp -r ${katex}/dist/fonts public/
      sed \
        -e 's/@media (prefers-color-scheme:dark)/[data-theme=dark]/g' \
        -e 's/@media (prefers-color-scheme:light)/[data-theme=light]/g' \
        ${githubMarkdownCss} > public/github-markdown.min.css

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r public $out
      runHook postInstall
    '';

    meta = {
      description = "Prebuilt browser assets for peek.nvim";
      homepage = "https://github.com/toppair/peek.nvim";
      license = lib.licenses.mit;
    };
  }
