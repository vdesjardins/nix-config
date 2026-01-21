{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) hasAttr;
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) listOf attrs;

  defaultExtensions = with inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons; [
    {
      package = darkreader;
      area = "navbar";
    }
    {package = multi-account-containers;}
    {package = open-url-in-container;}
    {package = qr-code-address-bar;}
    {package = sidebery;}
    {package = copy-link-text;}
    {package = copy-selected-links;}
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
    {
      package = buildFirefoxXpiAddon {
        pname = "tokyo-night-milav";
        version = "1.0";
        addonId = "{4520dc08-80f4-4b2e-982a-c17af42e5e4d}";
        url = "https://addons.mozilla.org/firefox/downloads/file/3952418/tokyo_night_milav-1.0.xpi";
        sha256 = "sha256-2RwxweYF6MicmHbIV1h0q2RP9ptJNHAABqkW7C8Il6w=";
        meta = with lib; {platforms = platforms.all;};
      };
    }
  ];

  cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = {
    enable = mkEnableOption "firefox browser";

    extensions = mkOption {
      type = listOf attrs;
      default = [];
    };

    enablePolicies = mkEnableOption "firefox browser policies";
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

    nativeMessagingHosts = lib.lists.concatMap (e:
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
          (pkgs.firefox.override {
            inherit nativeMessagingHosts;
            extraPrefsFiles = [
              "${./config.js}"
            ];
          });

      policies = mkIf cfg.enablePolicies {
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

            default = "ddg";
            order = ["ddg" "google"];

            engines = {
              "arXiv" = {
                urls = [
                  {
                    template = "https://arxiv.org/search?searchtype=all";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "favicon.ico";
                definedAliases = ["@a"];
              };
              "GMail" = {
                urls = [
                  {
                    template = "https://mail.google.com/mail/u/0/#search/{searchTerms}";
                  }
                ];
                icon = "favicon.ico";
                definedAliases = ["@gm"];
              };
              "GDrive" = {
                urls = [
                  {
                    template = "https://drive.google.com/drive/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "favicon.ico";
                definedAliases = ["@gd"];
              };
              "Google Keep" = {
                urls = [
                  {
                    template = "https://keep.google.com/u/0/#search/text%3D{searchTerms}";
                  }
                ];
                icon = "favicon.ico";
                definedAliases = ["@gk"];
              };
              "Google Maps" = {
                urls = [
                  {
                    template = "https://www.google.com/maps/search/{searchTerms}?hl=en&source=opensearch";
                  }
                ];
                icon = "favicon.ico";
                definedAliases = ["@m"];
              };
              "Google Photos" = {
                urls = [
                  {
                    template = "https://photos.google.com/search/{{searchTerms}}";
                  }
                ];
                icon = "favicon.ico";
                definedAliases = ["@gp"];
              };
              "Urban dictionary" = {
                urls = [
                  {
                    template = "http://www.urbandictionary.com/define.php";
                    params = [
                      {
                        name = "term";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "favicon.ico";
                definedAliases = ["@ud"];
              };
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
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
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
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
                definedAliases = ["@no"];
              };
              "NixOS Wiki" = {
                urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
                icon = "https://wiki.nixos.org/favicon.ico";
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
                icon = "https://github.com/favicon.ico";
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
                icon = "https://github.com/favicon.ico";
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
                icon = "https://github.com/favicon.ico";
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
                icon = "https://github.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ghnh"];
              };
              "Grep.app" = {
                urls = [
                  {
                    template = "https://grep.app/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "https://grep.app/icon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ga"];
              };
              "Grep.app (Nix)" = {
                urls = [
                  {
                    template = "https://grep.app/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                      {
                        name = "f.lang";
                        value = "Nix";
                      }
                    ];
                  }
                ];
                icon = "https://grep.app/icon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@gan"];
              };
              "Grep.app (Nixpkgs)" = {
                urls = [
                  {
                    template = "https://grep.app/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                      {
                        name = "f.lang";
                        value = "Nix";
                      }
                      {
                        name = "f.repo";
                        value = "NixOS/nixpkgs";
                      }
                    ];
                  }
                ];
                icon = "https://grep.app/icon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ganp"];
              };
              "Grep.app (home-manager)" = {
                urls = [
                  {
                    template = "https://grep.app/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                      {
                        name = "f.lang";
                        value = "Nix";
                      }
                      {
                        name = "f.repo";
                        value = "nix-community/home-manager";
                      }
                    ];
                  }
                ];
                icon = "https://grep.app/icon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@ganh"];
              };
              "Amazon.ca" = {
                urls = [
                  {
                    template = "https://www.amazon.ca/s";
                    params = [
                      {
                        name = "k";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "https://www.amazon.ca/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@az"];
              };
              "wikipedia".metaData.alias = "@w";
              "google".metaData.alias = "@g";
              "bing".metaData.hidden = true;
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
            "browser.tabs.splitView.enabled" = true;
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

    xdg.mimeApps = {
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "image/svg+xml" = "firefox.desktop";
      };
    };

    wayland.windowManager.hyprland.settings = {
      windowrule = [
        "match:class (firefox), match:title (Picture-in-Picture), float on"
        "match:class (firefox), match:title (Picture-in-Picture), size 1500 1000"
        "match:class (firefox), match:title ^Extension:.*Bitwarden.*, float on"
        "match:class (firefox), match:title ^Extension:.*Bitwarden.*, size 400 600"
        "match:class (firefox), match:title (Gmail), workspace 9"
        "match:class (firefox), match:title (mail.proton.me), workspace 9"
        "match:class (firefox), match:title (dicord.com), workspace 7"
        "match:class (firefox), match:title .*Google Calendar.*, workspace 8"
      ];
    };

    wayland.windowManager.sway.config = {
      window.commands = [
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
          escapeString = str: "'${builtins.replaceStrings ["'"] ["''"] str}'";
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
            ${lib.strings.concatStringsSep ",\n"
              (builtins.concatMap
                (origin: let
                  originPermissions = permissions.${origin};
                in
                  map
                  (type: let
                    permission = permissionValue.${originPermissions.${type}};
                  in "  (${escapeString origin}, ${escapeString type}, ${escapeInt permission}, 0, 0, (SELECT unix_ms FROM now))")
                  (builtins.attrNames originPermissions))
                (builtins.attrNames permissions))}
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

      darwinFirefoxPolicies = mkIf (isDarwin && cfg.enablePolicies) (let
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
