inputs: _self: super: {
  kubernetes = super.kubernetes.overrideDerivation (
    _attrs: {
      version = "master";
      src = inputs.kubernetes;
    }
  );
}
