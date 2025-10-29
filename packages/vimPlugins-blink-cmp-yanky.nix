{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
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
}
