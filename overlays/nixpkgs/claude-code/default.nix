_inputs: self: super: {
  claude-code = super.buildNpmPackage (finalAttrs: {
    pname = "claude-code";
    version = "2.1.92";

    src = super.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${finalAttrs.version}.tgz";
      hash = "sha256-//iF+Rbms6cYU1WWAa8Sq7G2RxTPwvBjWiVhO5Z0k0c=";
    };

    npmDepsHash = "sha256-5LvH7fG5pti2SiXHQqgRxfFpxaXxzrmGxIoPR4dGE+8=";

    strictDeps = true;

    postPatch = ''
      cp ${./package-lock.json} package-lock.json

      # https://github.com/anthropics/claude-code/issues/15195
      substituteInPlace cli.js \
        --replace-fail '#!/bin/sh' '#!/usr/bin/env sh'
    '';

    dontNpmBuild = true;

    env.AUTHORIZED = "1";

    # `claude-code` tries to auto-update by default, this disables that functionality.
    postInstall = ''
      wrapProgram $out/bin/claude \
        --set DISABLE_AUTOUPDATER 1 \
        --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
        --set DISABLE_INSTALLATION_CHECKS 1 \
        --unset DEV \
        --prefix PATH : ${
        super.lib.makeBinPath (
          [
            super.procps
          ]
          ++ super.lib.optionals super.stdenv.hostPlatform.isLinux [
            super.bubblewrap
            super.socat
          ]
        )
      }
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [
      self.writableTmpDirAsHomeHook
      self.versionCheckHook
    ];
    versionCheckKeepEnvironment = ["HOME"];

    meta = {
      description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
      homepage = "https://github.com/anthropics/claude-code";
      downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
      license = super.lib.licenses.unfree;
      mainProgram = "claude";
    };
  });
}
