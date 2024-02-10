{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = {
    enable = mkEnableOption "firefox browser";
  };

  config = mkIf cfg.enable {
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
          };

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            darkreader
            dictionaries
            duckduckgo-privacy-essentials
            firefox-color
            keepass-helper
            qr-code-address-bar
            raindropio
            tridactyl
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
          ];
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
            title = "^Picture-in-Picture$";
          };
          command = "floating enable, sticky enable, border pixel 0, move position 1340 722, opacity 0.95";
        }
      ];
    };
  };
}
