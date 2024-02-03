{...}: {
  # do not listen on port 53 with resolved
  services.resolved = {
    extraConfig = ''
      DNSStubListener=false
    '';
  };

  networking.firewall.allowedTCPPorts = [53 4000];
  networking.firewall.allowedUDPPorts = [53];

  services.blocky = {
    enable = true;

    settings = {
      connectIPVersion = "v4";
      upstreamTimeout = "5s";
      startVerifyUpstream = false;
      minTlsServeVersion = "1.2";
      log = {
        level = "debug";
        privacy = true;
      };
      ports = {
        dns = 53;
        http = 4000;
        https = 443;
        tls = 853;
      };
      upstreams = {
        strategy = "strict";
        timeout = "30s";

        groups = {
          default = [
            "9.9.9.9"
            "tcp-tls:dns.quad9.net"
          ];
        };
      };
      blocking = {
        blockType = "nxDomain";

        loading = {
          strategy = "fast";
          concurrency = 8;
          refreshPeriod = "4h";
        };

        blackLists = {
          ads = [
            "https://adaway.org/hosts.txt"
            "https://blocklistproject.github.io/Lists/ads.txt"
            "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
            "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://v.firebog.net/hosts/Easylist.txt"
          ];
          tracking = [
            "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
          ];
          malicious = [
            "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt"
            "https://phishing.army/download/phishing_army_blocklist_extended.txt"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt"
            "https://v.firebog.net/hosts/Prigent-Crypto.txt"
            "https://v.firebog.net/hosts/RPiList-Malware.txt"
            "https://v.firebog.net/hosts/RPiList-Phishing.txt"
          ];
          misc = [
            "https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt"
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-only/hosts"
            "https://v.firebog.net/hosts/static/w3kbl.txt"
            "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"
          ];
          catchall = [
            "https://big.oisd.nl/domainswild"
          ];
        };

        whiteLists = {
          default = [
            "https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"
            "https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt"
          ];
        };
        clientGroupsBlock = {
          default = [
            "ads"
            "tracking"
            "malicious"
            "misc"
            "catchall"
          ];
        };
      };

      customDNS = {
        customTTL = "1h";
        mapping = {
          "home-server.internal.kubestack.io" = "192.168.50.2";
          "printer.internal.kubestack.io" = "192.168.50.190";
        };
      };

      caching = {
        minTime = "2h";
        maxTime = "12h";
        maxItemsCount = 0;
        prefetching = true;
        prefetchExpires = "2h";
        prefetchThreshold = 5;
      };

      prometheus = {
        enable = true;
        path = "/metrics";
      };

      queryLog = {
        type = "console";
      };
    };
  };
}
