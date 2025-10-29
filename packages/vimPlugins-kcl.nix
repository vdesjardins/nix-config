{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
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
}
