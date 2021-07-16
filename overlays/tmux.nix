inputs: self: super: {
  tmux = super.tmux.overrideDerivation (
    attrs: {
      src = inputs.tmux;
      patches = [ ];
    }
  );
}
