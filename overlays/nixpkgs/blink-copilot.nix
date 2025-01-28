_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-copilot = prev.vimUtils.buildVimPlugin {
        pname = "blink-copilot";
        version = "2025-01-27";

        src = prev.fetchFromGitHub {
          owner = "fang2hou";
          repo = "blink-copilot";
          rev = "7e63f20b8e96191e5c87bf96fc35da3547993be2";
          hash = "sha256-LgP1aGfj5qrKF879hLNbApM7v4V6R6ZI4nzwozpIlYI=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/fang2hou/blink-copilot";
        };
      };
    };
}
