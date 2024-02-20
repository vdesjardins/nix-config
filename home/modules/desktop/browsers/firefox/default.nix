{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) hasAttr;
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.lists) concatMap;
  inherit (lib.types) listOf attrs;

  defaultExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
    {
      package = darkreader;
      area = "navbar";
    }
    {package = firefox-color;}
    {package = dictionaries;}
    {package = qr-code-address-bar;}
    {package = duckduckgo-privacy-essentials;}
    {
      package = buildFirefoxXpiAddon {
        pname = "add-url-to-window-title";
        version = "2.2.1";
        addonId = "autt@ericgoldman.name";
        url = "https://addons.mozilla.org/firefox/downloads/file/1685708/add_url_to_window_title-2.2.1.xpi";
        sha256 = "sha256-teUYOE26S6ikPNQ/F+QTqZlzw+2/5e2nxve9Q8pR4l0=";
        meta = with lib; {platforms = platforms.all;};
      };
    }
    # {
    #   # color scheme tokyonight storm from https://github.com/lokesh-krishna/dotfiles/tree/main/tokyo-night
    #   # generated with firefox-color from url: https://color.firefox.com/?theme=XQAAAAKPAgAAAAAAAABBqYhm849SCicxcUJJ2CuG_ebZUZXOFqpMUXOqPCZ36qSRJkXN52FbbTjiyK1MWFJNETZQ0wYF4uVCIywstutBMeAW7Obsj80UcPJQAnIVpdPOctZ5qwuxzdELFY4rFOFPOTJ56RTVDwA4OBpstebirCu7hY0081_kMAs5kyLOhcBXVznGEJZ8hLEKcsRDWIpmds_f9Bz4MLMjGF7kJmKEH1RnLL_dJvGnMgclfyzqTqHxYRhUWrgMfQmbcvGavbRFEetLZGVRbQ5P8k0F0PyfAFgTc6TBQIiKVQa2zX8gZ3Gru31J5KGfZrIaMw2B-eKScfJjrqEILop2n4DLLEe_lqL3ujDgM0Uv8i9nwGVvvQNj_vGGxQ
    #   package =
    #     (buildFirefoxXpiAddon {
    #       pname = "tokyonight-storm-theme";
    #       version = "0.0.1";
    #       addonId = "tokyonight-storm-theme@0.0.1";
    #       url = "file://./theme.xpi";
    #       sha256 = lib.fakeSha256;
    #       meta = with lib; {platforms = platforms.all;};
    #     })
    #     .overrideAttrs
    #     (old: {
    #       src = ./theme.xpi;
    #     });
    # }
  ];

  cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = {
    enable = mkEnableOption "firefox browser";

    extensions = mkOption {
      type = listOf attrs;
      default = [];
    };
  };

  config = mkIf cfg.enable (let
    inherit (pkgs.stdenv) isDarwin;
    inherit (builtins) listToAttrs;

    extensions = defaultExtensions ++ cfg.extensions;

    mozillaConfigPath =
      if isDarwin
      then "Library/Application Support/Mozilla"
      else ".mozilla";

    firefoxConfigPath =
      if isDarwin
      then "Library/Application Support/Firefox"
      else "${mozillaConfigPath}/firefox";

    profilesPath =
      if isDarwin
      then "${firefoxConfigPath}/Profiles"
      else firefoxConfigPath;

    extensionPolicies = listToAttrs (map (e: {
        name = e.package.addonId;
        value = {
          installation_mode = "normal_installed";
          install_url = "file://${e.package.out}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${e.package.addonId}.xpi";
          default_area =
            if hasAttr "area" e
            then e.area
            else "menupanel";
        };
      })
      extensions);

    nativeMessagingHosts = concatMap (e:
      if hasAttr "nativeMessagingHost" e
      then [e.nativeMessagingHost]
      else [])
    extensions;
  in {
    programs.firefox = {
      inherit (cfg) enable;

      package =
        if pkgs.stdenv.isDarwin
        then null # unable to compile on M1. Relying on brew for now
        else
          pkgs.firefox-wayland.override {
            inherit nativeMessagingHosts;
          };

      policies = {
        ExtensionSettings =
          {
            "*" = {
              "installation_mode" = "allowed";
              "allowed_types" = ["extension" "theme" "dictionary"];
            };
          }
          // extensionPolicies;
      };

      profiles = {
        default = {
          name = "Default";
          id = 0;
          search = {
            force = true;

            default = "DuckDuckGo";
            order = ["DuckDuckGo" "Google"];

            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };
              "NixOS Wiki" = {
                urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@nw"];
              };
              "GitHub" = {
                urls = [
                  {
                    template = "https://github.com/search?q={searchTerms}";
                    params = [
                      {
                        name = "type";
                        value = "code";
                      }
                    ];
                  }
                ];
                iconUpdateURL = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@gh"];
              };
              "GitHub (Nix)" = {
                urls = [
                  {
                    template = "https://github.com/search?q=language:nix+{searchTerms}";
                    params = [
                      {
                        name = "type";
                        value = "code";
                      }
                    ];
                  }
                ];
                iconUpdateURL = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ghn"];
              };
              "GitHub (Nixpkgs)" = {
                urls = [
                  {
                    template = "https://github.com/search?q=language:nix+repo:nixos/nixpkgs+{searchTerms}";
                    params = [
                      {
                        name = "type";
                        value = "code";
                      }
                    ];
                  }
                ];
                iconUpdateURL = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ghnp"];
              };
              "GitHub (home-manager)" = {
                urls = [
                  {
                    template = "https://github.com/search?q=language:nix+repo:nix-community/home-manager+{searchTerms}";
                    params = [
                      {
                        name = "type";
                        value = "code";
                      }
                    ];
                  }
                ];
                iconUpdateURL = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ghnh"];
              };
              "Wikipedia (en)".metaData.alias = "@w";
              "Google".metaData.alias = "@g";
              "Amazon.ca".metaData.alias = "@a";
              "Bing".metaData.hidden = true;
              "eBay".metaData.hidden = true;
            };
          };

          settings = {
            "browser.ctrlTab.sortByRecentlyUsed" = true;
            "layout.css.prefers-color-scheme.content-override" = 0;
            "browser.startup.page" = 3;
            "browser.aboutConfig.showWarning" = false;
            "browser.aboutwelcome.enabled" = false;
            "browser.contentblocking.category" = "strict";
            "browser.tabs.warnOnClose" = false;
            "browser.tabs.bookmarks.visibility" = "newtab";
            "browser.warnOnQuit" = false;
            "extensions.pocket.enabled" = false;
            "identity.fxaccounts.toolbar.enabled" = false;
            "signon.rememberSignons" = false;

            # Extension recommendation
            "browser.discovery.enabled" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

            "intl.locale.requested" = "en-CA,en-US,fr";
            "intl.accept_languages" = "en-CA,en-US,en,fr-CA,fr";

            "browser.policies.loglevel" = "debug";
          };
        };
      };
    };

    wayland.windowManager.sway.config = {
      window.commands = [
        {
          criteria = {
            app_id = "^firefox$";
            title = "www.youtube.com";
          };
          command = "move container to workspace 7";
        }
        {
          criteria = {
            app_id = "^firefox$";
            title = "discord.com";
          };
          command = "move container to workspace 7";
        }
        {
          criteria = {
            app_id = "^firefox$";
            title = "calendar.google.com";
          };
          command = "move container to workspace 8";
        }
        {
          criteria = {
            app_id = "^firefox$";
            title = "mail.google.com";
          };
          command = "move container to workspace 9";
        }
        {
          criteria = {
            app_id = "^firefox$";
            title = "mail.proton.me";
          };
          command = "move container to workspace 9";
        }
        {
          criteria = {
            app_id = "^firefox$";
            title = "^Picture-in-Picture$";
          };
          command = "floating enable, sticky enable, border pixel 0, move position 1340 722, opacity 0.95";
        }
      ];
    };

    home.activation = {
      firefoxPermissions = let
        inherit (pkgs.stdenv) isDarwin;

        permissions = {
          "https:enixpkgs/mail.google.com" = {
            "desktop-notification" = "allow";
            "storageAccessAPI" = "allow";
          };
          "https://mail.libproton.me" = {
            "desktop-notification" = "allow";
            "storageAccessAPI" = "allow";
          };
          "https://calendar.google.com" = {
            "desktop-notification" = "allow";
            "storageAccessAPI" = "allow";
          };
        };

        db = lib.escapeShellArg "${profilesPath}/default/permissions.sqlite";

        schema = pkgs.writeText "schema.sql" ''
          CREATE TABLE moz_perms ( id INTEGER PRIMARY KEY,origin TEXT,type TEXT,permission INTEGER,expireType INTEGER,expireTime INTEGER,modificationTime INTEGER);
          CREATE TABLE moz_hosts ( id INTEGER PRIMARY KEY,host TEXT,type TEXT,permission INTEGER,expireType INTEGER,expireTime INTEGER,modificationTime INTEGER,isInBrowserElement INTEGER);
        '';

        data = let
          inherit (builtins) replaceStrings concatMap map attrNames;
          inherit (lib.strings) concatStringsSep;

          escapeString = str: "'${replaceStrings ["'"] ["''"] str}'";
          escapeInt = toString;
          permissionValue = {
            allow = 1;
            deny = 2;
            prompt = 3;
          };
        in
          pkgs.writeText "data.sql" ''
            BEGIN TRANSACTION;

            CREATE UNIQUE INDEX IF NOT EXISTS moz_perms_upsert_index ON moz_perms(origin, type);

            WITH now(unix_ms) AS (SELECT CAST((julianday('now') - 2440587.5) * 86400000 AS INTEGER))
            INSERT INTO moz_perms(origin, type, permission, expireType, expireTime, modificationTime)
            VALUES
            ${concatStringsSep ",\n"
              (concatMap
                (origin: let
                  originPermissions = permissions.${origin};
                in
                  map
                  (type: let
                    permission = permissionValue.${originPermissions.${type}};
                  in "  (${escapeString origin}, ${escapeString type}, ${escapeInt permission}, 0, 0, (SELECT unix_ms FROM now))")
                  (attrNames originPermissions))
                (attrNames permissions))}
                ON CONFLICT(origin, type) DO UPDATE SET
                  permission=excluded.permission,
                  expireType=excluded.expireType,
                  expireTime=excluded.expireTime,
                  modificationTime=excluded.modificationTime;

            COMMIT;
          '';
      in ''
        if [ ! -e ${db} ]; then
          mkdir -p $(dirname ${db})
          ${pkgs.sqlite}/bin/sqlite3 ${db} < ${schema}
        fi
        ${pkgs.sqlite}/bin/sqlite3 ${db} < ${data} || true
      '';

      darwinFirefoxPolicies = mkIf isDarwin (let
        policyFile = pkgs.writeText "policies.json" (builtins.toJSON {
          inherit (config.programs.firefox) policies;
        });
      in ''
        mkdir -p /Applications/Firefox.app/Contents/Resources/distribution
        ln -sf ${policyFile} /Applications/Firefox.app/Contents/Resources/distribution/policies.json
      '');

      darwinFirefoxNativeMessagingHosts = mkIf isDarwin ''
        mkdir -p "${mozillaConfigPath}/NativeMessagingHosts"
          for ext in ${toString nativeMessagingHosts}; do
              ln -sf $ext/lib/mozilla/native-messaging-hosts/* "${mozillaConfigPath}/NativeMessagingHosts"
          done
      '';
    };
  });
}
