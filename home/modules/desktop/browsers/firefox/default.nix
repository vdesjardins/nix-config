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
      internalUUID = "278bad82-9303-4f35-b279-90490fc97bce";
      permissions = {
        "storageAccessAPI" = "allow";
      };
      package = darkreader;
    }
    {
      internalUUID = "f90c1241-cae9-466d-ad56-8621626b0e32";
      permissions = {
        "storageAccessAPI" = "allow";
      };
      package = tridactyl;
    }
    {
      internalUUID = "46536cfa-1e11-4a7b-9905-20875fe39b0c";
      permissions = {
        "WebExtensions-unlimitedStorage" = "allow";
        "persistent-storage" = "allow";
        "storageAccessAPI" = "allow";
      };
      package = bitwarden;
    }
    {
      internalUUID = "081d3506-83c6-4121-ad31-c7866bb71f67";
      permissions = {
        "storageAccessAPI" = "allow";
      };
      package = bukubrow;
    }
    {
      internalUUID = "a06edab8-9c95-4544-843f-85a87e3a32a0";
      package = firefox-color;
    }
    {
      internalUUID = "e3aa3d9e-31ea-4fd7-8e86-f335aafbfb73";
      package = raindropio;
    }
    {
      internalUUID = "059ce4cb-63f5-4042-9271-da4c138dc151";
      package = dictionaries;
    }
    {
      internalUUID = "5804f91f-19db-4afb-b26e-19b5970fc32d";
      package = qr-code-address-bar;
    }
    {
      internalUUID = "77936605-0e70-44b3-bed8-ba82df1f504f";
      package = duckduckgo-privacy-essentials;
    }
    {
      internalUUID = "1467720b-3ef4-469b-9737-818f0449dc53";
      package = buildFirefoxXpiAddon {
        pname = "add-url-to-window-title";
        version = "2.2.1";
        addonId = "autt@ericgoldman.name";
        url = "https://addons.mozilla.org/firefox/downloads/file/1685708/add_url_to_window_title-2.2.1.xpi";
        sha256 = "sha256-teUYOE26S6ikPNQ/F+QTqZlzw+2/5e2nxve9Q8pR4l0=";
        meta = with lib; {platforms = platforms.all;};
      };
      permissions = {
        "storageAccessAPI" = "allow";
      };
    }
    # bundled firefox extensions
    {
      addonId = "formautofill@mozilla.org";
      internalUUID = "65b54ed4-1276-4979-bb34-2ee83244208a";
    }
    {
      addonId = "formautofill@mozilla.org";
      internalUUID = "65b54ed4-1276-4979-bb34-2ee83244208a";
    }
    {
      addonId = "pictureinpicture@mozilla.org";
      internalUUID = "12d18d86-cff1-4399-b923-2f5b6bb34935";
    }
    {
      addonId = "screenshots@mozilla.org";
      internalUUID = "7b65c3dc-ef97-4745-8373-e0818aef8234";
    }
    {
      addonId = "webcompat-reporter@mozilla.org";
      internalUUID = "aebf9fb4-c8a4-4e8d-ad7f-00f693bf6f9a";
    }
    {
      addonId = "webcompat@mozilla.org";
      internalUUID = "8560d354-e6cf-488a-aba6-9870a0701706";
    }
    {
      addonId = "default-theme@mozilla.org";
      internalUUID = "723e55c0-97f1-4720-bd8d-dcee7fd88376";
    }
    {
      addonId = "addons-search-detection@mozilla.com";
      internalUUID = "cd923326-5864-4f2f-b5f9-32b28c0ff6e2";
    }
    {
      addonId = "google@search.mozilla.org";
      internalUUID = "670278f4-421a-4433-8047-ee881de717a9";
    }
    {
      addonId = "wikipedia@search.mozilla.org";
      internalUUID = "5c402f1d-e0f8-4b92-87f7-61d89c3065c3";
    }
    {
      addonId = "bing@search.mozilla.org";
      internalUUID = "2746852c-c45b-4885-9766-3d4beafee4ee";
    }
    {
      addonId = "ddg@search.mozilla.org";
      internalUUID = "d49d3758-74d2-45b8-a0af-898c24d357cc";
    }
    {
      addonId = "amazon@search.mozilla.org";
      internalUUID = "c8c11263-2986-4f2c-89c3-1ad12f575a72";
    }
    {
      addonId = "ebay@search.mozilla.org";
      internalUUID = "8db3a588-aa91-4c84-9dd2-8458e000584a";
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
  };

  config = mkIf cfg.enable (let
    extensions = defaultExtensions ++ cfg.extensions;

    extensionPackages = lib.concatMap (e:
      if hasAttr "package" e
      then [e.package]
      else [])
    extensions;

    uuidMappings = builtins.toJSON (lib.listToAttrs (lib.concatMap (e:
      if (hasAttr "package" e) || (hasAttr "addonId" e)
      then [
        {
          name =
            if hasAttr "package" e
            then e.package.addonId
            else e.addonId;
          value = e.internalUUID;
        }
      ]
      else [])
    extensions));

    extensionPermissions = lib.listToAttrs (lib.concatMap (e:
      if hasAttr "permissions" e
      then [
        {
          name = "moz-extension://${e.internalUUID}";
          value = e.permissions;
        }
      ]
      else [])
    extensions);
  in {
    programs.firefox = {
      inherit (cfg) enable;

      package =
        if pkgs.stdenv.isDarwin
        then null # unable to compile on M1. Relying on brew for now
        else
          pkgs.firefox-wayland.override {
            nativeMessagingHosts = with pkgs; [
              tridactyl-native
            ];
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

            "extensions.webextensions.uuids" = uuidMappings;
          };

          extensions = with pkgs.nur.repos.rycee.firefox-addons;
            [
              # color scheme tokyonight storm from https://github.com/lokesh-krishna/dotfiles/tree/main/tokyo-night
              # generated with firefox-color from url: https://color.firefox.com/?theme=XQAAAAKPAgAAAAAAAABBqYhm849SCicxcUJJ2CuG_ebZUZXOFqpMUXOqPCZ36qSRJkXN52FbbTjiyK1MWFJNETZQ0wYF4uVCIywstutBMeAW7Obsj80UcPJQAnIVpdPOctZ5qwuxzdELFY4rFOFPOTJ56RTVDwA4OBpstebirCu7hY0081_kMAs5kyLOhcBXVznGEJZ8hLEKcsRDWIpmds_f9Bz4MLMjGF7kJmKEH1RnLL_dJvGnMgclfyzqTqHxYRhUWrgMfQmbcvGavbRFEetLZGVRbQ5P8k0F0PyfAFgTc6TBQIiKVQa2zX8gZ3Gru31J5KGfZrIaMw2B-eKScfJjrqEILop2n4DLLEe_lqL3ujDgM0Uv8i9nwGVvvQNj_vGGxQ
              ((buildFirefoxXpiAddon {
                  pname = "tokyonight-storm-theme";
                  version = "0.0.1";
                  addonId = "tokyonight-storm.theme@0.0.1";
                  url = "file://./theme.xpi";
                  sha256 = lib.fakeSha256;
                  meta = with lib; {platforms = platforms.all;};
                })
                .overrideAttrs
                (old: {
                  src = ./theme.xpi;
                }))
            ]
            ++ extensionPackages;
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

    home.activation.firefoxPermissions = let
      permissions =
        {
          "https://mail.google.com" = {
            "desktop-notification" = "allow";
            "storageAccessAPI" = "allow";
          };
          "https://mail.proton.me" = {
            "desktop-notification" = "allow";
            "storageAccessAPI" = "allow";
          };
          "https://calendar.google.com" = {
            "desktop-notification" = "allow";
            "storageAccessAPI" = "allow";
          };
        }
        // extensionPermissions;

      db = lib.escapeShellArg "${config.home.homeDirectory}/.mozilla/firefox/default/permissions.sqlite";

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
  });
}
