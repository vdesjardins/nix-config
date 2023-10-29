# https://github.com/nix-community/home-manager/issues/1341#issuecomment-1716147796
{
  config,
  pkgs,
  lib,
  ...
} @ args:
with lib;
  mkMerge [
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.activation = {
        trampolineApps = let
          apps = pkgs.buildEnv {
            name = "home-manager-applications";
            paths = config.home.packages;
            pathsToLink = "/Applications";
          };
        in
          lib.hm.dag.entryAfter ["writeBoundary"] ''
            toDir="$HOME/Applications/Home Manager Trampolines"
            fromDir="${apps}/Applications"
            rm -rf "$toDir"
            mkdir "$toDir"
            (
              cd "$fromDir"
              for app in *.app; do
                /usr/bin/osacompile -o "$toDir/$app" -e 'do shell script "open \"'$fromDir/$app'\""'
                icon="$(/usr/bin/plutil -extract CFBundleIconFile raw "$fromDir/$app/Contents/Info.plist")"
                mkdir -p "$toDir/$app/Contents/Resources"
                if [[ -f "$fromDir/$app/Contents/Resources/$icon" ]]; then
                  cp -f "$fromDir/$app/Contents/Resources/$icon" "$toDir/$app/Contents/Resources/applet.icns"
                fi
              done
            )
          '';
      };
    })
  ]
