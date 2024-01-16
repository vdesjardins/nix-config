_inputs: _self: super: {
  spotifyd = super.spotifyd.override {withKeyring = true;};
}
