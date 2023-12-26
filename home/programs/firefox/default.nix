{
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;

    package =
      if pkgs.stdenv.isDarwin
      then null # unable to compile on M1. Relying on brew for now
      else
        pkgs.firefox.override {
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
            "Wikipedia (en)".metaData.alias = "@wiki";
            "Google".metaData.hidden = false;
            "Amazon.com".metaData.hidden = false;
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
        };

        settings = {
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.startup.page" = 3;
          "extensions.pocket.enabled" = false;
          "identity.fxaccounts.toolbar.enabled" = false;
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          darkreader
          dictionaries
          duckduckgo-privacy-essentials
          firefox-color
          # TODO: convert this to a module to be able to add this extension from the granted program
          granted
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
}
