_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-copilot = prev.vimUtils.buildVimPlugin {
        pname = "blink-copilot";
        version = "2025-03-01";

        src = prev.fetchFromGitHub {
          owner = "fang2hou";
          repo = "blink-copilot";
          rev = "08ed48deb89a6b39fdb46fb7e6aee426ae174c09";
          hash = "sha256-V57myzoWJP077Xcks/tdK+YPUdVe0Z8QaBpfSZmvEEM=";
        };

        doCheck = false;

        meta = {
          description = "Configurable GitHub Copilot blink.cmp source for Neovim";
          homepage = "https://github.com/fang2hou/blink-copilot";
        };
      };
    };
}
