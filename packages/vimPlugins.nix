{
  lib,
  fetchFromGitHub,
  vimUtils,
  newScope,
}:
lib.makeScope newScope (self: {
  codecompanion = vimUtils.buildVimPlugin rec {
    pname = "codecompanion.nvim";
    version = "17.26.0";

    src = fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "v${version}";
      hash = "sha256-uVgkx1t6uBJ0HJLvo2FbR+ToW8a6JpuzjdCp0YvM+Yg=";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/olimorris/codecompanion.nvim";
    };
  };

  codecompanion-history = vimUtils.buildVimPlugin {
    pname = "codecompanion-history";
    version = "0-unstable-2025-09-07";

    src = fetchFromGitHub {
      owner = "ravitemer";
      repo = "codecompanion-history.nvim";
      rev = "eb99d256352144cf3b6a1c45608ec25544a0813d";
      hash = "sha256-0haETLOVASaFRpRF98IxFKOLbY873D5LDHfdcuEp0W4=";
    };

    doCheck = false;

    meta.homepage = "https://github.com/ravitemer/codecompanion-history.nvim";
  };

  kcl = vimUtils.buildVimPlugin {
    pname = "kcl.nvim";
    version = "0-unstable-2024-09-11";

    src = fetchFromGitHub {
      owner = "kcl-lang";
      repo = "kcl.nvim";
      rev = "beededb5a8ed01ba2d121ed053aa6380ecb59597";
      hash = "sha256-8tslNwnprsrhRjW6Wf+pzVvtJyfVUIslb1Sg5X5ERpc=";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/kcl-lang/kcl.nvim";
    };
  };

  noice-nvim = vimUtils.buildVimPlugin {
    pname = "noice.nvim";
    version = "4.10.0-unstable-2025-10-08";

    src = fetchFromGitHub {
      owner = "folke";
      repo = "noice.nvim";
      rev = "38c702be0d8fea81527ee6a73e1e834e72481193";
      hash = "sha256-l75Ml6S0LFh8DisOCnFoQ18Yp5y3247YOpPFRVaQLzo=";
    };

    doCheck = false;

    meta = {
      description = "💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu. ";
      homepage = "https://github.com/folke/noice.nvim";
    };
  };

  markview-nvim = vimUtils.buildVimPlugin rec {
    pname = "markview.nvim";
    version = "26.0.1";

    src = fetchFromGitHub {
      owner = "OXY2DEV";
      repo = "markview.nvim";
      rev = "v${version}";
      hash = "sha256-c8kvtC9PuFtKPbdrTWQFX3Hsw7vwYXVDSQ5/W46s2ZM=";
      fetchSubmodules = true;
    };

    doCheck = false;

    meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
  };

  snacks-nvim = vimUtils.buildVimPlugin rec {
    pname = "snacks.nvim";
    version = "2.23.0";

    src = fetchFromGitHub {
      owner = "folke";
      repo = "snacks.nvim";
      rev = "v${version}";
      hash = "sha256-VSvLnZclLo441jDGFJdk8fgZ+vtBuQV6mRLG2XXf7Jc=";
    };

    doCheck = false;

    meta = {
      description = "🍿 A collection of QoL plugins for Neovim";
      homepage = "https://github.com/folke/snacks.nvim";
    };
  };

  trouble-nvim = vimUtils.buildVimPlugin rec {
    pname = "trouble.nvim";
    version = "3.7.1";

    src = fetchFromGitHub {
      owner = "folke";
      repo = "trouble.nvim";
      rev = "v${version}";
      hash = "sha256-F3LSA1iAF8TEI7ecyuWVe3FrpSddUf3OjJA/KGfdW/8=";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/folke/trouble.nvim";
    };
  };

  blink-emoji = vimUtils.buildVimPlugin {
    pname = "blink-emoji";
    version = "0-unstable-2025-05-24";

    src = fetchFromGitHub {
      owner = "moyiz";
      repo = "blink-emoji.nvim";
      rev = "f22ce8cac02a6ece05368220f1e38bd34fe376f9";
      hash = "sha256-pPHESNsByHg2liNUYkUEVR1wP1MZcil1sKTqrNI53e4=";
    };

    doCheck = false;

    meta = {
      description = "Emoji source for blink.cmp";
      homepage = "https://github.com/moyiz/blink-emoji.nvim";
    };
  };

  blink-cmp-yanky = vimUtils.buildVimPlugin {
    pname = "blink-cmp-yanky";
    version = "0-unstable-2025-06-24";

    src = fetchFromGitHub {
      owner = "marcoSven";
      repo = "blink-cmp-yanky";
      rev = "473b987c2a7d80cca116f6faf087dba4dbfbb3c5";
      hash = "sha256-DciQaX2lYQptpEd8wke3x67SK6zMm2UI34qxBe6eC9Q=";
    };

    doCheck = false;

    meta = {
      description = "Yanky source for blink.cmp";
      homepage = "https://github.com/marcoSven/blink-cmp-yanky";
    };
  };

  blink-copilot = vimUtils.buildVimPlugin {
    pname = "blink-copilot";
    version = "1.4.1-unstable-2025-09-30";

    src = fetchFromGitHub {
      owner = "fang2hou";
      repo = "blink-copilot";
      rev = "5d35fd07fcc148be20442da1bdd2407e03263d7d";
      hash = "sha256-s57/vIMvWoumP/Sp+3JMv0bHOf4rq33aEWPMLJdsBpk=";
    };

    doCheck = false;

    meta = {
      description = "Configurable GitHub Copilot blink.cmp source for Neovim";
      homepage = "https://github.com/fang2hou/blink-copilot";
    };
  };

  blink-cmp-dictionary = vimUtils.buildVimPlugin {
    pname = "blink-cmp-dictionary";
    version = "2.0.0-unstable-2025-06-20";

    src = fetchFromGitHub {
      owner = "Kaiser-Yang";
      repo = "blink-cmp-dictionary";
      rev = "43b701fe9728a704bc63e4667c5d8b398bf129b2";
      hash = "sha256-szCNbYLWkJTAVGWz9iRFh7NfQfM5t5jcQHdQeKzBx30=";
    };

    doCheck = false;

    meta = {
      description = "Emoji source for blink.cmp";
      homepage = "https://github.com/moyiz/blink-emoji.nvim";
    };
  };
})
