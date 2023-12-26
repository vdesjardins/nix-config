inputs: _self: super: {
  jq-lsp = super.buildGoModule {
    name = "jq-lsp";

    src = inputs.jq-lsp;

    vendorHash = "sha256-bIe006I1ryvIJ4hC94Ux2YVdlmDIM4oZaK/qXafYYe0=";

    doCheck = false;
  };
}
