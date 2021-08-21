inputs: _self: super: {
  tmux = super.tmux.overrideDerivation (
    _attrs: {
      src = inputs.tmux;
      patches = [ ];
      buildInputs = super.tmux.buildInputs ++ [ super.utf8proc ];
      configureFlags = super.tmux.configureFlags ++ [ "--enable-utf8proc" ];
    }
  );
}
