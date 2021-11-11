_inputs: _self: super: {
  nix-zsh-completions = super.nix-zsh-completions.overrideAttrs (_: {
    preFixup = ''
      rm $out/share/zsh/site-functions/_nix
    '';
  });
}
