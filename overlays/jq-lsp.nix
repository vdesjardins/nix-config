inputs: _self: super: {
  jq-lsp = super.buildGoModule {
    name = "jq-lsp";

    src = inputs.jq-lsp;

    vendorHash = "sha256-8sZGnoP7l09ZzLJqq8TUCquTOPF0qiwZcFhojUnnEIY=";

    doCheck = false;
  };
}
