inputs: _self: super: {
  jq-lsp = super.buildGoModule {
    name = "jq-lsp";

    src = inputs.jq-lsp;

    vendorHash = "sha256-ppQ81uERHBgOr/bm/CoDSWcK+IqHwvcL6RFi0DgoLuw=";

    doCheck = false;
  };
}
