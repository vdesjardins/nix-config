inputs: _self: super: {
  base16-fzf = super.stdenv.mkDerivation {
    name = "base16-fzf";

    src = inputs.base16-fzf;

    phases = ["unpackPhase" "installPhase"];

    installPhase = ''
      mkdir -p $out/share/base16-fzf
      cp -a ./bash $out/share/base16-fzf/
      cp -a ./fish $out/share/base16-fzf/
    '';
  };
}
