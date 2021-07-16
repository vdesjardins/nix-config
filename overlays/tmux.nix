inputs: _self: super: {
  tmux = super.tmux.overrideDerivation (
    _attrs: {
      src = inputs.tmux;
      patches = [ ];
    }
  );
}
