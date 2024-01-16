inputs: _self: super: {
  kube-capacity = super.buildGoModule {
    name = "kube-capacity";

    src = inputs.kube-capacity;

    vendorHash = "sha256-qfSya42wZEmJCC7o8zJQEv0BWrxTuBT2Jzcq/AfI+OE=";
  };
}
