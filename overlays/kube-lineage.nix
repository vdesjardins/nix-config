inputs: _self: super: {
  kube-lineage = super.buildGoModule {
    name = "kube-lineage";

    src = inputs.kube-lineage;

    vendorSha256 = "sha256-Gjrb/O/aGu+4TB8kmQTz6ptjVA8XO5W+X+WFuICEQKA=";
  };
}
