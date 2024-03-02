{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "base16-fzf";
  version = "unstable-2024-02-23";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-fzf";
    rev = "51e58f8396fe75ca790ac372adbcf72b3c7e6542";
    hash = "sha256-nx+mOL6wGkwDPfE8q3QHWwKuLtjTmYPOlsNk8TYyVQ0=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/base16-fzf
    cp -a ./bash $out/share/base16-fzf/
    cp -a ./fish $out/share/base16-fzf/
  '';

  meta = with lib; {
    description = "Base16 colorschemes for fzf";
    homepage = "https://github.com/tinted-theming/base16-fzf";
    license = licenses.mit;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "base16-fzf";
    platforms = platforms.all;
  };
}
